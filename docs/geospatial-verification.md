# Su kaynakları için harita konumu doğrulama süreci

## Mevcut durum (2026-09-29)

- Kanonik su kaynağı kaydı: 1.695
- Kanonik kayıtlarda enlem + boylam bulunan: 0
- Harita sağlayıcıları için oluşturulan inceleme işleri: Google Maps 1.695, Yandex Maps 1.695
- Doğrulanmış harita eşleşmesi: 0

İnceleme işleri yalnızca kuyruk kaydıdır. Hiçbir koordinat tahmin edilmedi ve `water_bodies.latitude/longitude` alanlarına yazılmadı.

## Güvenilirlik ilkeleri

1. Harita arama sonucu tek başına su kaynağının resmî varlığını, balıkçılığa uygunluğunu veya erişim iznini kanıtlamaz.
2. Eşleşme; normalize edilmiş ad, il, ilçe, su tipi ve mümkünse resmî kaynakta geçen ek tanımlayıcılarla değerlendirilir.
3. Aynı isimli baraj/gölet/lake adayları otomatik olarak birleştirilmez.
4. Konum doğrulaması, kayıt varlığı doğrulamasından ayrı tutulur. `verification_status` ve `verification_level` tek başına konum doğrulandı anlamına gelmez.
5. Kanonik koordinatlar yalnızca kanıt URL'si, sağlayıcı kimliği ve kontrol zamanı bulunan gözden geçirilmiş bir adaydan alınır.
6. Harita koordinatı kıyıya güvenli erişim noktası, balıkçılık izni veya halka açık giriş olduğunu göstermez.

## Önerilen eşleşme değerlendirmesi

- **0,90–1,00:** Ad + il/ilçe + su tipi tutarlı ve kaynak kanıtı mevcut; yine de otomatik yayın öncesi kontrol.
- **0,75–0,89:** Muhtemel eşleşme; insan incelemesi gerekir.
- **0,00–0,74:** Belirsiz eşleşme; kanonik koordinatlara aktarılmaz.

Bu puanlar aday sıralaması için önerilen eşiklerdir; sağlayıcı tarafından verilmiş doğruluk garantisi değildir.

## Uygulama ve gizli anahtarlar

Google Maps/Yandex Maps sorguları için uygun API erişimi, sağlayıcı koşullarına uygun kullanım ve sunucu tarafında saklanan kimlik bilgileri gerekir. Gizli anahtarlar mobil uygulama veya istemci koduna konulmamalıdır. Sağlayıcı API erişimi yapılandırılmadan kuyruk otomatik olarak doldurulmuş koordinat üretmez.

## Veritabanı

`public.water_body_location_checks` sağlayıcı bazında bir kayıt tutar. `status` değerleri: `pending`, `candidate_found`, `verified`, `rejected`, `needs_review`. Tablo RLS ile korunur ve anonim/normal kullanıcı rolleri tarafından doğrudan okunamaz veya değiştirilemez.
