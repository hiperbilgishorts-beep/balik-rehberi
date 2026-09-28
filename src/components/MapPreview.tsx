import { StyleSheet, Text, View } from 'react-native';
import MapView, { Marker, PROVIDER_DEFAULT, Region } from 'react-native-maps';
import type { WaterBody } from '../types/database';
import { isValidCoordinate } from '../lib/geo';

type Props = {
  items: WaterBody[];
  initialRegion?: Region;
  onSelect?: (item: WaterBody) => void;
};

export function MapPreview({ items, initialRegion, onSelect }: Props) {
  const validItems = items.filter(item => isValidCoordinate(item.latitude, item.longitude));
  const fallback: Region = { latitude: 39.0, longitude: 35.0, latitudeDelta: 8.5, longitudeDelta: 11.5 };

  return (
    <View style={styles.container}>
      <MapView style={StyleSheet.absoluteFill} provider={PROVIDER_DEFAULT} initialRegion={initialRegion ?? fallback}>
        {validItems.map(item => (
          <Marker
            key={item.id}
            coordinate={{ latitude: Number(item.latitude), longitude: Number(item.longitude) }}
            title={item.name}
            description={[item.province, item.district].filter(Boolean).join(' • ')}
            onPress={() => onSelect?.(item)}
          />
        ))}
      </MapView>
      {validItems.length === 0 && (
        <View style={styles.empty} pointerEvents="none">
          <Text style={styles.emptyText}>Koordinatı doğrulanmış su kaynağı bulunamadı.</Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { height: 260, borderRadius: 18, overflow: 'hidden', backgroundColor: '#dcece7' },
  empty: { position: 'absolute', left: 20, right: 20, bottom: 18, padding: 10, borderRadius: 10, backgroundColor: 'rgba(255,255,255,0.92)' },
  emptyText: { textAlign: 'center', color: '#31544b', fontWeight: '600' },
});
