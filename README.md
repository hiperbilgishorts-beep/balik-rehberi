# Balık Rehberi Türkiye

Türkiye'deki balıkçılık noktalarını, su kaynaklarını, balık türlerini, av yöntemlerini, yemleri ve güncel av kurallarını tek yerde sunmayı hedefleyen Android + iOS uygulaması.

## Proje hedefi

- Türkiye haritasında balık tutulabilecek su kaynaklarını göstermek
- İl, ilçe, konum ve mesafeye göre filtreleme
- Balık türüne göre uygun su kaynaklarını bulma
- Balık türleri için yem, yöntem, mevsim ve boy bilgileri
- Su kaynağı bazında bulunan türler ve sezon bilgileri
- Güncel amatör avcılık mevzuatı ve yerel kısıtlamalar
- Supabase tabanlı merkezi veri altyapısı
- Android ve iOS için ortak uygulama kod tabanı

## Veri yaklaşımı

Veriler mümkün olduğunca resmi Türkiye kaynaklarından doğrulanacak. Tür biyolojisi ve av tekniği gibi alanlarda güvenilir uluslararası bilimsel kaynaklar kullanılabilir. Bir bilginin kaynağı doğrulanamıyorsa kesin bilgi olarak sunulmayacak.

## Ana veri katmanları

1. Su kaynakları
2. İl / ilçe / koordinat
3. Resmi avlaklar
4. Balık türleri
5. Su kaynağı - balık ilişkileri
6. Yemler
7. Av yöntemleri
8. Mevsimsel aktivite
9. Av kuralları ve yasak dönemler
10. Kaynaklar ve doğrulama kayıtları

## Geliştirme stratejisi

Replit proje geliştirme ortamı olarak kullanılabilir; GitHub bu repository üzerinden ana kod arşivi olarak tutulacaktır. Supabase merkezi veritabanıdır. Replit limitleri nedeniyle geliştirme ortamı değişse bile proje bağımsız şekilde sürdürülebilmelidir.

## Güvenlik

Supabase parolaları, API secret'ları ve kişisel erişim anahtarları repository'ye kesinlikle eklenmemelidir. Hassas yapılandırmalar ortam değişkenlerinde tutulmalıdır.
