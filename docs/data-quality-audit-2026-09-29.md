# Balık Rehberi — Veri Kalitesi Denetimi

**Denetim tarihi:** 2026-09-29  
**Kaynak:** Canlı Supabase veritabanı `uilplrllepuyofmdxqox`. Bu rapor şema ve kayıt metaverisi denetimidir; Google Maps/Yandex Maps üzerinde yapılmış gerçek eşleşme doğrulaması değildir.

## Su kaynakları (1.695 kayıt)

| Kontrol | Sonuç | Yorum |
|---|---:|---|
| Baraj / rezervuar | 1.396 | Tamamında ilçe ve koordinat eksik |
| Gölet | 294 | Tamamında ilçe ve koordinat eksik |
| Doğal göl | 5 | 4 kayıtta ilçe eksik; tamamında koordinat eksik |
| Koordinatı eksik | 1.695 / 1.695 | Harita üzerinde kesin konum ve yakınlık hesabı henüz yapılamaz |
| `source_id` eksik | 1.673 / 1.695 | Kaynağın normalleştirilmiş kaynak tablosuna bağlantısı yok |
| `source_reference` eksik | 18 / 1.695 | Kaynak referansı alanı doldurulmalı veya doğrulanmalı |
| Balıkçılık uygunluğu bilinmiyor | 1.668 / 1.695 | Kaydın varlığı, balıkçılığa uygunluğu kanıtlamaz |
| Tekrarlanan `normalized_name` grupları | 11 | Otomatik silme yapılmadı |
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

Su kaynağı ayrıntı ekranına Google Maps, Yandex Maps ve cihazın varsayılan harita uygulamasında yol tarifi açma seçenekleri eklendi. Bu seçenekler yalnızca koordinat mevcutsa çalışır. Şu an 1.695 kaydın hiçbirinde koordinat olmadığından düğme bilerek açıklayıcı bir eksik-veri mesajı gösterir.
