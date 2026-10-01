# Google Play Store yayın kontrol listesi — Balık Rehberi Türkiye

Bu liste, 1 Ekim 2026 tarihinde repoda görülen yapılandırmaya göre tutulur.

## Repoda hazır olanlar
- [x] Expo Router ile Android uygulama akışı
- [x] Harita, su kaynakları, balık rehberi ve “Meralar & Göletler” ekranı
- [x] Supabase REST bağlantı kontrolü CI adımı
- [x] TypeScript kontrolü ve Android JavaScript bundle kontrolü
- [x] CI'da release APK ve Android App Bundle (AAB) üretim adımı
- [x] Gizlilik politikası taslağı: `PRIVACY_POLICY.md`

## Mağazaya göndermeden önce tamamlanması gerekenler
- [ ] **Kalıcı Android imzalama anahtarı:** CI'nin debug keystore ile ürettiği bir AAB'yi doğrudan mağazaya yüklemeyin. Kalıcı upload keystore veya Expo EAS tarafından yönetilen üretim kimlik bilgileri oluşturulmalı ve güvenli şekilde saklanmalı.
- [ ] **Expo/EAS projesi:** Üretim build'i EAS üzerinden alınacaksa proje kimliği ve gerekli Expo hesabı/token yapılandırılmalı.
- [ ] **Uygulama simgesi ve açılış görseli:** Repoda henüz uygulamaya ait özel ikon/splash dosyası görünmüyor.
- [ ] **Mağaza grafikleri:** 512×512 uygulama simgesi, telefon ekran görüntüleri ve Play Store tanıtım görseli hazırlanmalı.
- [ ] **Gizlilik politikası adresi:** `PRIVACY_POLICY.md` herkese açık, kalıcı bir HTTPS sayfasında yayımlanmalı; destek e-posta adresi eklenmeli.
- [ ] **Data safety formu:** Konum izni, Supabase ağ istekleri ve anonim konum geri bildirimi gerçek uygulama davranışıyla karşılaştırılarak beyan edilmeli.
- [ ] **Mağaza metinleri:** Kısa açıklama, tam açıklama, kategori, iletişim bilgileri ve içerik derecelendirmesi girilmeli.
- [ ] **Gerçek cihaz testi:** Android'de ilk açılış, Supabase bağlantısı, harita, arama, mera listesi, konum izni reddedildiğinde davranış ve dış harita bağlantıları test edilmeli.
- [ ] **Google Play Console:** Geliştirici hesabı ve gerekli test/yayın adımları tamamlanmalı; AAB önce test kanalına yüklenmeli.
- [ ] **Üretim yayını:** Test sonuçları kabul edildikten sonra üretim sürümü gönderilmeli.

## CI durumu
GitHub Actions, `android/app/build/outputs/apk/release/app-release.apk` ve `android/app/build/outputs/bundle/release/app-release.aab` çıktıları üretmek üzere ayarlı. Başarılı bir build, imzalama anahtarı ve Play Console gereksinimlerinin tamamlandığı anlamına gelmez.

## Veri kalite notu
Mera koordinatları kaynak sayfasındaki genel konum adaylarıdır. Bunlar balık tutma erişim noktası veya izin bilgisi olarak sunulmamalıdır. Bağımsız doğrulama olmayan kayıtların güven düzeyi ve kaynak notu uygulamada görünür kalmalıdır.
