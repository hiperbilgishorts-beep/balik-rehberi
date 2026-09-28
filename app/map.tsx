import { useEffect, useState } from 'react';
import { FlatList, SafeAreaView, StyleSheet, Text, View } from 'react-native';
import * as Location from 'expo-location';
import { getWaterBodies } from '../src/lib/data';
import type { WaterBody } from '../src/types/database';

export default function MapScreen() {
  const [items, setItems] = useState<WaterBody[]>([]);
  const [locationText, setLocationText] = useState('Konum aranıyor...');
  useEffect(() => {
    getWaterBodies().then(r => setItems(r.data));
    (async () => {
      const permission = await Location.requestForegroundPermissionsAsync();
      if (permission.status !== 'granted') { setLocationText('Konum izni verilmedi'); return; }
      const p = await Location.getCurrentPositionAsync({});
      setLocationText(`${p.coords.latitude.toFixed(4)}, ${p.coords.longitude.toFixed(4)}`);
    })();
  }, []);
  return <SafeAreaView style={styles.container}>
    <Text style={styles.title}>Balık Noktaları</Text>
    <Text style={styles.location}>Konum: {locationText}</Text>
    <View style={styles.mapPlaceholder}><Text style={styles.mapTitle}>Türkiye Haritası</Text><Text style={styles.mapText}>Koordinatlı su kaynakları burada harita katmanında gösterilecek.</Text><Text style={styles.count}>{items.length} su kaynağı yüklendi</Text></View>
    <FlatList data={items.slice(0,30)} keyExtractor={x=>x.id} renderItem={({item})=><View style={styles.row}><Text style={styles.name}>{item.name}</Text><Text style={styles.meta}>{[item.province,item.district].filter(Boolean).join(' • ')}</Text></View>} />
  </SafeAreaView>;
}
const styles=StyleSheet.create({container:{flex:1,backgroundColor:'#f6f8f7',padding:16},title:{fontSize:28,fontWeight:'800',color:'#123b32',marginTop:12},location:{color:'#64756e',marginTop:5},mapPlaceholder:{height:230,borderRadius:18,backgroundColor:'#dcece7',marginVertical:16,alignItems:'center',justifyContent:'center',padding:25},mapTitle:{fontSize:22,fontWeight:'800',color:'#125744'},mapText:{textAlign:'center',color:'#4e6b62',marginTop:8,lineHeight:20},count:{marginTop:12,fontWeight:'700',color:'#087f5b'},row:{backgroundColor:'#fff',borderRadius:12,padding:13,marginBottom:8},name:{fontWeight:'700',fontSize:15,color:'#17352e'},meta:{fontSize:12,color:'#71817b',marginTop:3}});
