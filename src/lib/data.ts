import { supabase } from '../config/supabase';
import type { Fish, FishActivity, FishDetail, WaterBody, WaterBodyDetail, WaterBodyDistance } from '../types/database';

let regulationSyncPromise: Promise<unknown> | null = null;

export async function syncFishingRules() {
  if (!supabase) return { ok: false, error: new Error('Supabase yapılandırılmamış') };
  if (regulationSyncPromise) return regulationSyncPromise;
  regulationSyncPromise = supabase.functions.invoke('sync-fishing-rules', { body: { reason: 'app_connection' } })
    .then(({ data, error }) => ({ ok: !error && data?.ok !== false, data, error }))
    .finally(() => { regulationSyncPromise = null; });
  return regulationSyncPromise;
}

const waterSelect = 'id,name,water_type,province,district,latitude,longitude,fishing_allowed,verification_level,access_level,location_precision,source_url,last_verified_at,verification_notes';

export async function getWaterBodies(filters?: { province?: string; district?: string; search?: string }) {
  if (!supabase) return { data: [] as WaterBody[], error: new Error('Supabase yapılandırılmamış') };
  let query = supabase.from('water_bodies').select(waterSelect).order('name');
  if (filters?.province) query = query.eq('province', filters.province);
  if (filters?.district) query = query.eq('district', filters.district);
  if (filters?.search) query = query.or(`name.ilike.%${filters.search}%,province.ilike.%${filters.search}%,district.ilike.%${filters.search}%`);
  const { data, error } = await query;
  return { data: (data ?? []) as WaterBody[], error };
}

export function sortByDistance(items: WaterBody[], latitude: number, longitude: number): WaterBodyDistance[] {
  const r = 6371; const radians = (v: number) => v * Math.PI / 180;
  return items.map(item => {
    if (item.latitude == null || item.longitude == null) return { ...item, distance_km: undefined };
    const dLat = radians(Number(item.latitude) - latitude), dLon = radians(Number(item.longitude) - longitude);
    const a = Math.sin(dLat / 2) ** 2 + Math.cos(radians(latitude)) * Math.cos(radians(Number(item.latitude))) * Math.sin(dLon / 2) ** 2;
    return { ...item, distance_km: r * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)) };
  }).sort((a, b) => (a.distance_km ?? Infinity) - (b.distance_km ?? Infinity));
}

export async function getFish(search?: string) {
  if (!supabase) return { data: [] as Fish[], error: new Error('Supabase yapılandırılmamış') };
  let query = supabase.from('fish_species').select('id,common_name_tr,scientific_name,description,habitat').order('common_name_tr');
  if (search) query = query.ilike('common_name_tr', `%${search}%`);
  const { data, error } = await query;
  return { data: (data ?? []) as Fish[], error };
}

export async function getWaterBodyDetail(id: string) {
  if (!supabase) return { data: null as WaterBodyDetail | null, error: new Error('Supabase yapılandırılmamış') };
  const water = await supabase.from('water_bodies').select(waterSelect).eq('id', id).maybeSingle();
  if (water.error || !water.data) return { data: null as WaterBodyDetail | null, error: water.error ?? new Error('Su kaynağı bulunamadı') };
  const relation = await supabase.from('fish_water_bodies').select('fish_species(id,common_name_tr,scientific_name,description,habitat)').eq('water_body_id', id);
  if (relation.error) return { data: { waterBody: water.data as WaterBody, fish: [] }, error: relation.error };
  const fish = (relation.data ?? []).map((row: any) => row.fish_species).filter(Boolean) as Fish[];
  return { data: { waterBody: water.data as WaterBody, fish }, error: null };
}

export async function getFishDetail(id: string) {
  if (!supabase) return { data: null as FishDetail | null, error: new Error('Supabase yapılandırılmamış') };
  const fishResult = await supabase.from('fish_species').select('id,common_name_tr,scientific_name,description,habitat').eq('id', id).maybeSingle();
  if (fishResult.error || !fishResult.data) return { data: null as FishDetail | null, error: fishResult.error ?? new Error('Balık kaydı bulunamadı') };

  const [methodsResult, baitsResult, rulesResult, watersResult, activityResult] = await Promise.all([
    supabase.from('fish_methods').select('fishing_methods(id,name,description)').eq('fish_id', id),
    supabase.from('fish_baits').select('baits(id,name,description,notes)').eq('fish_id', id),
    supabase.from('fishing_rules').select('id,regulation_name,source_reference,closed_start,closed_end,valid_from,valid_to,status,notes').eq('fish_id', id).order('valid_from', { ascending: false }),
    supabase.from('fish_water_bodies').select(`water_bodies(${waterSelect})`).eq('fish_id', id),
    supabase.from('fish_activity_calendar').select('id,month,activity_level,depth_note,method_note,bait_note,source_url,last_verified_at').eq('fish_id', id).order('month'),
  ]);

  const methods = (methodsResult.data ?? []).map((r: any) => r.fishing_methods ? ({ ...r.fishing_methods, suitable_for: r.suitability ?? null }) : null).filter(Boolean);
  const baits = (baitsResult.data ?? []).map((r: any) => r.baits).filter(Boolean);
  const rules = (rulesResult.data ?? []).map((r: any) => ({ id: r.id, title: r.regulation_name, summary: [r.status, r.notes].filter(Boolean).join(' — '), source_url: r.source_reference ?? null, effective_from: r.closed_start ?? r.valid_from ?? null, effective_to: r.closed_end ?? r.valid_to ?? null }));
  const waterBodies = (watersResult.data ?? []).map((r: any) => r.water_bodies).filter(Boolean) as WaterBody[];
  const activity = (activityResult.data ?? []) as FishActivity[];
  const error = methodsResult.error ?? baitsResult.error ?? rulesResult.error ?? watersResult.error ?? activityResult.error ?? null;
  return { data: { fish: fishResult.data as Fish, methods, baits, rules, waterBodies, activity }, error };
}
