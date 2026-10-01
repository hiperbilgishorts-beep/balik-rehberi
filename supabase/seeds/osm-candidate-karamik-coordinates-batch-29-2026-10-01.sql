-- OSM candidate coordinates for two duplicate inventory rows; pending water-type review.
-- OSM relation 17083287 labels the feature "Lake Karamık"; inventory labels it "Karamık Barajı".
-- General location only. Deliberately remains pending and confidence D until the water-type discrepancy is reviewed.
WITH input(id,latitude,longitude) AS (VALUES
 ('622459ea-055c-41a6-92c9-bcb10ba16668'::uuid,38.4234273,30.845923),
 ('c60ab342-600d-4181-8468-07a478de8b8d'::uuid,38.4234273,30.845923)
)
UPDATE public.water_bodies w
SET latitude=i.latitude,longitude=i.longitude,source_id='ca1ed63f-aab7-4f9d-83e0-401b383a824a'::uuid,
 verification_level='D',verification_status='pending',source_checked_at=now(),last_verified_at=null,
 source_reference='OSM named water feature candidate: Lake Karamık (water=lake), relation 17083287; inventory type/name conflict: record says Karamık Barajı. General location only; type review pending. https://www.openstreetmap.org/relation/17083287',
 external_source_id='osm:relation:17083287:record:'||w.id::text,
 coordinate_confidence_grade='D',
 coordinate_confidence_note='OSM name/province location candidate; source water type is lake while inventory says dam/reservoir; manual type review required.'
FROM input i WHERE w.id=i.id AND (w.latitude IS NULL OR w.longitude IS NULL);
INSERT INTO public.water_body_location_checks(water_body_id,provider,status,candidate_name,candidate_latitude,candidate_longitude,match_confidence,evidence_url,checked_at,reviewer_notes)
SELECT i.id,'openstreetmap','pending','Lake Karamık',38.4234273,30.845923,0.55,'https://www.openstreetmap.org/relation/17083287',now(),
 'Candidate location matches province and distinctive name stem, but OSM labels it lake while inventory calls it a dam; keep pending until water-type review.'
FROM (VALUES ('622459ea-055c-41a6-92c9-bcb10ba16668'::uuid),('c60ab342-600d-4181-8468-07a478de8b8d'::uuid)) i(id)
WHERE EXISTS(SELECT 1 FROM public.water_bodies w WHERE w.id=i.id AND w.latitude=38.4234273 AND w.longitude=30.845923)
ON CONFLICT DO NOTHING;
