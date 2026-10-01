-- OSM/Photon exact-name and province cross-check batch 28 / 11 records
-- Hydrological OSM tag and province were required; general feature coordinates only.
WITH input(id,name,province,latitude,longitude,osm_url,osm_id,osm_key,osm_value) AS (VALUES
('abfe2d92-5fee-43b2-a29b-d97e6a7768aa'::uuid,'Almus Baraj Gölü','Tokat',40.3722406,36.9578199,'https://www.openstreetmap.org/relation/961325',961325,'water','reservoir'),
    ('c1678d61-e80b-4138-ab5a-8052c5e213ea'::uuid,'Alpu Baraj Gölü','Tokat',40.0610636,36.099312,'https://www.openstreetmap.org/way/221452770',221452770,'waterway','dam'),
    ('d1b47259-8597-4750-975e-461f4b7c3b70'::uuid,'Altınkaya Baraj Gölü','Samsun',41.2887946,35.4341266,'https://www.openstreetmap.org/relation/1224893',1224893,'water','reservoir'),
    ('be71c1dd-7e51-4ffd-a88c-ec269310245e'::uuid,'Arıklıkaş Baraj Gölü','Osmaniye',37.1555269,36.5175948,'https://www.openstreetmap.org/way/83361935',83361935,'water','reservoir'),
    ('e6efa833-dbfa-47dd-85c9-c624dcc4f9f5'::uuid,'Artova Baraj Gölü','Tokat',40.128187,36.2817362,'https://www.openstreetmap.org/way/169414189',169414189,'water','reservoir'),
    ('97f46930-f200-4d5e-9d37-30eba89b440e'::uuid,'Aslantaş Baraj Gölü','Osmaniye',37.2720947,36.2719514,'https://www.openstreetmap.org/way/91252425',91252425,'waterway','dam'),
    ('b1c36945-408a-4190-a7a5-52f20a25bf8b'::uuid,'Ataköy Baraj Gölü','Tokat',40.4157999,36.8957012,'https://www.openstreetmap.org/relation/20710406',20710406,'water','reservoir'),
    ('a2742b97-59f4-4015-8634-4e5f89dd10a5'::uuid,'Atasu Baraj Gölü','Trabzon',40.8483506,39.6983978,'https://www.openstreetmap.org/way/347293897',347293897,'water','reservoir'),
    ('a34aed64-6424-408e-bff5-0f1f1ecc745c'::uuid,'Başur Çayı','Siirt',38.1762072,41.8228856,'https://www.openstreetmap.org/relation/2301216',2301216,'waterway','river'),
    ('f1271e73-a80c-4519-a10a-2f87e7d3788d'::uuid,'Bayraktar Baraj Gölü','Kocaeli',40.8036146,30.0911406,'https://www.openstreetmap.org/way/242063946',242063946,'water','reservoir'),
    ('297531b9-95fd-41c3-ad4e-2cd3e7a450a5'::uuid,'Bayramşah Baraj Gölü','Tekirdağ',41.12483,27.1998247,'https://www.openstreetmap.org/way/27737279',27737279,'water','reservoir')
)
UPDATE public.fishing_areas AS a
SET latitude=i.latitude,longitude=i.longitude,coordinates_imported=true,coordinate_status='province_checked_source_candidate',
    coordinate_note='OpenStreetMap/Photon exact normalized name, province and hydrological tag match ('||i.osm_key||'='||i.osm_value||'); source: '||i.osm_url||'; general location only, not fishing access or permission.',
    location_confidence_grade='C',source_checked_at=now(),updated_at=now()
FROM input i WHERE a.id=i.id AND a.name=i.name AND a.province_name=i.province AND (a.latitude IS NULL OR a.longitude IS NULL);
