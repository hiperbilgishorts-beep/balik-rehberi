import { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, Linking, Platform, Pressable, SafeAreaView, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { getWaterBodyDetail } from '../../src/lib/data';
import type { WaterBodyDetail } from '../../src/types/database';
import { supabase } from '../../src/config/supabase';

export default function WaterBodyDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const [detail, setDetail] = useState<WaterBodyDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [feedbackBusy, setFeedbackBusy] = useState(false);
  const [feedbackNote, setFeedbackNote] = useState('');
  const [showFeedback, setShowFeedback] = useState(false);

  useEffect(() => {
    if (!id) {
      setLoading(false);
      setError('Su kaynağı kimliği bulunamadı.');
      return;
    }
    getWaterBodyDetail(id).then(r => {
      setDetail(r.data);
      setError(r.error?.message ?? null);
      setLoading(false);
    });
  }, [id]);

  const submitFeedback = async (vote: 'correct' | 'incorrect' | 'unclear') => {
    if (!supabase) {
      Alert.alert('Bağlantı yok', 'Geri bildirim şu anda gönderilemiyor.');
      return;
    }
    setFeedbackBusy(true);
    try {
      let user = (await supabase.auth.getUser()).data.user;
      if (!user) {
        const { data, error: authError } = await supabase.auth.signInAnonymously();
        if (authError) throw new Error('Geri bildirim için bağlantı kurulamadı. Lütfen daha sonra tekrar dene.');
        user = data.user;
      }
      if (!user) throw new Error('Oturum oluşturulamadı.');
      const { error: saveError } = await supabase.from('water_body_location_feedback').upsert(
        { water_body_id: id, user_id: user.id, vote, note: feedbackNote.trim() || null },
        { onConflict: 'water_body_id,user_id' },
      );
      if (saveError) throw saveError;
      setFeedbackNote('');
      setShowFeedback(false);
      Alert.alert('Teşekkürler', 'Geri bildirimin kaydedildi.');
    } catch (e: any) {
      Alert.alert('Gönderilemedi', e?.message ?? 'Geri bildirim kaydedilemedi.');
    } finally {
      setFeedbackBusy(false);
    }
  };

  if (loading) return <SafeAreaView style={styles.center}><ActivityIndicator /><Text style={styles.muted}>Su kaynağı bilgileri yükleniyor...</Text></SafeAreaView>;
  if (!detail) return <SafeAreaView style={styles.center}><Text>{error ?? 'Su kaynağı bulunamadı.'}</Text><Pressable onPress={() => router.back()}><Text style={styles.link}>Geri dön</Text></Pressable></SafeAreaView>;

  const w = detail.waterBody;
  const typeLabel = w.water_type === 'natural_lake' ? 'Göl' : w.water_type === 'reservoir' ? 'Baraj gölü' : w.water_type === 'pond' ? 'Gölet' : w.water_type || 'Su kaynağı';
  const openNavigation = async (provider: 'chooser' | 'google' | 'yandex' | 'apple') => {
    if (w.latitude == null || w.longitude == null) {
      Alert.alert('Koordinat bulunamadı', 'Bu su kaynağı için henüz harita koordinatı bulunmuyor.');
      return;
    }
    const lat = Number(w.latitude), lon = Number(w.longitude);
    const label = encodeURIComponent(w.name);
    const google = `https://www.google.com/maps/dir/?api=1&destination=${lat},${lon}`;
    const yandex = `https://yandex.com/maps/?rtext=~${lat},${lon}&rtt=auto`;
    const apple = `https://maps.apple.com/?daddr=${lat},${lon}&q=${label}`;
    const geo = Platform.OS === 'android' ? `geo:${lat},${lon}?q=${lat},${lon}(${label})` : apple;
    const url = provider === 'google' ? google : provider === 'yandex' ? yandex : provider === 'apple' ? apple : geo;
    try { await Linking.openURL(url); }
    catch {
      const fallback = provider === 'yandex' ? yandex : provider === 'apple' ? apple : google;
      try { await Linking.openURL(fallback); }
      catch { Alert.alert('Harita açılamadı', 'Cihazında uyumlu bir harita uygulaması veya tarayıcı bulunamadı.'); }
    }
  };
  const showNavigationOptions = () => Alert.alert('Haritada aç', 'Bir harita uygulaması seç.', [
    { text: 'Google Maps', onPress: () => { void openNavigation('google'); } },
    { text: 'Yandex Maps', onPress: () => { void openNavigation('yandex'); } },
    ...(Platform.OS === 'ios' ? [{ text: 'Apple Haritalar', onPress: () => { void openNavigation('apple'); } }] : []),
    { text: 'Cihazın harita uygulaması', onPress: () => { void openNavigation('chooser'); } },
    { text: 'Vazgeç', style: 'cancel' as const },
  ]);

  return <SafeAreaView style={styles.container}>
    <ScrollView contentContainerStyle={styles.content}>
      <Pressable onPress={() => router.back()}><Text style={styles.back}>‹ Geri</Text></Pressable>
      <View style={styles.hero}>
        <Text style={styles.eyebrow}>BALIK REHBERİ · SU KAYNAĞI</Text>
        <Text style={styles.title}>{w.name}</Text>
        <Text style={styles.location}>{[w.district, w.province].filter(Boolean).join(' · ') || 'Konum bilgisi bulunmuyor'}</Text>
        <View style={styles.badge}><Text style={styles.badgeText}>{typeLabel}</Text></View>
        <Text style={styles.heroNote}>Bu sayfa su kaynağını ve genel konumunu tanıtır. Belirli bir kıyı noktasına erişim veya avlanma izni anlamına gelmez.</Text>
      </View>

      <View style={styles.card}>
        <Text style={styles.section}>Genel bilgiler</Text>
        <View style={styles.grid}>
          <Info label="İl" value={w.province || 'Belirtilmemiş'} />
          <Info label="İlçe" value={w.district || 'Belirtilmemiş'} />
          <Info label="Su türü" value={typeLabel} />
          <Info label="Erişim bilgisi" value={w.access_level || 'Yerinde kontrol edilmeli'} />
          <Info label="Son bilgi kontrolü" value={w.last_verified_at ? new Date(w.last_verified_at).toLocaleDateString('tr-TR') : 'Belirtilmemiş'} />
        </View>
        {w.description ? <Text style={styles.body}>{w.description}</Text> : <Text style={styles.muted}>Bu su kaynağı için ek açıklama henüz eklenmemiş.</Text>}
      </View>

      <View style={styles.card}>
        <Text style={styles.section}>Kaynak bilgisi</Text>
        <Text style={styles.muted}>Konum bilgisi kaynak kayıtları üzerinden incelenir. Kaynak veya koordinat eşleşmesi güncellendikçe bu bölüm de güncellenebilir.</Text>
        {w.source_name ? <Text style={styles.sourceName}>Kaynak: {w.source_name}</Text> : null}
        {w.source_url ? <Pressable onPress={() => Linking.openURL(w.source_url!)}><Text style={styles.link}>Kaynak sayfasını görüntüle ↗</Text></Pressable> : null}
        {w.source_reference && w.source_reference !== w.source_url ? <Text style={styles.source}>{w.source_reference}</Text> : null}
        {!w.source_url && !w.source_reference ? <Text style={styles.warning}>Bu kayıt için doğrudan kaynak bağlantısı henüz eklenmemiş.</Text> : null}
      </View>

      <View style={styles.card}>
        <Text style={styles.section}>Konum</Text>
        {w.latitude != null && w.longitude != null ? <>
          <Text style={styles.coordinates}>{Number(w.latitude).toFixed(5)}, {Number(w.longitude).toFixed(5)}</Text>
          <Text style={styles.muted}>İşaret, su kaynağının genel konumunu gösterir; kıyı girişi veya güvenli varış noktası değildir.</Text>
          <Pressable style={styles.mapButton} onPress={showNavigationOptions}><Text style={styles.mapButtonText}>Haritada aç ↗</Text></Pressable>
        </> : <>
          <Text style={styles.muted}>Bu kayıt için koordinat henüz eklenmemiş. Konum bilgisi doğrulandığında burada gösterilecek.</Text>
          <View style={styles.pendingPill}><Text style={styles.pendingText}>Konum kontrolü bekliyor</Text></View>
        </>}
      </View>

      <View style={styles.card}>
        <Text style={styles.section}>Bu su kaynağında raporlanan balıklar</Text>
        {detail.fish.length === 0 ? <Text style={styles.muted}>Henüz ilişkilendirilmiş tür kaydı bulunmuyor.</Text> : detail.fish.map(f => <Pressable key={f.id} onPress={() => router.push(`/fish/${f.id}`)} style={styles.fishRow}>
          <Text style={styles.fishName}>{f.common_name_tr}</Text>
          {f.scientific_name ? <Text style={styles.scientific}>{f.scientific_name}</Text> : null}
          <Text style={styles.open}>Tür bilgisi ›</Text>
        </Pressable>)}
        <Text style={styles.smallNote}>Tür kayıtları güncel av başarısı veya av garantisi değildir.</Text>
      </View>

      <View style={styles.card}>
        <Text style={styles.section}>Gitmeden önce</Text>
        <Text style={styles.body}>Güncel amatör avcılık kurallarını, dönem ve tür kısıtlarını resmî kaynaklardan kontrol et. Erişim, özel mülkiyet, saha güvenliği ve koruma alanı koşulları ayrıca değerlendirilmelidir.</Text>
      </View>

      <View style={styles.feedbackCard}>
        <Text style={styles.feedbackHeading}>Bilgide bir düzeltme var mı?</Text>
        <Text style={styles.muted}>İstersen bu kaydın konumu veya bilgileri hakkında kısa bir geri bildirim bırakabilirsin. Bu tamamen isteğe bağlıdır.</Text>
        {!showFeedback ? <Pressable style={styles.optionalButton} onPress={() => setShowFeedback(true)}><Text style={styles.optionalButtonText}>İsteğe bağlı geri bildirim</Text></Pressable> : <>
          <TextInput value={feedbackNote} onChangeText={setFeedbackNote} placeholder="İstersen kısa bir not ekle (en fazla 500 karakter)" placeholderTextColor="#87958f" maxLength={500} multiline style={styles.feedbackInput} />
          <View style={styles.feedbackRow}>
            <Pressable disabled={feedbackBusy} style={styles.feedbackButton} onPress={() => void submitFeedback('correct')}><Text style={styles.feedbackButtonText}>Bilgi doğru</Text></Pressable>
            <Pressable disabled={feedbackBusy} style={styles.feedbackButtonBad} onPress={() => void submitFeedback('incorrect')}><Text style={styles.feedbackButtonText}>Bir hata var</Text></Pressable>
            <Pressable disabled={feedbackBusy} style={styles.feedbackButtonNeutral} onPress={() => void submitFeedback('unclear')}><Text style={styles.feedbackButtonNeutralText}>Emin değilim</Text></Pressable>
          </View>
          <Pressable disabled={feedbackBusy} onPress={() => { setShowFeedback(false); setFeedbackNote(''); }}><Text style={styles.cancelLink}>Vazgeç</Text></Pressable>
        </>}
      </View>
    </ScrollView>
  </SafeAreaView>;
}

function Info({ label, value }: { label: string; value: string }) {
  return <View style={styles.info}><Text style={styles.infoLabel}>{label}</Text><Text style={styles.infoValue}>{value}</Text></View>;
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f3f7f5' },
  content: { padding: 18, paddingBottom: 38 },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: 10 },
  back: { fontWeight: '800', color: '#087f5b', marginBottom: 14 },
  hero: { backgroundColor: '#123b32', borderRadius: 20, padding: 20, marginBottom: 2 },
  eyebrow: { color: '#a9d8c6', fontSize: 10, fontWeight: '800', letterSpacing: 1.1, marginBottom: 10 },
  title: { fontSize: 29, fontWeight: '900', color: '#fff', lineHeight: 35 },
  location: { marginTop: 7, color: '#d0e1da', fontSize: 14 },
  badge: { alignSelf: 'flex-start', backgroundColor: '#d5eee3', paddingHorizontal: 12, paddingVertical: 7, borderRadius: 16, marginTop: 14 },
  badgeText: { fontWeight: '800', color: '#125744' },
  heroNote: { marginTop: 15, color: '#e0ece7', fontSize: 12, lineHeight: 18 },
  card: { backgroundColor: '#fff', borderRadius: 16, padding: 16, marginTop: 14, borderWidth: 1, borderColor: '#dbe5e1' },
  section: { fontSize: 18, fontWeight: '800', color: '#17352e', marginBottom: 12 },
  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: 10 },
  info: { width: '47%', backgroundColor: '#f4f8f6', borderRadius: 10, padding: 11 },
  infoLabel: { fontSize: 11, color: '#71817b' },
  infoValue: { fontWeight: '800', color: '#17352e', marginTop: 4, fontSize: 13 },
  muted: { color: '#71817b', lineHeight: 19, fontSize: 13 },
  body: { color: '#4f625b', lineHeight: 20, marginTop: 10, fontSize: 13 },
  sourceName: { fontWeight: '700', color: '#315e50', marginTop: 12 },
  source: { fontSize: 11, color: '#71817b', marginTop: 8, lineHeight: 16 },
  warning: { color: '#765c20', lineHeight: 19, marginTop: 10 },
  coordinates: { fontSize: 18, fontWeight: '800', color: '#17352e', marginBottom: 8 },
  mapButton: { marginTop: 13, backgroundColor: '#dcece7', paddingVertical: 12, borderRadius: 11, alignItems: 'center' },
  mapButtonText: { fontWeight: '800', color: '#125744' },
  pendingPill: { alignSelf: 'flex-start', backgroundColor: '#f8edcf', borderRadius: 14, paddingHorizontal: 10, paddingVertical: 6, marginTop: 12 },
  pendingText: { fontSize: 12, fontWeight: '700', color: '#765c20' },
  fishRow: { paddingVertical: 11, borderBottomWidth: 1, borderBottomColor: '#edf2ef' },
  fishName: { fontSize: 16, fontWeight: '800', color: '#17352e' },
  scientific: { fontStyle: 'italic', color: '#71817b', marginTop: 2 },
  open: { color: '#087f5b', fontWeight: '800', marginTop: 7 },
  smallNote: { fontSize: 11, color: '#71817b', marginTop: 10, lineHeight: 16 },
  feedbackCard: { backgroundColor: '#fff', borderRadius: 16, padding: 16, marginTop: 14, borderWidth: 1, borderColor: '#dbe5e1' },
  feedbackHeading: { fontSize: 15, fontWeight: '800', color: '#17352e', marginBottom: 7 },
  optionalButton: { alignSelf: 'flex-start', marginTop: 13, borderWidth: 1, borderColor: '#b9d4c9', paddingHorizontal: 13, paddingVertical: 9, borderRadius: 10, backgroundColor: '#f6faf8' },
  optionalButtonText: { color: '#315e50', fontWeight: '700', fontSize: 12 },
  feedbackInput: { backgroundColor: '#f6f8f7', borderWidth: 1, borderColor: '#dbe5e1', borderRadius: 10, padding: 10, minHeight: 42, marginTop: 13, color: '#17352e' },
  feedbackRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 7, marginTop: 10 },
  feedbackButton: { backgroundColor: '#dcefe7', paddingHorizontal: 12, paddingVertical: 10, borderRadius: 10 },
  feedbackButtonBad: { backgroundColor: '#f8e2de', paddingHorizontal: 12, paddingVertical: 10, borderRadius: 10 },
  feedbackButtonNeutral: { backgroundColor: '#edf0f2', paddingHorizontal: 12, paddingVertical: 10, borderRadius: 10 },
  feedbackButtonText: { fontWeight: '800', color: '#17352e', fontSize: 12 },
  feedbackButtonNeutralText: { fontWeight: '800', color: '#4c5c58', fontSize: 12 },
  cancelLink: { color: '#71817b', marginTop: 13, fontWeight: '700' },
  link: { color: '#087f5b', fontWeight: '800', marginTop: 10 },
});