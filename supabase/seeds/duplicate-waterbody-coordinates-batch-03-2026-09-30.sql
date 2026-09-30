-- Batch 03: propagate coordinates only between exact duplicate water-body records.
-- Requires exact same display name, province and water type; copies existing OSM provenance.
with pairs(missing_id, source_row_id) as (
  values
    ('65128432-e836-4b57-90f0-71e64323a872'::uuid, '1506669f-7156-48e7-80e8-bc099cb9aac9'::uuid),
    ('2a6bfb12-fcbf-4b66-8ac0-3a21dfb5d17f'::uuid, '0b39bebc-12be-4d67-97a8-e8d866755a99'::uuid),
    ('e69fb492-a797-4914-b0a3-f47331787910'::uuid, '74ed6842-9d16-4fa1-9f17-c85b2b216193'::uuid)
)
update public.water_bodies target
set latitude = source.latitude,
    longitude = source.longitude,
    source_id = source.source_id,
    verification_level = source.verification_level,
    verification_status = source.verification_status,
    source_checked_at = source.source_checked_at,
    last_verified_at = source.last_verified_at,
    source_reference = coalesce(source.source_reference, '') || ' | coordinates copied to exact duplicate row with same name, province and water type; general waterbody location only.',
    external_source_id = null
from pairs p
join public.water_bodies source on source.id = p.source_row_id
where target.id = p.missing_id
  and lower(trim(target.name)) = lower(trim(source.name))
  and target.province_id = source.province_id
  and target.water_type = source.water_type
  and target.latitude is null
  and target.longitude is null;

insert into public.water_body_location_checks
  (water_body_id, provider, status, candidate_name, candidate_latitude, candidate_longitude, match_confidence, evidence_url, checked_at, reviewer_notes)
select p.missing_id, lc.provider, lc.status, lc.candidate_name, lc.candidate_latitude, lc.candidate_longitude,
       lc.match_confidence, lc.evidence_url, now(),
       coalesce(lc.reviewer_notes, '') || ' | propagated from exact duplicate water-body record with same name, province and type.'
from pairs p
join public.water_body_location_checks lc on lc.water_body_id = p.source_row_id
where lc.status = 'verified'
  and lc.candidate_latitude is not null
  and lc.candidate_longitude is not null
on conflict do nothing;
