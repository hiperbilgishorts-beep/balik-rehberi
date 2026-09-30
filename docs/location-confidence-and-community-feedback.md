# Konum güvenilirliği ve mera kaynağı aktarımı

Son güncelleme: 2026-09-30

## A–F konum güveni

Bu puan, genel su gövdesi koordinatının kanıt düzeyini anlatır; kıyı erişimi, balık bulunması veya av izni anlamına gelmez.

- **A — Çapraz doğrulanmış:** Kaynak notunda birden fazla kaynakla çapraz kontrol belirtilmiş.
- **B — Güçlü ad/eşleşme kanıtı:** Kaynak notunda ad ve coğrafi bağlam eşleşmesi veya adlandırılmış su özelliği kaydı bulunuyor.
- **C — Kısmi kaynak kanıtı:** Koordinat var ve kaynak notu mevcut; çapraz kontrol sınırlı.
- **D — Kaynak notu eksik:** Koordinat var ama izlenebilir kaynak notu yok.
- **E — Çok düşük güven:** Gelecekte manuel inceleme veya çelişkili kaynak durumları için ayrılmış.
- **F — Koordinat yok / kontrol gerekli:** Genel koordinat doğrulanmamış veya eksik.

Kaynak sınıfı ile koordinat güveni ayrı alanlardır. `verification_level` genel kayıt doğrulamasını, `coordinate_confidence_grade` koordinat kanıtını, `community_confidence_grade` kullanıcı geri bildiriminden türeyen topluluk sinyalini tutar.

## Olta Atlası mera kataloğu

`supabase/seeds/import-olta-atlasi-meralar-metadata.sql` Olta Atlası'nın kamuya açık mera arşivinden rota adı, il/ilçe/bölge, su türü, kaynak güven sınıfı ve kaynak bağlantısını alır. Kaynak koordinatları ve kaynak tarafından yazılmış açıklama metinleri kopyalanmaz. Her kayıt `coordinates_imported=false` olarak kalır; bu kayıtlar kaynak rehberi bağlantısıdır, doğrulanmış harita pini değildir.

Kaynak sınıfları şu an A–D olarak aktarılır. Olta Atlası arşivinde görülen B/C/D sayıları kaynak sayfasının o anki içeriğine bağlıdır; bu puanlar bizim koordinat güven puanımızla aynı şey değildir.

## Topluluk geri bildirimi

`water_body_location_feedback` kullanıcı başına su kaynağı başına tek kayıt tutar. Oylar ve isteğe bağlı notlar RLS ile kullanıcının kendi kaydına sınırlandırılır. Uygulama anonim Supabase oturumu açarak giriş formu olmadan oy göndermeyi dener; bunun için Supabase Auth ayarlarında **Anonymous Sign-Ins** etkin olmalıdır.

`water_body_feedback_summary` yalnızca toplu oy sayılarını ve topluluk puanını gösterir. Özel oy kayıtları halka açılmaz. Topluluk puanı, net olumlu oylar en az 5/10/15/20/25 olduğunda sırasıyla E/D/C/B/A seviyesine çıkar; olumsuz oylar net sayıyı düşürür. Bu puan, kaynak tabanlı koordinat güveninin yerine geçmez ve tek başına resmî doğrulama sayılmaz.

## Kullanıcıya gösterilen mesajlar

- A: **Güvenilir konum**
- B: **Güvenilir genel konum**
- C: **Konum kontrolü önerilir**
- D/E/F: **Kontrol ediniz**
- Koordinat yoksa hiçbir güven seviyesi navigasyon koordinatı varmış gibi sunulmaz.