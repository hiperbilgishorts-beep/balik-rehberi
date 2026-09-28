import { supabase } from '../config/supabase';
import type { FishingSpot, SpotReport, SpotSafetyNote, TripPlan, WeatherSnapshot } from '../types/database';

export async function getFishingSpotsForWaterBody(waterBodyId: string) {
  if (!supabase) return { data: [] as FishingSpot[], error: new Error('Supabase yapılandırılmamış') };
  const { data, error } = await supabase.from('fishing_spots').select('id,water_body_id,name,description,latitude,longitude,access_notes,official_status,verification_level,verification_status,last_verified_at,spot_type').eq('water_body_id', waterBodyId).order('name');
  return { data: (data ?? []) as FishingSpot[], error };
}

export async function getSpotSafety(spotId: string) {
  if (!supabase) return { data: [] as SpotSafetyNote[], error: new Error('Supabase yapılandırılmamış') };
  const { data, error } = await supabase.from('spot_safety_notes').select('id,spot_id,category,severity,note,last_verified_at').eq('spot_id', spotId).order('severity');
  return { data: (data ?? []) as SpotSafetyNote[], error };
}

export async function getSpotWeather(spotId: string) {
  if (!supabase) return { data: [] as WeatherSnapshot[], error: new Error('Supabase yapılandırılmamış') };
  const { data, error } = await supabase.from('weather_snapshots').select('id,spot_id,latitude,longitude,observed_at,source_url,wind_speed_ms,wind_direction_deg,wave_height_m,air_temp_c,water_temp_c,precipitation_probability').eq('spot_id', spotId).order('observed_at', { ascending: false }).limit(24);
  return { data: (data ?? []) as WeatherSnapshot[], error };
}

export async function getPublishedSpotReports(spotId: string) {
  if (!supabase) return { data: [] as SpotReport[], error: new Error('Supabase yapılandırılmamış') };
  const { data, error } = await supabase.from('spot_reports').select('id,spot_id,report_type,title,body,observed_at,status,created_at').eq('spot_id', spotId).eq('status','published').order('created_at', { ascending: false }).limit(50);
  return { data: (data ?? []) as SpotReport[], error };
}

export async function isFavoriteSpot(spotId: string) {
  if (!supabase) return { favorite: false, error: new Error('Supabase yapılandırılmamış') };
  const { data: user } = await supabase.auth.getUser();
  if (!user.user) return { favorite: false, error: null };
  const { data, error } = await supabase.from('favorite_spots').select('spot_id').eq('user_id', user.user.id).eq('spot_id', spotId).maybeSingle();
  return { favorite: !!data, error };
}

export async function setFavoriteSpot(spotId: string, favorite: boolean) {
  if (!supabase) return { error: new Error('Supabase yapılandırılmamış') };
  const { data: user } = await supabase.auth.getUser();
  if (!user.user) return { error: new Error('Favori kaydetmek için giriş gerekli') };
  if (favorite) {
    const { error } = await supabase.from('favorite_spots').upsert({ user_id: user.user.id, spot_id: spotId });
    return { error };
  }
  const { error } = await supabase.from('favorite_spots').delete().eq('user_id', user.user.id).eq('spot_id', spotId);
  return { error };
}

export async function createTripPlan(title: string, notes?: string) {
  if (!supabase) return { data: null as TripPlan | null, error: new Error('Supabase yapılandırılmamış') };
  const { data: user } = await supabase.auth.getUser();
  if (!user.user) return { data: null, error: new Error('Gezi planı için giriş gerekli') };
  const { data, error } = await supabase.from('trip_plans').insert({ user_id: user.user.id, title, notes: notes ?? null }).select('id,title,notes,planned_start,planned_end,status,created_at,updated_at').single();
  return { data: data as TripPlan | null, error };
}

export async function addSpotToTrip(tripPlanId: string, spotId: string, sortOrder = 0, notes?: string) {
  if (!supabase) return { error: new Error('Supabase yapılandırılmamış') };
  const { error } = await supabase.from('trip_plan_items').upsert({ trip_plan_id: tripPlanId, spot_id: spotId, sort_order: sortOrder, notes: notes ?? null });
  return { error };
}
