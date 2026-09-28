import { supabase } from '../config/supabase';
import type { Fish, WaterBody, WaterBodyDistance } from '../types/database';

export async function getWaterBodies(filters?: { province?: string; district?: string; search?: string }) {
  if (!supabase) return { data: [] as WaterBody[], error: new Error('Supabase yapılandırılmamış') };
  let query = supabase
    .from('water_bodies')
    .select('id,name,water_type,province,district,latitude,longitude,fishing_allowed,verification_level')
    .order('name');
  if (filters?.province) query = query.eq('province', filters.province);
  if (filters?.district) query = query.eq('district', filters.district);
  if (filters?.search) query = query.or(`name.ilike.%${filters.search}%,province.ilike.%${filters.search}%,district.ilike.%${filters.search}%`);
  const { data, error } = await query;
  return { data: (data ?? []) as WaterBody[], error };
}

export function sortByDistance(items: WaterBody[], latitude: number, longitude: number): WaterBodyDistance[] {
  const r = 6371;
  const radians = (v: number) => v * Math.PI / 180;
  return items.map(item => {
    if (item.latitude == null || item.longitude == null) return { ...item, distance_km: undefined };
    const dLat = radians(Number(item.latitude) - latitude);
    const dLon = radians(Number(item.longitude) - longitude);
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
