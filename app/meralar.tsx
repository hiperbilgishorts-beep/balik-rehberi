import { useCallback, useEffect, useState } from 'react';
import { ActivityIndicator, FlatList, Linking, Pressable, SafeAreaView, StyleSheet, Text, TextInput, View } from 'react-native';
import { router } from 'expo-router';
import { getFishingAreas, getWaterBodies } from '../src/lib/data';
import type { FishingArea, WaterBody } from '../src/types/database';

type Filter = 'all' | 'reservoir' | 'natural_lake' | 'pond' | 'river';

const filters: { key: Filter; label: string }[] = [
  { key: 'all', label: 'Tümü' },
  { key: 'reservoir', label: 'Barajlar' },
  { key: 'natural_lake', label: 'Göller' },
  { key: 'pond', label: 'Göletler' },
  { key: 'river', label: 'Akarsular' },
];

export default function MeralarScreen() {
  const [items, setItems] = useState<WaterBody[]>([]);
  const [areas, setAreas] = useState<FishingArea[]>([]);
  const [showAtlas, setShowAtlas] = useState(false);
  const [areaType, setAreaType] = useState('');
  const [search, setSearch] = useState('');
  const [filter, setFilter] = useState<Filter>('all');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    const [result, areaResult] = await Promise.all([getWaterBodies(), getFishingAreas()]);
    if (result.error || areaResult.error) setError('Katalog yüklenirken bir sorun oluştu. Bağlantını kontrol edip tekrar dene.');
    setItems(result.data);
    setAreas(areaResult.data);
    setLoading(false);
  }, []);

  useEffect(() => { void load(); }, [load]);

  const q = search.trim().toLocaleLowerCase('tr-TR');
  const searchedItems = items.filter(item => !q || [item.name, item.province, item.basin_name]
    .filter(Boolean).some(value => String(value).toLocaleLowerCase('tr-TR').includes(q)));
  const filtered = searchedItems.filter(item => filter === 'all' || (filter === 'river' ? ['river', 'stream', 'watercourse'].includes(item.water_type ?? '') : item.water_type === filter));
  const areaTypes = Array.from(new Set(areas.map(item => item.water_type).filter((value): value is string => Boolean(value))) )
    .sort((a, b) => a.localeCompare(b, 'tr-TR'));
  const filteredAreas = areas.filter(item => (!q || [item.name, item.province_name, item.zone_name, item.water_type]
    .filter(Boolean).some(value => String(value).toLocaleLowerCase('tr-TR').includes(q))) && (!areaType || item.water_type === areaType));

  return <SafeAreaView style={styles.container}>
    <View style={styles.header}>
      <Text style={styles.title}>Meralar & Su Kaynakları</Text>
      <Text style={styles.subtitle}>Baraj, göl ve göletlerin genel konumlarını keşfet. Harita işaretleri kesin balık tutma noktası veya kıyıya erişim izni anlamına gelmez.</Text>
    </View>
    <TextInput value={search} onChangeText={setSearch} placeholder="Mera, su kaynağı veya il ara..." placeholderTextColor="#7b8794" style={styles.input} />
    <View style={styles.filters}><Pressable onPress={() => setShowAtlas(false)} style={[styles.filter, !showAtlas && styles.filterActive]}><Text style={[styles.filterText, !showAtlas && styles.filterTextActive]}>Su kaynakları</Text></Pressable><Pressable onPress={() => setShowAtlas(true)} style={[styles.filter, showAtlas && styles.filterActive]}><Text style={[styles.filterText, showAtlas && styles.filterTextActive]}>Olta Atlası meraları</Text></Pressable></View>
    {!showAtlas && <View style={styles.filters}>{filters.map(item => <Pressable key={item.key} onPress={() => setFilter(item.key)} style={[styles.filter, filter === item.key && styles.filterActive]}><Text style={[styles.filterText, filter === item.key && styles.filterTextActive]}>{item.label}</Text></Pressable>)}</View>}
    {showAtlas && <View style={styles.filters}><Pressable onPress={() => setAreaType('')} style={[styles.filter, !areaType && styles.filterActive]}><Text style={[styles.filterText, !areaType && styles.filterTextActive]}>Tüm türler</Text></Pressable>{areaTypes.map(type => <Pressable key={type} onPress={() => setAreaType(areaType === type ? '' : type)} style={[styles.filter, areaType === type && styles.filterActive]}><Text style={[styles.filterText, areaType === type && styles.filterTextActive]}>{type}</Text></Pressable>)}</View>}
    {!showAtlas && <Pressable style={styles.mapButton} onPress={() => router.push('/map')}><Text style={styles.mapButtonText}>Haritada keşfet ↗</Text></Pressable>}
    {loading ? <ActivityIndicator size="large" style={{ marginTop: 28 }} /> : error ? <View style={styles.state}><Text style={styles.error}>{error}</Text><Pressable onPress={() => load()} style={styles.retry}><Text style={styles.retryText}>Tekrar dene</Text></Pressable></View> : showAtlas ? <FlatList data={filteredAreas} keyExtractor={item => item.id} contentContainerStyle={{ paddingBottom: 24 }} ListHeaderComponent={<Text style={styles.count}>{filteredAreas.length} mera kaydı</Text>} renderItem={({ item }) => <View style={styles.card}><View style={[styles.pin,{backgroundColor:'#e4edf9'}]}><Text style={[styles.pinText,{color:'#315d91'}]}>M</Text></View><View style={{ flex: 1 }}><Text style={styles.cardTitle}>{item.name}</Text><Text style={styles.meta}>{[item.province_name,item.water_type].filter(Boolean).join(' • ')}</Text>{item.general_note ? <Text style={styles.source}>{item.general_note}</Text> : null}{item.latitude != null && item.longitude != null ? <Pressable onPress={() => Linking.openURL('https://www.google.com/maps/search/?api=1&query=' + item.latitude + ',' + item.longitude)}><Text style={styles.link}>Genel konumu haritada aç ↗</Text></Pressable> : null}<Pressable onPress={() => Linking.openURL(item.source_url)}><Text style={styles.link}>Kaynak sayfasını aç ↗</Text></Pressable></View></View>} ListEmptyComponent={<Text style={styles.empty}>Bu aramada mera bulunamadı.</Text>} /> : <FlatList data={filtered} keyExtractor={item => item.id} contentContainerStyle={{ paddingBottom: 24 }} ListHeaderComponent={<Text style={styles.count}>{filtered.length} su kaynağı</Text>} renderItem={({ item }) => <Pressable style={styles.card} onPress={() => router.push({ pathname: '/water-body/[id]', params: { id: item.id } })}><View style={styles.pin}><Text style={styles.pinText}>{item.water_type === 'river' || item.water_type === 'stream' || item.water_type === 'watercourse' ? 'A' : item.water_type === 'reservoir' ? 'B' : 'G'}</Text></View><View style={{ flex: 1 }}><Text style={styles.cardTitle}>{item.name}</Text><Text style={styles.meta}>{[item.province, item.water_type === 'reservoir' ? 'Baraj' : item.water_type === 'natural_lake' ? 'Göl' : 'Gölet'].filter(Boolean).join(' • ')}</Text></View><Text style={styles.chevron}>›</Text></Pressable>} ListEmptyComponent={<Text style={styles.empty}>Bu filtrede su kaynağı bulunamadı.</Text>} />}
    <View style={styles.bottomBar}><Pressable onPress={() => router.back()} style={styles.bottomBack}><Text style={styles.bottomBackText}>‹  Geri</Text></Pressable><Text style={styles.bottomHint}>Balık Rehberi</Text></View>
  </SafeAreaView>;
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f6f8f7', paddingHorizontal: 16 },
  header: { paddingTop: 12, paddingBottom: 14 },
  back: { color: '#087f5b', fontSize: 16, fontWeight: '700', marginBottom: 14 },
  bottomBar: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingHorizontal: 18, paddingVertical: 10, backgroundColor: '#fff', borderTopWidth: 1, borderTopColor: '#dbe5e1' },
  bottomBack: { backgroundColor: '#e2eee9', borderRadius: 11, paddingHorizontal: 15, paddingVertical: 9 },
  bottomBackText: { color: '#125744', fontWeight: '900', fontSize: 14 },
  bottomHint: { color: '#84928b', fontSize: 11 },
  title: { fontSize: 25, fontWeight: '800', color: '#123b32' },
  subtitle: { fontSize: 13, color: '#61706b', lineHeight: 19, marginTop: 7 },
  input: { backgroundColor: '#fff', borderWidth: 1, borderColor: '#dce5e1', borderRadius: 12, paddingHorizontal: 14, paddingVertical: 12, fontSize: 15 },
  summary: { backgroundColor: '#ffffff', borderRadius: 14, padding: 13, marginBottom: 12, borderWidth: 1, borderColor: '#dce8e2' },
  summaryTop: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' },
  summaryTitle: { color: '#17352e', fontSize: 13, fontWeight: '800' },
  summaryPercent: { color: '#087f5b', fontSize: 16, fontWeight: '900' },
  progressTrack: { height: 7, borderRadius: 8, backgroundColor: '#e7eeeb', marginTop: 9, overflow: 'hidden' },
  progressFill: { height: 7, borderRadius: 8, backgroundColor: '#087f5b' },
  summaryNote: { color: '#71817b', fontSize: 11, lineHeight: 16, marginTop: 8 },
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
  link: { fontSize: 12, color: '#087f5b', fontWeight: '700', marginTop: 8 },
  chevron: { fontSize: 26, color: '#9aa7a2', marginLeft: 8 },
  state: { alignItems: 'center', padding: 30 },
  error: { textAlign: 'center', color: '#8a4a42', lineHeight: 20 },
  retry: { marginTop: 12, backgroundColor: '#087f5b', paddingHorizontal: 18, paddingVertical: 10, borderRadius: 10 },
  retryText: { color: '#fff', fontWeight: '800' },
  empty: { textAlign: 'center', color: '#687771', padding: 30 },
});