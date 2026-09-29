-- Balık Rehberi coordinate verification batch 01
-- 50 records: 30 OSM/Photon new matches, 14 GeoNames new matches, 6 OSM/Meraloji rechecks.
-- General waterbody positions only; not fishing-access points.

begin;
-- Adıyaman-Çat Barajı | OSM/Photon | Çat Barajı
update public.water_bodies set latitude=38.0679761, longitude=38.3128363, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Çat Barajı:020c4e8b-b783-4f78-b6e1-e9e934a930a2' where id='020c4e8b-b783-4f78-b6e1-e9e934a930a2';

-- Afyonkarahisar-Selevir Barajı | Meraloji/OSM recheck | Selevir Baraj Gölü
update public.water_bodies set latitude=38.511003, longitude=30.717636, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://github.com/ugurkgs/meraloji-engine/blob/24f0046b76ed6775c20cbf54c902518ae1e3d505/tr-lakes.json | Existing OSM-derived coordinate rechecked against province-matched Meraloji audit; general waterbody position, not fishing-access point.' where id='08f8d82d-ca8b-4661-b440-ca1a470c2ab0';

-- Erzurum-Kuzgun Barajı | OSM/Photon | Kuzgun Barajı
update public.water_bodies set latitude=40.1854089, longitude=41.0640686, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Kuzgun Barajı:0e740446-9c9f-48db-937b-124da01f4d29' where id='0e740446-9c9f-48db-937b-124da01f4d29';

-- Kütahya-Söğüt Barajı | GeoNames | Söğüt Barajı
update public.water_bodies set latitude=39.4163889, longitude=30.195, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/446975/soeguet-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:446975:14a5c1b5-d535-4dde-932c-2fd3d4b1901b' where id='14a5c1b5-d535-4dde-932c-2fd3d4b1901b';

-- Eskişehir-Kunduzlar Barajı | OSM/Photon | Kunduzlar Barajı
update public.water_bodies set latitude=39.3559649, longitude=30.5683024, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Kunduzlar Barajı:1fbb2c37-da96-4562-94da-a8c90a95ad7c' where id='1fbb2c37-da96-4562-94da-a8c90a95ad7c';

-- Denizli-Adıgüzel Barajı | OSM/Photon | Adıgüzel Barajı
update public.water_bodies set latitude=38.1586598, longitude=29.2057844, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Adıgüzel Barajı:2014c09b-dd44-4e29-b62a-885515260868' where id='2014c09b-dd44-4e29-b62a-885515260868';

-- Çanakkale-Bakacak Barajı | OSM/Photon | Bakacak Barajı
update public.water_bodies set latitude=40.1840225, longitude=27.0226717, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Bakacak Barajı:25ab8c12-bb5e-461c-b01f-95b1705a2c85' where id='25ab8c12-bb5e-461c-b01f-95b1705a2c85';

-- Manisa-Demirköprü Barajı | GeoNames | Demirköpru Barajı
update public.water_bodies set latitude=38.674789205206, longitude=28.3735656738281, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/7871360/demirkoepru-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:7871360:27731824-018d-4a99-85f0-41f0a5c965d7' where id='27731824-018d-4a99-85f0-41f0a5c965d7';

-- Mersin-Alaköprü Barajı | OSM/Photon | Alaköprü Barajı
update public.water_bodies set latitude=36.1814923, longitude=32.8956013, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Alaköprü Barajı:3c22caf2-3e97-48c1-9457-947fe74b0c1a' where id='3c22caf2-3e97-48c1-9457-947fe74b0c1a';

-- İstanbul-Alibey Barajı | OSM/Photon | Alibey Barajı
update public.water_bodies set latitude=41.1006085, longitude=28.9208551, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Alibey Barajı:3d51604d-7ced-4436-b6eb-17b2076712b4' where id='3d51604d-7ced-4436-b6eb-17b2076712b4';

-- Diyarbakır-Karakaya Barajı | OSM/Photon | Karakaya Barajı
update public.water_bodies set latitude=38.2258096, longitude=39.1348903, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Karakaya Barajı:45764c95-275a-4236-80b5-7029763810ec' where id='45764c95-275a-4236-80b5-7029763810ec';

-- Kırşehir-Çoğun Barajı | GeoNames | Çoğun Barajı
update public.water_bodies set latitude=39.3344444, longitude=34.105, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/318188/cogun-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:318188:461ade48-fcd5-46af-8101-94a9bad09d10' where id='461ade48-fcd5-46af-8101-94a9bad09d10';

-- Çavuşçu Gölü | GeoNames | Lake Çavuşçu
update public.water_bodies set latitude=38.343611, longitude=31.8775, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/319134/cavuscu-goelue.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:319134:4acf58f4-dade-424d-82ed-0cdd80d44220' where id='4acf58f4-dade-424d-82ed-0cdd80d44220';

-- Denizli-Adıgüzel Barajı | OSM/Photon | Adıgüzel Barajı
update public.water_bodies set latitude=38.1586598, longitude=29.2057844, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Adıgüzel Barajı:4c46b5cd-0835-4784-984c-9e88e4335874' where id='4c46b5cd-0835-4784-984c-9e88e4335874';

-- İstanbul-Alibey Barajı | OSM/Photon | Alibey Barajı
update public.water_bodies set latitude=41.1006085, longitude=28.9208551, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Alibey Barajı:4e364f20-ecef-4585-bbd0-6b2d405cbe1d' where id='4e364f20-ecef-4585-bbd0-6b2d405cbe1d';

-- Kütahya-Söğüt Barajı | GeoNames | Söğüt Barajı
update public.water_bodies set latitude=39.4163889, longitude=30.195, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/446975/soeguet-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:446975:51dd1535-2e60-40b5-831a-c5f451cef479' where id='51dd1535-2e60-40b5-831a-c5f451cef479';

-- Bingöl-Özlüce Barajı | GeoNames | Özlüce Barajı
update public.water_bodies set latitude=39.171667, longitude=40.173333, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/448109/oezluece-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:448109:53f89734-2845-4b5f-9cd4-c8155132b9e0' where id='53f89734-2845-4b5f-9cd4-c8155132b9e0';

-- Niğde-Altunhisar Barajı | OSM/Photon | Altunhisar Barajı
update public.water_bodies set latitude=37.9808051, longitude=34.3923174, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Altunhisar Barajı:5e678129-2ac8-459c-805b-f57b104dd76c' where id='5e678129-2ac8-459c-805b-f57b104dd76c';

-- Eğirdir Gölü | GeoNames | Lake Eğirdir
update public.water_bodies set latitude=38.044167, longitude=30.894167, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/315904/egirdir-goelue.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:315904:61000000-0000-4000-8000-000000000001' where id='61000000-0000-4000-8000-000000000001';

-- Adana-Kozan Barajı | Meraloji/OSM recheck | Kozan Baraj Gölü
update public.water_bodies set latitude=37.517896, longitude=35.832771, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://github.com/ugurkgs/meraloji-engine/blob/24f0046b76ed6775c20cbf54c902518ae1e3d505/tr-lakes.json | Existing OSM-derived coordinate rechecked against province-matched Meraloji audit; general waterbody position, not fishing-access point.' where id='69c399e4-dd18-4de5-9844-745c73e5536d';

-- Ankara-Asartepe Barajı | GeoNames | Asartepe Barajı
update public.water_bodies set latitude=40.146111, longitude=32.399167, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/865789/asartepe-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:865789:6c67bb50-6c96-4eb8-89c2-9d3062af6fae' where id='6c67bb50-6c96-4eb8-89c2-9d3062af6fae';

-- Kilis-Seve Barajı | OSM/Photon | Seve Barajı
update public.water_bodies set latitude=36.7359545, longitude=37.2412239, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Seve Barajı:71a5a09b-fe14-458e-a977-3f2b93a637fc' where id='71a5a09b-fe14-458e-a977-3f2b93a637fc';

-- Muğla-Mumcular Barajı | OSM/Photon | Mumcular Barajı
update public.water_bodies set latitude=37.1178594, longitude=27.6599427, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Mumcular Barajı:72986752-e9df-431f-9ea8-8274d6b49bdc' where id='72986752-e9df-431f-9ea8-8274d6b49bdc';

-- Aydın-Topçam Barajı | OSM/Photon | Topçam Barajı
update public.water_bodies set latitude=37.6889793, longitude=28.0075432, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Topçam Barajı:76674180-0433-41b8-8001-61ed71a51eca' where id='76674180-0433-41b8-8001-61ed71a51eca';

-- Osmaniye-Aslantaş Barajı | OSM/Photon | Aslantaş Barajı
update public.water_bodies set latitude=37.2720947, longitude=36.2719514, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Aslantaş Barajı:76a828a5-7f6b-4aa9-82e6-b727a3fa3c20' where id='76a828a5-7f6b-4aa9-82e6-b727a3fa3c20';

-- İstanbul-Alibey Barajı | OSM/Photon | Alibey Barajı
update public.water_bodies set latitude=41.1006085, longitude=28.9208551, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Alibey Barajı:7b4b3a2a-1fc2-4a53-b184-fc8cdc9d57b0' where id='7b4b3a2a-1fc2-4a53-b184-fc8cdc9d57b0';

-- Eskişehir-Porsuk Barajı | OSM/Photon | Porsuk Barajı
update public.water_bodies set latitude=39.6357423, longitude=30.2791284, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Porsuk Barajı:7b5c7a42-9b60-430a-87c4-6a862d8ab60b' where id='7b5c7a42-9b60-430a-87c4-6a862d8ab60b';

-- Aydın-Topçam Barajı | OSM/Photon | Topçam Barajı
update public.water_bodies set latitude=37.6889793, longitude=28.0075432, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Topçam Barajı:87e7c69f-a063-42b6-a858-79d30b614274' where id='87e7c69f-a063-42b6-a858-79d30b614274';

-- İstanbul-Alibey Barajı | OSM/Photon | Alibey Barajı
update public.water_bodies set latitude=41.1006085, longitude=28.9208551, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Alibey Barajı:8ad4ccff-2eb6-4cfc-bcae-f9e349ee5bd4' where id='8ad4ccff-2eb6-4cfc-bcae-f9e349ee5bd4';

-- Adıyaman-Gözebaşı Göleti | Meraloji/OSM recheck | Gözebaşı Göleti
update public.water_bodies set latitude=37.814802, longitude=38.401532, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://github.com/ugurkgs/meraloji-engine/blob/24f0046b76ed6775c20cbf54c902518ae1e3d505/tr-lakes.json | Existing OSM-derived coordinate rechecked against province-matched Meraloji audit; general waterbody position, not fishing-access point.' where id='8c239279-3675-4774-a6ae-b000d9337eaf';

-- Adana-Nergizlik Barajı | Meraloji/OSM recheck | Nergizlik Baraj Gölü
update public.water_bodies set latitude=37.299822, longitude=35.050127, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://github.com/ugurkgs/meraloji-engine/blob/24f0046b76ed6775c20cbf54c902518ae1e3d505/tr-lakes.json | Existing OSM-derived coordinate rechecked against province-matched Meraloji audit; general waterbody position, not fishing-access point.' where id='9092c3b5-68af-42bb-beab-895eae1cc30d';

-- Afyonkarahisar-Selevir Barajı | Meraloji/OSM recheck | Selevir Baraj Gölü
update public.water_bodies set latitude=38.511003, longitude=30.717636, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://github.com/ugurkgs/meraloji-engine/blob/24f0046b76ed6775c20cbf54c902518ae1e3d505/tr-lakes.json | Existing OSM-derived coordinate rechecked against province-matched Meraloji audit; general waterbody position, not fishing-access point.' where id='963e885a-33b5-464a-81c1-ecbe230e319e';

-- Muğla-Mumcular Barajı | OSM/Photon | Mumcular Barajı
update public.water_bodies set latitude=37.1178594, longitude=27.6599427, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Mumcular Barajı:98539960-ff67-4f3f-8531-865741ef1b4a' where id='98539960-ff67-4f3f-8531-865741ef1b4a';

-- Balıkesir-Çaygören Barajı | OSM/Photon | Çaygören Barajı
update public.water_bodies set latitude=39.2721397, longitude=28.2166559, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Çaygören Barajı:9a889e45-9ae9-4999-be75-d9e93cb97aa4' where id='9a889e45-9ae9-4999-be75-d9e93cb97aa4';

-- Düzce-Hasanlar Barajı | OSM/Photon | Hasanlar Barajı
update public.water_bodies set latitude=40.9100639, longitude=31.2754336, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Hasanlar Barajı:9fa1df07-0448-4e62-9a7f-777d138292df' where id='9fa1df07-0448-4e62-9a7f-777d138292df';

-- Gaziantep-Hancağız Barajı | OSM/Photon | Hancağız Barajı
update public.water_bodies set latitude=36.9602357, longitude=37.892039, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Hancağız Barajı:a60c57d8-84aa-4952-87f4-f5f34279f9be' where id='a60c57d8-84aa-4952-87f4-f5f34279f9be';

-- İstanbul-Alibey Barajı | OSM/Photon | Alibey Barajı
update public.water_bodies set latitude=41.1006085, longitude=28.9208551, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Alibey Barajı:ac53079a-b99e-4443-9b15-19ce7b57cbdc' where id='ac53079a-b99e-4443-9b15-19ce7b57cbdc';

-- Ankara-Eğrekkaya Barajı | GeoNames | Eğrekkaya Barajı
update public.water_bodies set latitude=40.488829, longitude=32.663169, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/865779/egrekkaya-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:865779:ace7f761-1cb1-4f72-ba76-01e77c4a3410' where id='ace7f761-1cb1-4f72-ba76-01e77c4a3410';

-- Çanakkale-Bakacak Barajı | OSM/Photon | Bakacak Barajı
update public.water_bodies set latitude=40.1840225, longitude=27.0226717, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Bakacak Barajı:b6548bdc-0a80-4f5f-8670-b9b91e86b91a' where id='b6548bdc-0a80-4f5f-8670-b9b91e86b91a';

-- Balıkesir-Çaygören Barajı | OSM/Photon | Çaygören Barajı
update public.water_bodies set latitude=39.2721397, longitude=28.2166559, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Çaygören Barajı:b933049f-bb78-4217-bbdb-0a64ed3db09a' where id='b933049f-bb78-4217-bbdb-0a64ed3db09a';

-- Manisa-Demirköprü Barajı | GeoNames | Demirköpru Barajı
update public.water_bodies set latitude=38.674789205206, longitude=28.3735656738281, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/7871360/demirkoepru-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:7871360:bbe44803-1357-49ba-b902-30cb0cce83fe' where id='bbe44803-1357-49ba-b902-30cb0cce83fe';

-- Eskişehir-Kaymaz Barajı | OSM/Photon | Kaymaz Barajı
update public.water_bodies set latitude=39.5434771, longitude=31.216998, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Kaymaz Barajı:c621615c-e6c8-462d-a445-352fb5874f7a' where id='c621615c-e6c8-462d-a445-352fb5874f7a';

-- Kütahya-Enne Barajı | GeoNames | Enne Barajı
update public.water_bodies set latitude=39.472701, longitude=29.865944, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/315550/enne-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:315550:c6719b4c-30f3-45ad-ab77-f87143150afa' where id='c6719b4c-30f3-45ad-ab77-f87143150afa';

-- Balıkesir-İkizcetepeler Barajı | OSM/Photon | İkizce Tepeler Barajı
update public.water_bodies set latitude=39.4918552, longitude=27.9392581, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:İkizce Tepeler Barajı:c8cba488-7046-4b52-8eec-1fdc8beaeb8c' where id='c8cba488-7046-4b52-8eec-1fdc8beaeb8c';

-- Kütahya-Enne Barajı | GeoNames | Enne Barajı
update public.water_bodies set latitude=39.472701, longitude=29.865944, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/315550/enne-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:315550:cc2734ff-0534-4d6f-be9b-c414f212bd32' where id='cc2734ff-0534-4d6f-be9b-c414f212bd32';

-- Aydın-Yaylakavak Barajı | GeoNames | Yaylakavak Barajı
update public.water_bodies set latitude=37.57712, longitude=27.803848, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/309005/yaylakavak-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:309005:e67b83d0-2cab-4724-b471-721c8f3612fa' where id='e67b83d0-2cab-4724-b471-721c8f3612fa';

-- Kütahya-Pullar Göleti | OSM/Photon | Pullar Göleti
update public.water_bodies set latitude=39.3460285, longitude=29.8244463, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=g%C3%B6leti&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:Pullar Göleti:e883ccca-fda1-4ff2-91ae-340f83a406e7' where id='e883ccca-fda1-4ff2-91ae-340f83a406e7';

-- Balıkesir-İkizcetepeler Barajı | OSM/Photon | İkizce Tepeler Barajı
update public.water_bodies set latitude=39.4918552, longitude=27.9392581, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://photon.komoot.io/api/?q=baraj%C4%B1&countrycode=TR&limit=50 | OpenStreetMap via Photon; exact water-name + province match; general waterbody position, not fishing-access point.', external_source_id='osm:İkizce Tepeler Barajı:eaecf987-d3ed-4008-9c4e-42b9d65524e7' where id='eaecf987-d3ed-4008-9c4e-42b9d65524e7';

-- Adıyaman-Mülk Göleti | Meraloji/OSM recheck | Mülk Göleti
update public.water_bodies set latitude=37.728192, longitude=38.603477, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://github.com/ugurkgs/meraloji-engine/blob/24f0046b76ed6775c20cbf54c902518ae1e3d505/tr-lakes.json | Existing OSM-derived coordinate rechecked against province-matched Meraloji audit; general waterbody position, not fishing-access point.' where id='f179e693-23c6-466a-857e-4b85aeb92024';

-- Aydın-Yaylakavak Barajı | GeoNames | Yaylakavak Barajı
update public.water_bodies set latitude=37.57712, longitude=27.803848, verification_level='B', verification_status='verified', source_checked_at=now(), last_verified_at=now(), source_reference='https://www.geonames.org/309005/yaylakavak-baraji.html | GeoNames exact water-name + province match with compatible hydro feature class; general waterbody position, not fishing-access point.', external_source_id='geonames:309005:f862a6b1-46f0-46e5-b6b7-27603a5d4cc4' where id='f862a6b1-46f0-46e5-b6b7-27603a5d4cc4';
commit;
