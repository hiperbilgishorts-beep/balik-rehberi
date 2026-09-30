-- Remove redundant indexes identified by Supabase's duplicate_index advisor.
-- Each removed FK index has an equivalent surviving index on the same key columns.
DROP INDEX IF EXISTS public.fkidx_data_claims_3ae283021813;
DROP INDEX IF EXISTS public.fkidx_data_import_errors_5e3468493876;
DROP INDEX IF EXISTS public.fkidx_fish_baits_03c1992bb877;
DROP INDEX IF EXISTS public.fkidx_fish_methods_e0aa261b7bec;
DROP INDEX IF EXISTS public.fkidx_fish_seasons_9e7665e2e693;
DROP INDEX IF EXISTS public.fkidx_fishing_rules_c49d440c8d18;
DROP INDEX IF EXISTS public.fkidx_fishing_rules_ba4da3aac43a;
DROP INDEX IF EXISTS public.fkidx_fishing_spot_import_queue_849218cf4dea;
DROP INDEX IF EXISTS public.fkidx_fishing_spots_e0b8c63f4131;
DROP INDEX IF EXISTS public.fkidx_fishing_spots_0ce7f6979e4b;
DROP INDEX IF EXISTS public.fkidx_water_access_info_1d17e9e9a048;
DROP INDEX IF EXISTS public.fkidx_water_bodies_7b1c03c32f27;
DROP INDEX IF EXISTS public.fkidx_water_body_location_checks_6aef0b07e4bd;
DROP INDEX IF EXISTS public.fkidx_water_features_5efb4af793be;
DROP INDEX IF EXISTS public.fkidx_water_source_import_queue_ddc176b3e124;

-- Remove duplicate indexes that predated the hardening migration.
DROP INDEX IF EXISTS public.idx_review_queue_status;
DROP INDEX IF EXISTS public.idx_fish_water_water;
DROP INDEX IF EXISTS public.idx_fishing_spots_water;
DROP INDEX IF EXISTS public.idx_water_features_type;
DROP INDEX IF EXISTS public.idx_water_features_province;
DROP INDEX IF EXISTS public.idx_water_features_geom;
