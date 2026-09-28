export type FishingMethod = { id: string; name_tr: string; description: string | null };
export type Bait = { id: string; name_tr: string; description: string | null };
export type FishGuide = { fish_id: string; method: FishingMethod | null; baits: Bait[]; season_note: string | null; source_count: number };
export type FishingRule = { id: string; title: string; summary: string; effective_from: string | null; effective_to: string | null; source_url: string | null; verified_at: string | null };
