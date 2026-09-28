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
