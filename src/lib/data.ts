import { supabase } from '../config/supabase';
import type { Fish, FishActivity, FishDetail, FishingArea, WaterBody, WaterBodyDetail, WaterBodyDistance } from '../types/database';

const waterSelect = 'id,name,normalized_name,water_type,province_id,latitude,longitude,basin_name,description,source_id,verification_level,verification_status,last_verified_at,source_checked_at,source_reference,fishing_relevance,fishing_relevance_confidence,coordinate_confidence_grade,coordinate_confidence_note,community_confidence_grade,provinces(name),sources(name,url,verification_status)';

function mapWaterBody(row: any): WaterBody {
  const sourceReference = row.source_reference ?? null;
  return {
    id: row.id,
    name: row.name,
    water_type: row.water_type ?? null,
    province: row.provinces?.name ?? null,
        latitude: row.latitude == null ? null : Number(row.latitude),
    longitude: row.longitude == null ? null : Number(row.longitude),
    fishing_allowed: null,
    verification_level: row.verification_level ?? null,
    verification_status: row.verification_status ?? null,
    access_level: null,
    location_precision: null,
    source_url: row.sources?.url ?? (typeof sourceReference === 'string' && /^https?:\/\//i.test(sourceReference) ? sourceReference : null),
    source_name: row.sources?.name ?? null,
    source_status: row.sources?.verification_status ?? null,
    source_reference: sourceReference,
    description: row.description ?? null,
    last_verified_at: row.last_verified_at ?? row.source_checked_at ?? null,
    verification_notes: null,
    source_id: row.source_id ?? null,
    basin_name: row.basin_name ?? null,
    fishing_relevance: row.fishing_relevance ?? null,
    fishing_relevance_confidence: row.fishing_relevance_confidence ?? null,
    coordinate_confidence_grade: row.coordinate_confidence_grade ?? 'F',
    coordinate_confidence_note: row.coordinate_confidence_note ?? null,
    community_confidence_grade: row.community_confidence_grade ?? 'F',
  };
}

export async function getWaterBodies(filters?: { province?: string; search?: string }) {
  if (!supabase) return { data: [] as WaterBody[], error: new Error('Supabase yapılandırılmamış') };
  const pageSize = 500;
  const rows: any[] = [];
  for (let from = 0; ; from += pageSize) {
    const { data, error } = await supabase.from('water_bodies')
      .select(waterSelect)
      .order('name')
      .range(from, from + pageSize - 1);
    if (error) return { data: rows.map(mapWaterBody), error };
    rows.push(...(data ?? []));
    if (!data || data.length < pageSize) break;
  }

  const q = filters?.search?.trim().toLocaleLowerCase('tr-TR');
  const data = rows.map(mapWaterBody).filter(item =>
    (!filters?.province || item.province === filters.province) &&
        (!q || [item.name, item.province, item.basin_name]
      .filter(Boolean).some(value => String(value).toLocaleLowerCase('tr-TR').includes(q)))
  );
  return { data, error: null };
}

export async function getFishingAreas(search?: string) {
  if (!supabase) return { data: [] as FishingArea[], error: new Error('Supabase yapılandırılmamış') };
  const pageSize = 500;
  const rows: FishingArea[] = [];
  for (let from = 0; ; from += pageSize) {
    const { data, error } = await supabase.from('fishing_areas')
      .select('id,source_slug,name,province_name,zone_name,water_type,source_grade,location_confidence_grade,source_url,source_name,general_note,coordinates_imported,latitude,longitude,coordinate_status,coordinate_note,source_checked_at')
      .order('name')
      .range(from, from + pageSize - 1);
    if (error) return { data: rows, error };
    rows.push(...((data ?? []) as FishingArea[]));
    if (!data || data.length < pageSize) break;
  }
  const q = search?.trim().toLocaleLowerCase('tr-TR');
  return { data: rows.filter(item => !q || [item.name,item.province_name,item.zone_name,item.water_type]
    .filter(Boolean).some(value => String(value).toLocaleLowerCase('tr-TR').includes(q))), error: null };
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
  const relation = await supabase.from('fish_water_bodies')
    .select('fish_species(id,common_name_tr,scientific_name,description,habitat)')
    .eq('water_body_id', id);
  if (relation.error) return { data: { waterBody: mapWaterBody(water.data), fish: [] }, error: relation.error };
  const fish = (relation.data ?? []).map((row: any) => row.fish_species).filter(Boolean) as Fish[];
  return { data: { waterBody: mapWaterBody(water.data), fish }, error: null };
}

export async function getFishDetail(id: string) {
  if (!supabase) return { data: null as FishDetail | null, error: new Error('Supabase yapılandırılmamış') };
  const fishResult = await supabase.from('fish_species')
    .select('id,common_name_tr,scientific_name,description,habitat,source_id,source_reference,verification_level,verification_status,sources(name,url,verification_status)')
    .eq('id', id).maybeSingle();
  if (fishResult.error || !fishResult.data) {
    return { data: null as FishDetail | null, error: fishResult.error ?? new Error('Balık kaydı bulunamadı') };
  }

  const [methodsResult, baitsResult, rulesResult, watersResult, activityResult] = await Promise.all([
    supabase.from('fish_methods').select('suitability,notes,fishing_methods(id,name,description)').eq('fish_id', id),
    supabase.from('fish_baits').select('suitability,notes,effectiveness,baits(id,name,description,bait_type)').eq('fish_id', id),
    supabase.from('fishing_rules')
      .select('id,regulation_name,source_reference,closed_start,closed_end,valid_from,valid_to,status,notes,minimum_length_cm,daily_count_limit,daily_limit_kg,area_restriction,prohibited_methods,allowed_methods')
      .eq('fish_id', id).order('valid_from', { ascending: false }),
    supabase.from('fish_water_bodies').select(`water_bodies(${waterSelect})`).eq('fish_id', id),
    supabase.from('fish_seasons').select('id,month,activity_level,notes,preferred_water_conditions,sources(url)').eq('fish_id', id).order('month'),
  ]);

  const rawFish: any = fishResult.data;
  const fish: Fish = {
    ...rawFish,
    source_name: rawFish.sources?.name ?? null,
    source_url: rawFish.sources?.url ?? null,
    source_status: rawFish.sources?.verification_status ?? null,
  };
  const methods = (methodsResult.data ?? []).map((r: any) => r.fishing_methods ? ({
    ...r.fishing_methods, suitable_for: r.suitability ?? null, notes: r.notes ?? null,
  }) : null).filter(Boolean);
  const baits = (baitsResult.data ?? []).map((r: any) => r.baits ? ({
    ...r.baits, notes: r.notes ?? null, suitability: r.suitability ?? null, effectiveness: r.effectiveness ?? null,
  }) : null).filter(Boolean);
  const rules = (rulesResult.data ?? []).map((r: any) => ({
    id: r.id,
    title: r.regulation_name,
    summary: [r.status, r.notes, r.area_restriction,
      r.minimum_length_cm != null ? `Asgari boy: ${r.minimum_length_cm} cm` : null,
      r.daily_count_limit != null ? `Günlük adet limiti: ${r.daily_count_limit}` : null,
      r.daily_limit_kg != null ? `Günlük ağırlık limiti: ${r.daily_limit_kg} kg` : null,
      r.prohibited_methods ? `Yasak yöntemler: ${r.prohibited_methods}` : null,
      r.allowed_methods ? `İzinli yöntemler: ${r.allowed_methods}` : null
    ].filter(Boolean).join(' — '),
    source_url: r.source_reference ?? null,
    effective_from: r.closed_start ?? r.valid_from ?? null,
    effective_to: r.closed_end ?? r.valid_to ?? null,
  }));
  const waterBodies = (watersResult.data ?? []).map((r: any) => r.water_bodies ? mapWaterBody(r.water_bodies) : null).filter(Boolean) as WaterBody[];
  const activity = (activityResult.data ?? []).map((r: any) => ({
    id: r.id, month: Number(r.month), activity_level: r.activity_level,
    notes: r.notes ?? null, preferred_water_conditions: r.preferred_water_conditions ?? null,
    source_url: r.sources?.url ?? null, last_verified_at: null,
  })) as FishActivity[];
  const error = methodsResult.error ?? baitsResult.error ?? rulesResult.error ?? watersResult.error ?? activityResult.error ?? null;
  return { data: { fish, methods, baits, rules, waterBodies, activity }, error };
}
