import { supabase } from '../config/supabase';
import type { FishGuide, FishingRule } from '../types/fishing';

export async function getFishGuide(fishId: string) {
  if (!supabase) return { data: null as FishGuide | null, error: new Error('Supabase yapılandırılmamış') };
  const [{ data: methods, error: methodError }, { data: baits, error: baitError }] = await Promise.all([
    supabase.from('fish_methods').select('method:fishing_methods(id,name_tr,description)').eq('fish_id', fishId),
    supabase.from('fish_baits').select('bait:baits(id,name_tr,description)').eq('fish_id', fishId),
  ]);
  if (methodError) return { data: null, error: methodError };
  if (baitError) return { data: null, error: baitError };
  const method = (methods?.[0] as any)?.method ?? null;
  const normalizedBaits = (baits ?? []).map((row: any) => row.bait).filter(Boolean);
  return { data: { fish_id: fishId, method, baits: normalizedBaits, season_note: null, source_count: normalizedBaits.length + (method ? 1 : 0) } as FishGuide, error: null };
}

export async function getCurrentFishingRules(waterBodyId: string) {
  if (!supabase) return { data: [] as FishingRule[], error: new Error('Supabase yapılandırılmamış') };
  const { data, error } = await supabase.from('fishing_rules').select('id,title,summary,effective_from,effective_to,source_url,verified_at').eq('water_body_id', waterBodyId).order('verified_at', { ascending: false });
  return { data: (data ?? []) as FishingRule[], error };
}
