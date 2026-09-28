-- 2026 freshwater-fish baseline
-- Source baseline: Kaya et al. 2025/2026 critical checklist + official Turkish water/fisheries portals.
-- This seed is intentionally limited to species whose Turkish freshwater occurrence is well established.

insert into sources (name, organization, url, source_type, accessed_at, verification_status, notes, source_scope, last_checked_at)
select 'A Critical Checklist of Turkish Freshwater Fishes (2026)', 'Turkish Journal of Fisheries and Aquatic Sciences', 'https://doi.org/10.4194/TRJFAS29729', 'academic', now(), 'verified', 'Current taxonomic baseline; 390 freshwater species recognized for Türkiye in the 2026 checklist.', 'Türkiye tatlısu balıkları', now()
where not exists (select 1 from sources where url = 'https://doi.org/10.4194/TRJFAS29729');

insert into sources (name, organization, url, source_type, accessed_at, verification_status, notes, source_scope, last_checked_at)
select 'DSİ 2024 Resmi Su Kaynakları İstatistikleri', 'Devlet Su İşleri Genel Müdürlüğü', 'https://www.dsi.gov.tr/Sayfa/Detay/2186', 'official', now(), 'verified', 'Official water-resource and basin statistics.', 'Türkiye su kaynakları', now()
where not exists (select 1 from sources where url = 'https://www.dsi.gov.tr/Sayfa/Detay/2186');

insert into sources (name, organization, url, source_type, accessed_at, verification_status, notes, source_scope, last_checked_at)
select 'Su Ürünleri Veri ve Dokümanları', 'Tarım ve Orman Bakanlığı Balıkçılık ve Su Ürünleri Genel Müdürlüğü', 'https://www.tarimorman.gov.tr/Konular/Su-Urunleri/Su-Urunleri-Veri-Ve-Dokumanlari', 'official', now(), 'verified', 'Official fisheries data and document portal.', 'Türkiye su ürünleri', now()
where not exists (select 1 from sources where url = 'https://www.tarimorman.gov.tr/Konular/Su-Urunleri/Su-Urunleri-Veri-Ve-Dokumanlari');

with src as (select id from sources where url='https://doi.org/10.4194/TRJFAS29729' limit 1), species(common_name_tr,scientific_name,family,description,habitat,feeding,native_status,endemic_status) as (values
('Çapak balığı','Abramis brama','Cyprinidae','Ilıman tatlı sularda yaşayan yaygın bir sazangil türüdür.','Göller, baraj gölleri ve yavaş akan nehirler','Omnivor; bentik omurgasızlar ve bitkisel materyal','native',false),
('Bıyıklı balık','Barbus barbus','Cyprinidae','Akarsu sistemlerinde görülen bir barbus türüdür.','Akarsular, taşlık ve çakıllı tabanlar','Bentik omurgasızlar ve küçük su canlıları','native',false),
('Kababurun','Chondrostoma nasus','Leuciscidae','Akarsu ekosistemlerinde alg ve bentik materyalle beslenen sazangil türü.','Akarsular ve göl çıkışları','Ağırlıklı olarak alg ve perifiton','native',false),
('Tatlısu levreği','Perca fluviatilis','Percidae','Tatlısu ekosistemlerinde yaşayan yırtıcı bir levrek türüdür.','Göller, barajlar ve yavaş akan sular','Etçil; küçük balıklar ve omurgasızlar','native',false),
('Yayın balığı','Silurus glanis','Siluridae','Türkiye içsularında bulunan büyük gövdeli tatlısu yırtıcısıdır.','Büyük göller, barajlar ve yavaş akan nehirler','Etçil; balıklar ve diğer su canlıları','native',false),
('Dere alabalığı','Salmo trutta','Salmonidae','Soğuk ve oksijence zengin sularda yaşayan alabalık grubunun temel türlerinden biridir.','Soğuk akarsular ve yüksek rakımlı göller','Omurgasızlar ve küçük balıklar','native',false),
('İnci kefali','Alburnus tarichi','Leuciscidae','Van Gölü havzasının karakteristik ve ekonomik öneme sahip balıklarından biridir.','Van Gölü havzası ve bağlantılı akarsular','Planktonik ve küçük omurgasızlar','native',true),
('Turna','Esox lucius','Esocidae','Pusu kurarak avlanan tatlısu yırtıcısıdır.','Bitkili göller, barajlar ve yavaş akan sular','Etçil; başlıca balıklar','native',false),
('Kızılkanat','Scardinius erythropthalmus','Leuciscidae','Sakin ve bitkili tatlısularda yaşayan sazangil türüdür.','Göller, göletler ve yavaş akan sular','Omnivor; bitkisel materyal ve küçük omurgasızlar','native',false),
('Kızılgöz','Rutilus rutilus','Leuciscidae','Sakin tatlısularda yaşayan yaygın bir sazangil türüdür.','Göller ve yavaş akan nehirler','Omnivor','native',false),
('Vimba','Vimba vimba','Leuciscidae','Akarsu ve göl sistemlerinde görülen göç davranışı gösterebilen sazangil türü.','Akarsular, göller ve baraj sistemleri','Bentik omurgasızlar ve bitkisel materyal','native',false),
('Kadife balığı','Tinca tinca','Tincidae','Sakin ve bitkili tatlısularda yaşayan dayanıklı bir türdür.','Göller, göletler ve yavaş akan sular','Omnivor; bentik canlılar ve bitkisel materyal','native',false),
('Gökkuşağı alabalığı','Oncorhynchus mykiss','Salmonidae','Türkiye içsularında yerleşmiş/tekrarlı kaydı bulunan yabancı alabalık türüdür.','Soğuk ve oksijence zengin akarsular, göller ve yetiştiricilik sistemleri','Etçil/omnivor; sucul omurgasızlar ve küçük canlılar','established_non_native',false),
('Kızılkanat kefali','Capoeta tinca','Cyprinidae','Türkiye içsularında çeşitli havzalarda kaydedilen otçul ağırlıklı sazangil türüdür.','Akarsular ve göl kıyıları','Alg, perifiton ve bitkisel materyal','native',false),
('Sazan','Cyprinus carpio','Cyprinidae','Türkiye içsu balıkçılığında ekonomik ve sportif açıdan önemli türlerden biridir.','Göller, barajlar, göletler ve yavaş akan nehirler','Omnivor','native',false)
)
insert into fish_species (id,common_name_tr,scientific_name,family,description,habitat,feeding,native_status,endemic_status,source_id,verification_level,verification_status,created_at,updated_at,source_checked_at,last_verified_at,source_reference)
select gen_random_uuid(), s.common_name_tr,s.scientific_name,s.family,s.description,s.habitat,s.feeding,s.native_status,s.endemic_status,src.id,'A','verified',now(),now(),now(),now(),'https://doi.org/10.4194/TRJFAS29729'
from species s cross join src
where not exists (select 1 from fish_species f where lower(coalesce(f.scientific_name,''))=lower(s.scientific_name));
