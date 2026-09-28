import { supabase } from '../config/supabase';
import type { Fish, FishDetail, WaterBody, WaterBodyDetail, WaterBodyDistance } from '../types/database';

let regulationSyncPromise: Promise<unknown> | null = null;

export async function syncFishingRules() {
  if (!supabase) return { ok: false, error: new Error('Supabase yapılandırılmamış') };
  if (regulationSyncPromise) return regulationSyncPromise;
  regulationSyncPromise = supabase.functions.invoke('sync-fishing-rules', { body: { reason: 'app_connection' } })
    .then(({ data, error }) => ({ ok: !error && data?.ok !== false, data, error }))
    .finally(() => { regulationSyncPromise = null; });
  return regulationSyncPromise;
}

export async function getWaterBodies(filters?: { province?: string; district?: string; search?: string }) {
  if (!supabase) return { data: [] as WaterBody[], error: new Error('Supabase yapılandırılmamış') };
  let query = supabase.from('water_bodies').select('id,name,water_type,province,district,latitude,longitude,fishing_allowed,verification_level').order('name');
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
  const water = await supabase.from('water_bodies').select('id,name,water_type,province,district,latitude,longitude,fishing_allowed,verification_level').eq('id', id).maybeSingle();
  if (water.error || !water.data) return { data: null as WaterBodyDetail | null, error: water.error ?? new Error('Su kaynağı bulunamadı') };
  const relation = await supabase.from('water_body_fish').select('fish_species(id,common_name_tr,scientific_name,description,habitat)').eq('water_body_id', id);
  if (relation.error) return { data: { waterBody: water.data as WaterBody, fish: [] }, error: relation.error };
  const fish = (relation.data ?? []).map((row: any) => row.fish_species).filter(Boolean) as Fish[];
  return { data: { waterBody: water.data as WaterBody, fish }, error: null };
}

export async function getFishDetail(id: string) {
  if (!supabase) return { data: null as FishDetail | null, error: new Error('Supabase yapılandırılmamış') };
  const fishResult = await supabase.from('fish_species').select('id,common_name_tr,scientific_name,description,habitat').eq('id', id).maybeSingle();
  if (fishResult.error || !fishResult.data) return { data: null as FishDetail | null, error: fishResult.error ?? new Error('Balık kaydı bulunamadı') };

  const [methodsResult, baitsResult, rulesResult, watersResult] = await Promise.all([
    supabase.from('fish_species_methods').select('fishing_methods(id,name,description,suitable_for)').eq('fish_species_id', id),
    supabase.from('fish_species_baits').select('baits(id,name,description,notes)').eq('fish_species_id', id),
    supabase.from('fishing_rules').select('id,title,summary,source_url,effective_from,effective_to').eq('fish_species_id', id).order('effective_from', { ascending: false }),
    supabase.from('water_body_fish').select('water_bodies(id,name,water_type,province,district,latitude,longitude,fishing_allowed,verification_level)').eq('fish_species_id', id),
  ]);

  const methods = (methodsResult.data ?? []).map((r: any) => r.fishing_methods).filter(Boolean);
  const baits = (baitsResult.data ?? []).map((r: any) => r.baits).filter(Boolean);
  const rules = rulesResult.data ?? [];
  const waterBodies = (watersResult.data ?? []).map((r: any) => r.water_bodies).filter(Boolean) as WaterBody[];
  const error = methodsResult.error ?? baitsResult.error ?? rulesResult.error ?? watersResult.error ?? null;
  return { data: { fish: fishResult.data as Fish, methods, baits, rules, waterBodies }, error };
}
