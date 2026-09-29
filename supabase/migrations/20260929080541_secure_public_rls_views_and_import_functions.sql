-- Balık Rehberi: harden exposed public schema
-- Applied to Supabase as migration 20260929080541_secure_public_rls_views_and_import_functions.
-- Internal ingestion/admin tables are RLS-protected and inaccessible to client roles.
ALTER TABLE public.water_access_info ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.water_source_import_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.regulation_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.data_import_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fishing_spot_import_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.data_import_errors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.district_data_quality ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.map_layers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.water_features ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.data_sources ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.water_access_info, public.water_source_import_queue,
  public.regulation_documents, public.data_import_batches,
  public.fishing_spot_import_queue, public.data_import_errors,
  public.district_data_quality, public.map_layers, public.data_sources
  FROM PUBLIC, anon, authenticated;

REVOKE INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER
  ON TABLE public.water_features FROM PUBLIC, anon, authenticated;
DROP POLICY IF EXISTS water_features_public_map_read ON public.water_features;
CREATE POLICY water_features_public_map_read ON public.water_features
  FOR SELECT TO anon, authenticated
  USING (geom IS NOT NULL AND COALESCE(verification_level, 'C') <> 'X');

DROP POLICY IF EXISTS water_bodies_public_read ON public.water_bodies;
CREATE POLICY water_bodies_public_read ON public.water_bodies
  FOR SELECT TO anon, authenticated
  USING (verification_status = 'verified' AND verification_level <> 'X');

DROP POLICY IF EXISTS fish_species_public_read ON public.fish_species;
CREATE POLICY fish_species_public_read ON public.fish_species
  FOR SELECT TO anon, authenticated
  USING (verification_status = 'verified' AND verification_level <> 'X');

DROP POLICY IF EXISTS fish_water_bodies_read ON public.fish_water_bodies;
CREATE POLICY fish_water_bodies_read ON public.fish_water_bodies
  FOR SELECT TO anon, authenticated
  USING (verification_level <> 'X');

DROP POLICY IF EXISTS fishing_rules_read ON public.fishing_rules;
CREATE POLICY fishing_rules_read ON public.fishing_rules
  FOR SELECT TO anon, authenticated
  USING (verification_level IS NOT NULL AND verification_level <> 'X');

DROP POLICY IF EXISTS fishing_spots_public_read ON public.fishing_spots;
CREATE POLICY fishing_spots_public_read ON public.fishing_spots
  FOR SELECT TO anon, authenticated
  USING (verification_status = 'verified' AND verification_level <> 'X');
GRANT SELECT ON TABLE public.fishing_spots TO anon, authenticated;

ALTER VIEW public.published_fish_species SET (security_invoker = true);
ALTER VIEW public.published_fishing_spots SET (security_invoker = true);
ALTER VIEW public.published_water_bodies SET (security_invoker = true);
ALTER VIEW public.published_fishing_rules SET (security_invoker = true);
ALTER VIEW public.data_quality_summary SET (security_invoker = true);
ALTER VIEW public.map_water_features SET (security_invoker = true);
ALTER VIEW public.app_nearby_water_bodies SET (security_invoker = true);
ALTER VIEW public.app_fishing_spot_catalog SET (security_invoker = true);
ALTER VIEW public.app_fish_catalog SET (security_invoker = true);
ALTER VIEW public.app_water_catalog SET (security_invoker = true);
ALTER VIEW public.app_fish_water_catalog SET (security_invoker = true);
ALTER VIEW public.app_fish_detail SET (security_invoker = true);
ALTER VIEW public.app_fishing_rule_catalog SET (security_invoker = true);

REVOKE EXECUTE ON FUNCTION public.import_dsi_dam_batch(jsonb) FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.import_dsi_pond_batch(jsonb) FROM PUBLIC, anon, authenticated;
