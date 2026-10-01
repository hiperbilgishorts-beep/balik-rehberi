-- Add structured fields for the Mera catalog without inventing content.
ALTER TABLE public.fishing_areas ADD COLUMN IF NOT EXISTS district_name text;
ALTER TABLE public.fishing_areas ADD COLUMN IF NOT EXISTS description text;
ALTER TABLE public.fishing_areas ADD COLUMN IF NOT EXISTS species_summary text;
CREATE INDEX IF NOT EXISTS idx_fishing_areas_province_name ON public.fishing_areas(province_name);
CREATE INDEX IF NOT EXISTS idx_fishing_areas_water_type ON public.fishing_areas(water_type);
CREATE INDEX IF NOT EXISTS idx_fishing_areas_location_confidence ON public.fishing_areas(location_confidence_grade);
COMMENT ON COLUMN public.fishing_areas.description IS 'Verified/general description only; do not use for exact fishing-access claims.';
COMMENT ON COLUMN public.fishing_areas.species_summary IS 'Optional sourced species summary; null until independently verified.';
