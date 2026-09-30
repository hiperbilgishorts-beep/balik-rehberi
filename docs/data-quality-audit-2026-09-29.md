# Balık Rehberi — Veri Kalitesi Denetimi

**Denetim tarihi:** 2026-09-30  
**Kaynak:** Canlı Supabase veritabanı `uilplrllepuyofmdxqox`. Bu rapor şema ve kayıt metaverisi denetimidir; Google Maps/Yandex Maps üzerinde yapılmış gerçek eşleşme doğrulaması değildir.

## Su kaynakları (1.695 kayıt)

| Kontrol | Sonuç | Yorum |
|---|---:|---|
| Baraj / rezervuar | 1.396 | 790 koordinatlı; 606 koordinat bekliyor |
| Gölet | 294 | 128 koordinatlı; 166 koordinat bekliyor |
| Doğal göl | 5 | 5 koordinatlı; ilçe alanları ayrıca tamamlanmalı |
| Koordinatı eksik | 772 / 1.695 (45,5%) | 923 kayıt koordinatlıdır (%54,5); koordinatlı olmak erişim veya av izni kanıtı değildir |
| `source_id` eksik | 38 / 1.695 | Kaynağın normalleştirilmiş kaynak tablosuna bağlantısı yok |
| `source_reference` eksik | 10 / 1.695 | Kaynak referansı alanı doldurulmalı veya doğrulanmalı |
| Balıkçılık uygunluğu bilinmiyor | 1.668 / 1.695 | Kaydın varlığı, balıkçılığa uygunluğu kanıtlamaz |
| Tekrarlanan `normalized_name` grupları | 11 | 13 fazla kayıt; otomatik silme yapılmadı |
| Fazladan tekrar kaydı | 13 | İsimler farklı illerde aynı gerçek suyu ifade edebileceğinden elle/kanıtla çözülmeli |

### Tespit edilen yinelenen adlar

| Normalleştirilmiş ad | Kayıt | İl durumu |
|---|---:|---|
| İstanbul-Alibey Barajı | 3 | İstanbul |
| İstanbul-Ömerli Barajı | 3 | İstanbul |
| Adana-Seyhan Barajı | 2 | Adana |
| Ankara-Sarıyar Barajı | 2 | Ankara |
| Beyşehir Gölü | 2 | Isparta ve Konya |
| Bursa-Gölbaşı Barajı | 2 | Bursa |
| Edirne-Altınyazı Barajı | 2 | Edirne |
| İstanbul-Büyükçekmece Barajı | 2 | İstanbul |
| İstanbul-Sazlıdere Barajı | 2 | İstanbul |
| Niğde-Gebere Barajı | 2 | Niğde |
| Tekirdağ-Karaidemir Barajı | 2 | Tekirdağ |

Bu gruplar **silinmedi veya birleştirilmedi**. Özellikle Beyşehir Gölü gibi il sınırlarını aşan su kütlelerinde farklı kayıtlar ayrı amaçlarla tutuluyor olabilir. Son karar harita geometrisi ve resmî kaynak kimliği karşılaştırıldıktan sonra verilmeli.

## Balık ve kaynak kalitesi

- Balık türleri: 21 kayıt; 18 kayıtta `source_reference` alanı boş.
- Su kaynaklarıyla tür ilişkileri: önceki canlı sayımda 37 ilişki; bunlar tek başına türün her konumda bulunduğunu kanıtlamaz.
- Avlanma kuralları: kaynak, geçerlilik tarihi, coğrafi kapsam, tür ve istisnalar birlikte kontrol edilmeli.
- Kaynak kayıtları: 39 toplam; 26 `verified`, 13 `pending`. Bu etiketler her kaynak sayfasının içeriğinin tek tek yeniden kontrol edildiği anlamına gelmez.
- Balıkçılık noktaları: 9 kayıt; 1 koordinatlı; 0 `verified`. Koordinat ve saha erişim durumu ayrıca denetlenmeli.

## Sonraki veri düzeltme politikası

1. Eksik ilçe alanları yalnızca resmî su envanteri veya güvenilir harita eşleşmesiyle doldurulmalı.
2. Her kayıt için kaynak tablosuna `source_id`, erişilebilir kanıt URL'si ve kontrol tarihi eklenmeli.
3. Harita koordinatı ve su kaynağı varlığı ayrı ayrı doğrulanmalı; harita pimi güvenli erişim/avlanma izni anlamına gelmez.
4. Mükerrer isimler koordinat, dış kaynak kimliği ve su tipi uyuşmadan otomatik birleştirilmemeli.
5. Balık türü ilişkileri ile avlanma kuralları için kaynak ve geçerlilik aralığı zorunlu kalite ölçütü olmalı.
6. Doğrulama durumu, veri tamlığına dair ölçütlerle uyumlu hâle getirilmeli; eksik koordinatları olan kayıtlar yalnızca bu nedenle silinmemeli.

## Harita uygulamasına yönlendirme

Su kaynağı ayrıntı ekranında Google Maps, Yandex Maps ve cihazın varsayılan harita uygulamasını açma seçenekleri bulunur. Bu seçenekler yalnızca koordinat mevcutsa çalışır. Güncel denetimde 923 kayıt koordinatlı, 772 kayıt koordinatsızdır; her pin genel su konumunu gösterir ve kıyıya erişim veya avlanma izni anlamına gelmez.

## Güncel kapsam özeti (2026-09-30)

- Koordinat kapsamı: **923 / 1.695 (%54,5)**.
- Eksik koordinatlar: **606 baraj/rezervuar + 166 gölet = 772 kayıt**.
- Koordinatı olan kayıtların 894'ünde `source_id`, 923'ünde kaynak referansı ve 923'ünde koordinat güven derecesi vardır.
- Kaynak ataması bulunmayan koordinatlı kayıtlar ayrıca denetlenmelidir; koordinat sayısı tek başına veri kalitesi puanı değildir.
- Olta Atlası mera kataloğunda 1.448 kayıt listelenmiştir (64 B, 231 C, 1.153 D). Bu kaynak listelerindeki kayıtlar genel konum/rota rehberi olarak tutulur; kaynak sayfası açık koordinat vermiyorsa su kaynağı koordinatı olarak kopyalanmaz.
- Son hedefli OSM/Photon kontrol grubunda ad + il + su türü birlikte uyuşan yeni koordinat bulunmadı. Eşleşmeyen adaylar veritabanına koordinat olarak yazılmadı.
