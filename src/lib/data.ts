import { supabase } from '../config/supabase';
import type { Fish, WaterBody } from '../types/database';

export async function getWaterBodies(filters?: { province?: string; search?: string }) {
  if (!supabase) return { data: [] as WaterBody[], error: new Error('Supabase yapılandırılmamış') };
  let query = supabase
    .from('water_bodies')
    .select('id,name,water_type,province,district,latitude,longitude,fishing_allowed,verification_level')
    .order('name');
  if (filters?.province) query = query.eq('province', filters.province);
  if (filters?.search) query = query.ilike('name', `%${filters.search}%`);
  const { data, error } = await query;
  return { data: (data ?? []) as WaterBody[], error };
}

export async function getFish(search?: string) {
  if (!supabase) return { data: [] as Fish[], error: new Error('Supabase yapılandırılmamış') };
  let query = supabase.from('fish_species').select('id,common_name_tr,scientific_name,description,habitat').order('common_name_tr');
  if (search) query = query.ilike('common_name_tr', `%${search}%`);
  const { data, error } = await query;
  return { data: (data ?? []) as Fish[], error };
}
