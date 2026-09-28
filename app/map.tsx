import { useEffect, useMemo, useState } from 'react';
import { FlatList, SafeAreaView, StyleSheet, Text, TextInput, View, Pressable } from 'react-native';
import * as Location from 'expo-location';
import { MapPreview } from '../src/components/MapPreview';
import { getWaterBodies, sortByDistance } from '../src/lib/data';
import type { WaterBody } from '../src/types/database';

export default function MapScreen() {
  const [items, setItems] = useState<WaterBody[]>([]);
  const [query, setQuery] = useState('');
  const [province, setProvince] = useState('');
  const [nearest, setNearest] = useState(false);
  const [position, setPosition] = useState<{ latitude: number; longitude: number } | null>(null);
  const [selected, setSelected] = useState<WaterBody | null>(null);

  useEffect(() => {
    getWaterBodies().then(r => setItems(r.data));
    (async () => {
      const p = await Location.requestForegroundPermissionsAsync();
      if (p.status === 'granted') {
        const c = await Location.getCurrentPositionAsync({});
        setPosition({ latitude: c.coords.latitude, longitude: c.coords.longitude });
      }
    })();
  }, []);

  const provinces = useMemo(() => Array.from(new Set(items.map(x => x.province).filter(Boolean))).sort(), [items]);
  const filtered = useMemo(() => {
    const q = query.trim().toLocaleLowerCase('tr-TR');
    const result = items.filter(x =>
      (!q || `${x.name} ${x.province || ''} ${x.district || ''}`.toLocaleLowerCase('tr-TR').includes(q)) &&
      (!province || x.province === province)
    );
    return nearest && position ? sortByDistance(result, position.latitude, position.longitude) : result;
  }, [items, query, province, nearest, position]);

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>Balık Noktaları</Text>
      <TextInput value={query} onChangeText={setQuery} placeholder="Göl, baraj, akarsu veya ilçe ara..." style={styles.search} />
      <View style={styles.actions}>
        <Pressable style={[styles.button, nearest && styles.active]} onPress={() => setNearest(v => !v)}><Text style={styles.buttonText}>📍 En yakınım</Text></Pressable>
        <Pressable style={styles.button} onPress={() => setProvince('')}><Text style={styles.buttonText}>Türkiye</Text></Pressable>
      </View>
      <FlatList horizontal showsHorizontalScrollIndicator={false} data={provinces} keyExtractor={x => x} style={styles.provinces} renderItem={({ item }) => (
        <Pressable onPress={() => setProvince(item)} style={[styles.chip, province === item && styles.chipActive]}><Text>{item}</Text></Pressable>
      )} />
      <MapPreview items={filtered} onSelect={setSelected} />
      {selected && (
        <View style={styles.selectedCard}>
          <Text style={styles.selectedTitle}>{selected.name}</Text>
          <Text style={styles.meta}>{[selected.province, selected.district].filter(Boolean).join(' • ')}</Text>
          {selected.water_type ? <Text style={styles.meta}>{selected.water_type}</Text> : null}
          <Text style={styles.status}>{selected.fishing_allowed === false ? '⛔ Avcılık yasak' : selected.fishing_allowed === true ? '🎣 Avcılık bilgisi mevcut' : 'ℹ️ Av durumu ayrıca kontrol edilmeli'}</Text>
          <Pressable onPress={() => setSelected(null)}><Text style={styles.close}>Kapat</Text></Pressable>
        </View>
      )}
      <Text style={styles.count}>{filtered.length} sonuç</Text>
      <FlatList data={filtered.slice(0, 100)} keyExtractor={x => x.id} renderItem={({ item }) => (
        <Pressable onPress={() => setSelected(item)} style={styles.row}>
          <Text style={styles.name}>{item.name}</Text>
          <Text style={styles.meta}>{[item.province, item.district].filter(Boolean).join(' • ')}</Text>
        </Pressable>
      )} />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#f6f8f7', padding: 16 }, title: { fontSize: 28, fontWeight: '800', color: '#123b32', marginTop: 12 },
  search: { backgroundColor: '#fff', borderRadius: 12, padding: 13, marginTop: 12, borderWidth: 1, borderColor: '#dbe5e1' },
  actions: { flexDirection: 'row', gap: 8, marginTop: 10 }, button: { backgroundColor: '#fff', borderRadius: 10, paddingVertical: 10, paddingHorizontal: 13 }, active: { backgroundColor: '#dcece7' }, buttonText: { fontWeight: '700' },
  provinces: { marginTop: 10, maxHeight: 42 }, chip: { backgroundColor: '#fff', paddingHorizontal: 12, paddingVertical: 9, borderRadius: 18, marginRight: 7 }, chipActive: { backgroundColor: '#bfe4d7' },
  selectedCard: { backgroundColor: '#fff', borderRadius: 14, padding: 14, marginTop: 10, borderWidth: 1, borderColor: '#d7e4df' }, selectedTitle: { fontSize: 18, fontWeight: '800', color: '#123b32' },
  status: { marginTop: 8, fontWeight: '700', color: '#276b58' }, close: { marginTop: 10, fontWeight: '800', color: '#087f5b' }, count: { marginVertical: 8, fontWeight: '800', color: '#087f5b' },
  row: { backgroundColor: '#fff', borderRadius: 12, padding: 13, marginBottom: 8 }, name: { fontWeight: '700', fontSize: 15, color: '#17352e' }, meta: { fontSize: 12, color: '#71817b', marginTop: 3 }
});