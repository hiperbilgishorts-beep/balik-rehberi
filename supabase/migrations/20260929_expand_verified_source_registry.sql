alter table public.source_registry
  add column if not exists supported_uses text[] not null default '{}';

insert into public.source_registry (source_key,name,kind,priority,base_url,supported_uses) values
('tarim_orman_bsgm','Tarım ve Orman Bakanlığı - Balıkçılık ve Su Ürünleri Genel Müdürlüğü','official',100,'https://www.tarimorman.gov.tr/BSGM',array['regulation','closed_season','minimum_size','daily_limit','local_restriction','official_notices']),
('resmi_gazete','Resmî Gazete','official',100,'https://www.resmigazete.gov.tr/',array['legal_text','effective_dates','amendments']),
('dsi','Devlet Su İşleri Genel Müdürlüğü','official',95,'https://www.dsi.gov.tr/',array['reservoir','dam','lake','river','water_infrastructure']),
('il_tarim','İl Tarım ve Orman Müdürlükleri','official',95,'https://www.tarimorman.gov.tr/',array['local_regulation','stocking','local_closure','official_spot_notices']),
('fishbase','FishBase','scientific',90,'https://www.fishbase.se/',array['taxonomy','biology','habitat','distribution','feeding']),
('fao_fisheries','FAO Fisheries and Aquaculture','scientific',90,'https://www.fao.org/fishery/en',array['fisheries_science','species','habitat','management']),
('gbif','Global Biodiversity Information Facility','scientific',88,'https://www.gbif.org/',array['occurrence_records','distribution','taxonomy']),
('iucn_red_list','IUCN Red List of Threatened Species','scientific',88,'https://www.iucnredlist.org/',array['conservation_status','threats','distribution']),
('catalogue_of_life','Catalogue of Life','scientific',85,'https://www.catalogueoflife.org/',array['taxonomy','accepted_names','synonyms']),
('worms','World Register of Marine Species','scientific',85,'https://www.marinespecies.org/',array['marine_taxonomy','marine_synonyms']),
('tagem_su_urunleri','TAGEM Su Ürünleri Araştırma Enstitüleri','official',92,'https://arastirma.tarimorman.gov.tr/elazigsuurunleri/',array['turkish_freshwater_research','stocking','species_research']),
('open_meteo','Open-Meteo Weather API','scientific',80,'https://open-meteo.com/en/docs',array['forecast','wind','precipitation','air_temperature']),
('copernicus_marine','Copernicus Marine Service','scientific',85,'https://marine.copernicus.eu/',array['marine_conditions','sea_surface_temperature','waves','currents']),
('openstreetmap','OpenStreetMap','secondary',70,'https://www.openstreetmap.org/copyright',array['base_map','roads','geographic_context']),
('oltaatlasi','Olta Atlası','secondary',65,'https://oltaatlasi.com/',array['fishing_spot','reported_species','method','bait','access_notes','navigation']),
('balikrotasi','Balık Rotası','secondary',60,'https://balikrotasi.com/map',array['species_guide','seasonal_activity','method','bait','community_feature'])
on conflict (source_key) do update
set name=excluded.name,kind=excluded.kind,priority=excluded.priority,base_url=excluded.base_url,supported_uses=excluded.supported_uses,active=true,updated_at=now();

with source_data(name,organization,url,source_type,source_scope,notes) as (
  values
  ('Tarım ve Orman Bakanlığı - BSGM','T.C. Tarım ve Orman Bakanlığı','https://www.tarimorman.gov.tr/BSGM','official','Türkiye; amatör ve ticari su ürünleri mevzuatı','Mevzuat için resmî birincil kaynak. Belge ve yürürlük tarihi ayrıca kontrol edilir.'),
  ('Resmî Gazete','T.C. Cumhurbaşkanlığı','https://www.resmigazete.gov.tr/','official','Türkiye; yayımlanmış mevzuat','Yayımlanmış hukuki metin ve değişikliklerin birincil kaynağı.'),
  ('Devlet Su İşleri Genel Müdürlüğü','DSİ','https://www.dsi.gov.tr/','official','Türkiye; su yapıları ve hidroğrafya','Su kaynağı varlığını doğrulamak için; tek başına balık varlığını veya av iznini kanıtlamaz.'),
  ('FishBase Species Database','FishBase Consortium','https://www.fishbase.se/','academic','Küresel; balık taksonomisi ve biyolojisi','Bilimsel tür profilleri; yerel varlık ayrıca doğrulanır.'),
  ('FAO Fisheries and Aquaculture','Food and Agriculture Organization of the United Nations','https://www.fao.org/fishery/en','academic','Küresel; balıkçılık bilimi ve yönetimi','Araştırma ve yönetim bağlamı; yerel mevzuat yerine geçmez.'),
  ('Global Biodiversity Information Facility','GBIF','https://www.gbif.org/','academic','Küresel; tür gözlem kayıtları','Gözlem kayıtları koordinat, tarih ve veri sağlayıcı kalitesiyle birlikte değerlendirilir.'),
  ('IUCN Red List','International Union for Conservation of Nature','https://www.iucnredlist.org/','academic','Küresel; koruma durumu','Koruma durumu kaynağı; yerel av izni yerine geçmez.'),
  ('Catalogue of Life','Catalogue of Life','https://www.catalogueoflife.org/','academic','Küresel; taksonomi','Bilimsel ad ve sinonim kontrolü için.'),
  ('World Register of Marine Species','WoRMS Editorial Board','https://www.marinespecies.org/','academic','Deniz türleri; taksonomi','Yalnızca uygun deniz taksonlarında kullanılmalı.'),
  ('TAGEM Su Ürünleri Araştırma Enstitüleri','Tarım ve Orman Bakanlığı - TAGEM','https://arastirma.tarimorman.gov.tr/elazigsuurunleri/','official','Türkiye; iç su balıkları araştırmaları','Araştırma çıktısı/rapor başlığı ve tarihi ayrıca doğrulanmalı.'),
  ('Open-Meteo Weather API','Open-Meteo','https://open-meteo.com/en/docs','secondary','Hava tahmini; koordinata dayalı','Tahmin verisi; gözlem değildir. Tahmin zamanı ve sağlayıcı alanları korunmalı.'),
  ('Copernicus Marine Service','European Union Copernicus Programme','https://marine.copernicus.eu/','official','Deniz koşulları ve oşinografi','Deniz verileri için; iç su sıcaklığına genellenmemeli.'),
  ('OpenStreetMap','OpenStreetMap contributors','https://www.openstreetmap.org/copyright','secondary','Harita tabanı ve coğrafi bağlam','Harita verisi atıf/lisans koşullarına uygun kullanılmalı.'),
  ('Olta Atlası','Olta Atlası','https://oltaatlasi.com/','secondary','Avlak/rota ve saha rehberleri','İkincil kaynak; avlanma izni ve tür varlığı resmî/bilimsel kaynakla ayrı doğrulanır.'),
  ('Balık Rotası','Balık Rotası','https://balikrotasi.com/map','secondary','Tür rehberi, mevsim ve pratik avcılık bilgisi','İkincil kaynak; içerik ve yöntemler kaynak/erişim tarihiyle tutulur.')
)
insert into public.sources(name,organization,url,source_type,verification_status,notes,source_scope)
select d.name,d.organization,d.url,d.source_type,'pending',d.notes,d.source_scope
from source_data d
where not exists (select 1 from public.sources s where s.url=d.url);

-- These ingestion/audit tables remain private to backend operations.
alter table public.source_registry enable row level security;
alter table public.data_claims enable row level security;
alter table public.data_ingestion_runs enable row level security;
revoke all on public.source_registry, public.data_claims, public.data_ingestion_runs from anon, authenticated;
grant all on public.source_registry, public.data_claims, public.data_ingestion_runs to service_role;
