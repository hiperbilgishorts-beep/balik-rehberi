# Balık Rehberi Türkiye

Türkiye'deki balıkçılık noktalarını, su kaynaklarını, balık türlerini, av yöntemlerini, yemleri ve güncel av kurallarını tek yerde sunmayı hedefleyen Android + iOS uygulaması.

## Proje hedefi

- Türkiye haritasında balık tutulabilecek su kaynaklarını göstermek
- İl bazında listeleme ve genel su kaynağı koordinatları
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
2. İl / koordinat
3. Resmi avlaklar
4. Balık türleri
5. Su kaynağı - balık ilişkileri
6. Yemler
7. Av yöntemleri
8. Mevsimsel aktivite
9. Av kuralları ve doğrulama kayıtları

## Geliştirme ve Android test sürümü

Replit proje geliştirme ortamı olarak kullanılabilir; GitHub bu repository üzerinden ana kod arşivi olarak tutulacaktır. Supabase merkezi veritabanıdır. Replit limitleri nedeniyle geliştirme ortamı değişse bile proje bağımsız şekilde sürdürülebilmelidir.

**Önemli:** `assembleDebug` ile üretilen debug APK, uygulamanın JavaScript kodunu bilgisayardaki Metro geliştirme sunucusundan almaya çalışır. Bu APK telefona tek başına yüklendiğinde `localhost` / Metro bağlantı hatası verebilir. Telefonda bilgisayara bağlı olmadan açılabilen sürüm için GitHub Actions'ın **balik-rehberi-android-standalone-apk** artifact'ındaki `app-release.apk` kullanılmalıdır. Release APK, uygulama JS paketini kendi içinde taşır; Supabase verileri ise internet üzerinden alınır. Bu değişiklikten sonra ilk yeni GitHub Actions çalışmasının başarıyla tamamlanması gerekir.

Geliştirme sırasında Expo Go ile çalışıyorsan Metro yine gereklidir. Aynı Wi-Fi ağı üzerinden bağlantı kurulamıyorsa `npx expo start --tunnel` kullanılabilir. Bu geliştirme bağlantısıdır; son kullanıcıya verilecek bağımsız APK ile karıştırılmamalıdır.

## Supabase ortam değişkenleri

Yerel geliştirme için `.env.example` dosyasını `.env` olarak kopyala ve gerçek proje bilgileriyle doldur:

- `EXPO_PUBLIC_SUPABASE_URL`
- `EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY`

Mobil uygulamada yalnızca publishable key kullanılmalıdır; secret/service-role key uygulama paketine konulmamalıdır. GitHub Actions tarafında aynı adlarla tanımlanan değişkenler REST bağlantı testinde kullanılır.

## Güvenlik

Supabase parolaları, secret/service-role API anahtarları ve kişisel erişim anahtarları repository'ye kesinlikle eklenmemelidir. Hassas yapılandırmalar ortam değişkenlerinde tutulmalıdır.
