export type WaterBody = {
  id: string;
  name: string;
  water_type: string | null;
  province: string | null;
  district: string | null;
  latitude: number | null;
  longitude: number | null;
  fishing_allowed: boolean | null;
  verification_level: string | null;
};

export type Fish = {
  id: string;
  common_name_tr: string;
  scientific_name: string | null;
  description: string | null;
  habitat: string | null;
};

export type FishingMethod = { id: string; name: string; description: string | null };
export type Bait = { id: string; name: string; description: string | null };
export type FishMethod = FishingMethod & { suitable_for?: string | null };
export type FishBait = Bait & { notes?: string | null };
export type FishingRule = { id: string; title: string; summary: string; source_url: string | null; effective_from: string | null; effective_to: string | null };

export type FishDetail = {
  fish: Fish;
  methods: FishMethod[];
  baits: FishBait[];
  rules: FishingRule[];
  waterBodies: WaterBody[];
};

export type WaterBodyDistance = WaterBody & { distance_km?: number };

export type WaterBodyDetail = {
  waterBody: WaterBody;
  fish: Fish[];
};
