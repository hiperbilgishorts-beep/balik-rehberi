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
  access_level?: string | null;
  location_precision?: string | null;
  source_url?: string | null;
  last_verified_at?: string | null;
  verification_notes?: string | null;
};

export type Fish = {
  id: string;
  common_name_tr: string;
  scientific_name: string | null;
  description: string | null;
  habitat: string | null;
};

export type FishingMethod = { id: string; name: string; description: string | null };
export type Bait = { id: string; name: string; description: string | null; notes?: string | null };
export type FishMethod = FishingMethod & { suitable_for?: string | null };
export type FishBait = Bait;
export type FishingRule = {
  id: string;
  title: string;
  summary: string;
  source_url: string | null;
  effective_from: string | null;
  effective_to: string | null;
};

export type FishActivity = {
  id: string;
  month: number;
  activity_level: 'low' | 'medium' | 'high';
  depth_note: string | null;
  method_note: string | null;
  bait_note: string | null;
  source_url: string | null;
  last_verified_at: string | null;
};

export type FishDetail = {
  fish: Fish;
  methods: FishMethod[];
  baits: FishBait[];
  rules: FishingRule[];
  waterBodies: WaterBody[];
  activity: FishActivity[];
};

export type WaterBodyDistance = WaterBody & { distance_km?: number };

export type WaterBodyDetail = {
  waterBody: WaterBody;
  fish: Fish[];
};
