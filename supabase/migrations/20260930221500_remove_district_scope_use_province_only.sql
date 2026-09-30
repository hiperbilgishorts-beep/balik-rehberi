-- The product catalogs are province-based. Remove district relations and
-- keep map/catalog views aligned with the app's province-only data model.
begin;
drop view if exists public.published_water_bodies;
drop view if exists public.published_fishing_rules;
drop view if exists public.map_water_features;
drop view if exists public.app_nearby_water_bodies;
drop view if exists public.app_fishing_spot_catalog;
drop view if exists public.app_water_catalog;
drop view if exists public.app_fishing_rule_catalog;

alter table public.water_bodies drop column if exists district_id;
alter table public.fishing_rules drop column if exists district_id;
alter table public.fishing_spots drop column if exists district_id;
alter table public.water_features drop column if exists district_id;
alter table public.fishing_areas drop column if exists district_name;
alter table public.fishing_spot_import_queue drop column if exists district_name;
alter table public.water_source_import_queue drop column if exists district_name;
drop table if exists public.districts;

create view public.published_water_bodies with (security_invoker=true) as
select id,name,normalized_name,water_type,province_id,basin_name,latitude,longitude,surface_area_ha,description,source_id,verification_level,verification_status,created_at,updated_at
from public.water_bodies where verification_status='verified' and verification_level<>'X';

create view public.published_fishing_rules with (security_invoker=true) as
select id,fish_id,water_body_id,province_id,regulation_name,regulation_version,valid_from,valid_to,minimum_length_cm,daily_limit_kg,daily_count_limit,closed_start,closed_end,status,allowed_methods,prohibited_methods,area_restriction,source_id,verification_level,notes,created_at
from public.fishing_rules where verification_level<>'X';

create view public.map_water_features with (security_invoker=true) as
select id,name,feature_type,province_id,area_km2,length_km,verification_level,source_id,source_url,geom
from public.water_features wf where geom is not null;

create view public.app_nearby_water_bodies with (security_invoker=true) as
select id,name,normalized_name,water_type,province_id,latitude,longitude,surface_area_ha,fishing_relevance,fishing_relevance_confidence,verification_level,verification_status
from public.water_bodies wb where latitude is not null and longitude is not null;

create view public.app_fishing_spot_catalog with (security_invoker=true) as
select id,name,description,latitude,longitude,access_notes,official_status,spot_type,water_body_id,province_id,verification_level,verification_status
from public.fishing_spots fs where verification_status is distinct from 'rejected';

create view public.app_water_catalog with (security_invoker=true) as
select id,name,water_type,province_id,latitude,longitude,description,verification_level,last_verified_at,surface_area_ha,basin_name
from public.water_bodies w where verification_status='verified' and verification_level<>'X';

create view public.app_fishing_rule_catalog with (security_invoker=true) as
select id,fish_id,water_body_id,province_id,regulation_name,regulation_version,valid_from,valid_to,minimum_length_cm,daily_limit_kg,daily_count_limit,closed_start,closed_end,status,allowed_methods,prohibited_methods,area_restriction,verification_level,notes
from public.fishing_rules fr where verification_level is not null;

grant select on public.published_water_bodies,public.published_fishing_rules,public.map_water_features,public.app_nearby_water_bodies,public.app_fishing_spot_catalog,public.app_water_catalog,public.app_fishing_rule_catalog to anon, authenticated;
commit;
