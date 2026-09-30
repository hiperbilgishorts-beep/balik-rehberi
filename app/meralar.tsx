import { useCallback, useEffect, useState } from 'react';
import { ActivityIndicator, FlatList, Pressable, SafeAreaView, StyleSheet, Text, TextInput, View } from 'react-native';
import { router } from 'expo-router';
import { getFishingAreas, getWaterBodies } from '../src/lib/data';
import type { FishingArea, WaterBody } from '../src/types/database';

type Filter = 'all' | 'reservoir' | 'natural_lake' | 'pond';

function coordinateLabel(grade: string | null | undefined, hasCoords: boolean) { if (!hasCoords || !grade || grade === 'F') return 'Kontrol ediniz · koordinat yok'; if (grade === 'A') return '✓ Güvenilir konum · A'; if (grade === 'B') return 'Güvenilir genel konum · B'; if (grade === 'C') return 'Konum kontrolü önerilir · C'; return 'Kontrol ediniz · ' + grade; }

const filters: { key: Filter; label: string }[] = [
  { key: 'all', label: 'Tümü' },
  { key: 'reservoir', label: 'Barajlar' },
  { key: 'natural_lake', label: 'Göller' },
  { key: 'pond', label: 'Göletler' },
];

export default function MeralarScreen() {
  const [items, setItems] = useState<WaterBody[]>([]);
  const [areas, setAreas] = useState<FishingArea[]>([]);
  const [showAtlas, setShowAtlas] = useState(false);
  const [search, setSearch] = useState('');
  const [filter, setFilter] = useState<Filter>('all');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async (query = '') => {
    setLoading(true);
    setError(null);
    const [result, areaResult] = await Promise.all([getWaterBodies({ search: query }), getFishingAreas(query)]);
    if (result.error || areaResult.error) setError('Katalog yüklenirken bir sorun oluştu. Bağlantını kontrol edip tekrar dene.');
    setItems(result.data);
    setAreas(areaResult.data);
    setLoading(false);
  }, []);

  useEffect(() => { void load(''); }, [load]);

  const filtered = items.filter(item => filter === 'all' || item.water_type === filter);

  return <SafeAreaView style={styles.container}>
    <View style={styles.header}>
      <Pressable onPress={() => router.back()}><Text style={styles.back}>‹ Geri</Text></Pressable>
      <Text style={styles.title}>Meralar & Su Kaynakları</Text>
      <Text style={styles.subtitle}>Baraj, göl ve göletlerin genel konumlarını keşfet. Harita işaretleri kesin balık tutma noktası veya kıyıya erişim izni anlamına gelmez.</Text>
    </View>
    <TextInput value={search} onChangeText={v => { setSearch(v); void load(v); }} placeholder="Mera, su kaynağı veya il ara..." placeholderTextColor="#7b8794" style={styles.input} />
    <View style={styles.filters}><Pressable onPress={() => setShowAtlas(false)} style={[styles.filter, !showAtlas && styles.filterActive]}><Text style={[styles.filterText, !showAtlas && styles.filterTextActive]}>Su kaynakları</Text></Pressable><Pressable onPress={() => setShowAtlas(true)} style={[styles.filter, showAtlas && styles.filterActive]}><Text style={[styles.filterText, showAtlas && styles.filterTextActive]}>Olta Atlası meraları</Text></Pressable></View>
    {!showAtlas && <View style={styles.filters}>{filters.map(item => <Pressable key={item.key} onPress={() => setFilter(item.key)} style={[styles.filter, filter === item.key && styles.filterActive]}><Text style={[styles.filterText, filter === item.key && styles.filterTextActive]}>{item.label}</Text></Pressable>)}</View>}
    {!showAtlas && <Pressable style={styles.mapButton} onPress={() => router.push('/map')}><Text style={styles.mapButtonText}>Haritada keşfet ↗</Text></Pressable>}
    {loading ? <ActivityIndicator size="large" style={{ marginTop: 28 }} /> : error ? <View style={styles.state}><Text style={styles.error}>{error}</Text><Pressable onPress={() => load(search)} style={styles.retry}><Text style={styles.retryText}>Tekrar dene</Text></Pressable></View> : showAtlas ? <FlatList data={areas} keyExtractor={item => item.id} contentContainerStyle={{ paddingBottom: 24 }} ListHeaderComponent={<Text style={styles.count}>{areas.length} mera kaydı · kaynak güven seviyesi korunur</Text>} renderItem={({ item }) => <View style={styles.card}><View style={[styles.pin,{backgroundColor:'#e4edf9'}]}><Text style={[styles.pinText,{color:'#315d91'}]}>{item.source_grade}</Text></View><View style={{ flex: 1 }}><Text style={styles.cardTitle}>{item.name}</Text><Text style={styles.meta}>{[item.province_name,item.district_name,item.water_type].filter(Boolean).join(' • ')}</Text><Text style={styles.coord}>Kaynak güveni: {item.source_grade} · Koordinat aktarılmadı</Text><Text style={styles.source}>{item.general_note}</Text><Pressable onPress={() => Linking.openURL(item.source_url)}><Text style={styles.link}>Kaynak sayfasını aç ↗</Text></Pressable></View></View>} ListEmptyComponent={<Text style={styles.empty}>Bu aramada mera bulunamadı.</Text>} /> : <FlatList data={filtered} keyExtractor={item => item.id} contentContainerStyle={{ paddingBottom: 24 }} ListHeaderComponent={<Text style={styles.count}>{filtered.length} su kaynağı · koordinat güveni ayrı gösterilir</Text>} renderItem={({ item }) => <Pressable style={styles.card} onPress={() => router.push({ pathname: '/water-body/[id]', params: { id: item.id } })}><View style={styles.pin}><Text style={styles.pinText}>{item.water_type === 'reservoir' ? 'B' : 'G'}</Text></View><View style={{ flex: 1 }}><Text style={styles.cardTitle}>{item.name}</Text><Text style={styles.meta}>{[item.province, item.district, item.water_type === 'reservoir' ? 'Baraj' : item.water_type === 'natural_lake' ? 'Göl' : 'Gölet'].filter(Boolean).join(' • ')}</Text><Text style={[styles.coord, (item.coordinate_confidence_grade === 'A' || item.coordinate_confidence_grade === 'B') ? null : {color:'#986b22'}]}>{coordinateLabel(item.coordinate_confidence_grade, item.latitude != null && item.longitude != null)}</Text><Text style={styles.source}>{[item.source_name, item.verification_status === 'pending' ? 'İnceleme bekliyor' : item.verification_status === 'verified' ? 'Kayıt doğrulanmış' : null].filter(Boolean).join(' • ') || 'Kaynak bilgisi bekliyor'}</Text></View><Text style={styles.chevron}>›</Text></Pressable>} ListEmptyComponent={<Text style={styles.empty}>Bu filtrede su kaynağı bulunamadı.</Text>} />}
  </SafeAreaView>;
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f6f8f7', paddingHorizontal: 16 },
  header: { paddingTop: 12, paddingBottom: 14 },
  back: { color: '#087f5b', fontSize: 16, fontWeight: '700', marginBottom: 14 },
  title: { fontSize: 25, fontWeight: '800', color: '#123b32' },
  subtitle: { fontSize: 13, color: '#61706b', lineHeight: 19, marginTop: 7 },
  input: { backgroundColor: '#fff', borderWidth: 1, borderColor: '#dce5e1', borderRadius: 12, paddingHorizontal: 14, paddingVertical: 12, fontSize: 15 },
  filters: { flexDirection: 'row', flexWrap: 'wrap', gap: 8, marginTop: 12 },
  filter: { borderRadius: 20, paddingHorizontal: 13, paddingVertical: 8, backgroundColor: '#e7eeeb' },
  filterActive: { backgroundColor: '#087f5b' },
  filterText: { fontSize: 12, fontWeight: '700', color: '#47645a' },
  filterTextActive: { color: '#fff' },
  mapButton: { marginTop: 12, marginBottom: 4, backgroundColor: '#dcefe7', borderRadius: 12, padding: 12, alignItems: 'center' },
  mapButtonText: { color: '#075c46', fontWeight: '800' },
  count: { marginTop: 16, marginBottom: 10, color: '#60736b', fontSize: 13, fontWeight: '700' },
  card: { backgroundColor: '#fff', borderRadius: 14, padding: 13, marginBottom: 9, flexDirection: 'row', alignItems: 'center', borderWidth: 1, borderColor: '#e7ecea' },
  pin: { width: 36, height: 36, borderRadius: 12, backgroundColor: '#e2eee9', alignItems: 'center', justifyContent: 'center', marginRight: 11 },
  pinText: { color: '#087f5b', fontWeight: '900' },
  cardTitle: { fontSize: 15, fontWeight: '700', color: '#17352e' },
  meta: { fontSize: 12, color: '#70817b', marginTop: 4 },
  coord: { fontSize: 11, color: '#087f5b', marginTop: 4 },
  source: { fontSize: 10, color: '#75857f', marginTop: 4 },
  chevron: { fontSize: 26, color: '#9aa7a2', marginLeft: 8 },
  state: { alignItems: 'center', padding: 30 },
  error: { textAlign: 'center', color: '#8a4a42', lineHeight: 20 },
  retry: { marginTop: 12, backgroundColor: '#087f5b', paddingHorizontal: 18, paddingVertical: 10, borderRadius: 10 },
  retryText: { color: '#fff', fontWeight: '800' },
  empty: { textAlign: 'center', color: '#687771', padding: 30 },
});