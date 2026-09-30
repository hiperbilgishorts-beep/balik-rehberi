-- Candidate-coordinate batch 02 from public Olta Atlası detail pages.
-- These are general planning coordinates only. Name/type differences remain explicitly pending review.
with input(id, latitude, longitude, source_url, slug, note) as (
  values
    ('4db973ba-be63-4350-b52e-76c87e5dec70'::uuid, 39.10858, 30.43941, 'https://oltaatlasi.com/meralar/ankara-500km-afyonkarahisar-emre-golu/', 'ankara-500km-afyonkarahisar-emre-golu', 'Source title is Emre Gölü; database name is Döğer Emre Göleti. Same province/name stem, but water-type naming requires independent review.'),
    ('2a48c47e-01ff-484a-a638-3f1185022282'::uuid, 36.78279, 34.12832, 'https://oltaatlasi.com/meralar/ankara-500km-mersin-aydinlar-goleti/', 'ankara-500km-mersin-aydinlar-goleti', 'Source title is Aydınlar Göleti; database name is Avgadı Aydınlar Barajı. Same province/name stem, but water-type naming requires independent review.')
)
update public.water_bodies w
set latitude = i.latitude,
    longitude = i.longitude,
    source_id = 'be020ac9-7123-4914-986c-764c367ed5fb'::uuid,
    verification_level = 'D',
    verification_status = 'pending',
    source_checked_at = now(),
    last_verified_at = null,
    source_reference = 'Olta Atlası general planning point; independent verification pending; ' || i.note || ' ' || i.source_url,
    external_source_id = 'olta-atlasi:' || i.slug || ':' || w.id::text
from input i
where w.id = i.id
  and (w.latitude is null or w.longitude is null);

insert into public.water_body_location_checks
  (water_body_id, provider, status, candidate_name, candidate_latitude, candidate_longitude, match_confidence, evidence_url, checked_at, reviewer_notes)
select m.water_body_id, 'manual', 'pending', m.candidate_name, m.latitude, m.longitude, 0.45, m.detail_url, now(),
       'Low-confidence same-province/name-stem match from Olta Atlası; candidate water type differs from database label. General location only; independent verification pending.'
from internal.olta_waterbody_matches_v2 m
join public.water_bodies w on w.id = m.water_body_id
where m.water_body_id in ('4db973ba-be63-4350-b52e-76c87e5dec70'::uuid, '2a48c47e-01ff-484a-a638-3f1185022282'::uuid)
  and m.latitude is not null and m.longitude is not null
  and w.source_id = 'be020ac9-7123-4914-986c-764c367ed5fb'::uuid
on conflict do nothing;
