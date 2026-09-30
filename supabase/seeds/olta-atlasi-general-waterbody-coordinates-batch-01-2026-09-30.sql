-- Batch 01: general waterbody coordinates sourced from public Olta Atlası route pages.
-- Coordinates are general planning points, not fishing-access points.
-- Independent verification remains pending; source confidence is preserved in source_reference.
with input(id, latitude, longitude, source_url, site_confidence, slug, note) as (
  values
    ('4960787d-3191-4c71-8910-ca418752921f'::uuid, 38.39122, 30.16126, 'https://oltaatlasi.com/meralar/ankara-500km-afyonkarahisar-orenkaya-goleti/', 'D', 'ankara-500km-afyonkarahisar-orenkaya-goleti', 'Source labels this feature Göleti while database label is Baraj; review water-type naming.'),
    ('9c5fc3af-53af-4bc9-8f52-85a8e13505e1'::uuid, 37.53352, 27.72209, 'https://oltaatlasi.com/meralar/ankara-500km-aydin-mericler-goleti/', 'D', 'ankara-500km-aydin-mericler-goleti', 'Name and province match; source confidence D.'),
    ('9e7bc662-fa30-489b-8450-a4dd0cbbb492'::uuid, 39.43871, 27.90293, 'https://oltaatlasi.com/meralar/balikesir-altieylul-bayat-sehit-aydin-nazillioglu-goleti/', 'C', 'balikesir-altieylul-bayat-sehit-aydin-nazillioglu-goleti', 'Source labels this feature Göleti while database label is Baraj; review water-type naming.'),
    ('2b19b858-7f4d-4b7f-a689-dc1c41ccd7f7'::uuid, 39.43871, 27.90293, 'https://oltaatlasi.com/meralar/balikesir-altieylul-bayat-sehit-aydin-nazillioglu-goleti/', 'C', 'balikesir-altieylul-bayat-sehit-aydin-nazillioglu-goleti', 'Duplicate database record; source labels this feature Göleti while database label is Baraj.'),
    ('86db582a-1cce-41f1-ac91-41befdbc4433'::uuid, 38.22573, 41.11589, 'https://oltaatlasi.com/meralar/ulusal-batman-batman-baraj-golu/', 'C', 'ulusal-batman-batman-baraj-golu', 'Name and province match; source confidence C.'),
    ('7bd50961-2902-4144-b77b-fe4add2d1b10'::uuid, 40.32435, 31.81826, 'https://oltaatlasi.com/meralar/ankara-500km-bolu-alanhimmetler-goleti/', 'D', 'ankara-500km-bolu-alanhimmetler-goleti', 'Source labels this feature Göleti while database label is Baraj; review water-type naming.'),
    ('46460b26-7217-4858-a40a-f32737540b42'::uuid, 37.20752, 29.81423, 'https://oltaatlasi.com/meralar/burdur-tefenni-cayli-goleti/', 'C', 'burdur-tefenni-cayli-goleti', 'Source labels this feature Göleti while database label is Baraj; review water-type naming.'),
    ('61000000-0000-4000-8000-000000000008'::uuid, 37.95366, 36.98973, 'https://oltaatlasi.com/meralar/ankara-500km-kahramanmaras-sariguzel-baraj-golu/', 'D', 'ankara-500km-kahramanmaras-sariguzel-baraj-golu', 'Name and province match; source confidence D.'),
    ('61000000-0000-4000-8000-000000000010'::uuid, 37.56970, 36.82233, 'https://oltaatlasi.com/meralar/ulusal-kahramanmaras-sir-baraj-golu/', 'C', 'ulusal-kahramanmaras-sir-baraj-golu', 'Name and province match; source confidence C.'),
    ('f5952970-7fdf-4b0c-8aea-4e1984d61d1e'::uuid, 38.67585, 36.29172, 'https://oltaatlasi.com/meralar/ulusal-kayseri-bahcelik-baraj-golu/', 'B', 'ulusal-kayseri-bahcelik-baraj-golu', 'Name and province match; source confidence B.'),
    ('565367aa-21e7-48a7-837a-5e8c11a63619'::uuid, 36.55170, 33.15757, 'https://oltaatlasi.com/meralar/ulusal-mersin-gezende-baraj-golu/', 'D', 'ulusal-mersin-gezende-baraj-golu', 'Name and province match; source confidence D.'),
    ('a66ccd24-4436-496c-b33f-216fc6a9553c'::uuid, 40.03942, 36.46018, 'https://oltaatlasi.com/meralar/ankara-500km-tokat-bedirkale-baraj-golu/', 'D', 'ankara-500km-tokat-bedirkale-baraj-golu', 'Name and province match; source confidence D.')
)
update public.water_bodies w
set latitude = i.latitude,
    longitude = i.longitude,
    source_id = 'be020ac9-7123-4914-986c-764c367ed5fb'::uuid,
    verification_level = 'D',
    verification_status = 'pending',
    source_checked_at = now(),
    last_verified_at = null,
    source_reference = 'Olta Atlası general planning point; source confidence ' || i.site_confidence || '; independent verification pending. ' || i.note || ' ' || i.source_url,
    external_source_id = 'olta-atlasi:' || i.slug || ':' || w.id::text
from input i
where w.id = i.id
  and (w.latitude is null or w.longitude is null);

insert into public.water_body_location_checks
  (water_body_id, provider, status, candidate_name, candidate_latitude, candidate_longitude, match_confidence, evidence_url, checked_at, reviewer_notes)
select w.id, 'manual', 'pending', m.candidate_name, m.latitude, m.longitude, 0.65, m.detail_url, now(),
       'Olta Atlası general coordinate. Database coordinate set provisionally; independent verification pending; not a fishing-access point.'
from internal.olta_waterbody_matches m
join public.water_bodies w on w.id = m.water_body_id
where m.latitude is not null and m.longitude is not null
  and w.source_id = 'be020ac9-7123-4914-986c-764c367ed5fb'::uuid
on conflict do nothing;
