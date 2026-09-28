import { useEffect, useMemo, useState } from 'react';
import { FlatList, SafeAreaView, StyleSheet, Text, TextInput, View, Pressable } from 'react-native';
import * as Location from 'expo-location';
import { getWaterBodies } from '../src/lib/data';
import type { WaterBody } from '../src/types/database';

function distanceKm(lat1:number, lon1:number, lat2:number, lon2:number) {
  const r=6371, dLat=(lat2-lat1)*Math.PI/180, dLon=(lon2-lon1)*Math.PI/180;
  const a=Math.sin(dLat/2)**2+Math.cos(lat1*Math.PI/180)*Math.cos(lat2*Math.PI/180)*Math.sin(dLon/2)**2;
  return r*2*Math.atan2(Math.sqrt(a),Math.sqrt(1-a));
}

export default function MapScreen() {
  const [items,setItems]=useState<WaterBody[]>([]);
  const [query,setQuery]=useState('');
  const [province,setProvince]=useState('');
  const [nearest,setNearest]=useState(false);
  const [position,setPosition]=useState<{lat:number;lon:number}|null>(null);

  useEffect(()=>{
    getWaterBodies().then(r=>setItems(r.data));
    (async()=>{
      const p=await Location.requestForegroundPermissionsAsync();
      if(p.status==='granted'){
        const c=await Location.getCurrentPositionAsync({});
        setPosition({lat:c.coords.latitude,lon:c.coords.longitude});
      }
    })();
  },[]);

  const provinces=useMemo(()=>Array.from(new Set(items.map(x=>x.province).filter(Boolean))).sort(),[items]);
  const filtered=useMemo(()=>{
    const q=query.trim().toLocaleLowerCase('tr-TR');
    const result=items.filter(x=>(!q||`${x.name} ${x.province||''} ${x.district||''}`.toLocaleLowerCase('tr-TR').includes(q))&&(!province||x.province===province));
    if(nearest&&position) return [...result].sort((a,b)=>{
      const da=a.latitude!=null&&a.longitude!=null?distanceKm(position.lat,position.lon,Number(a.latitude),Number(a.longitude)):Number.POSITIVE_INFINITY;
      const db=b.latitude!=null&&b.longitude!=null?distanceKm(position.lat,position.lon,Number(b.latitude),Number(b.longitude)):Number.POSITIVE_INFINITY;
      return da-db;
    });
    return result;
  },[items,query,province,nearest,position]);

  return <SafeAreaView style={styles.container}>
    <Text style={styles.title}>Balık Noktaları</Text>
    <TextInput value={query} onChangeText={setQuery} placeholder="Göl, baraj, akarsu veya ilçe ara..." style={styles.search}/>
    <View style={styles.actions}>
      <Pressable style={[styles.button,nearest&&styles.active]} onPress={()=>setNearest(v=>!v)}><Text style={styles.buttonText}>📍 En yakınım</Text></Pressable>
      <Pressable style={styles.button} onPress={()=>setProvince('')}><Text style={styles.buttonText}>Türkiye</Text></Pressable>
    </View>
    <FlatList horizontal showsHorizontalScrollIndicator={false} data={provinces} keyExtractor={x=>x} style={styles.provinces} renderItem={({item})=><Pressable onPress={()=>setProvince(item)} style={[styles.chip,province===item&&styles.chipActive]}><Text>{item}</Text></Pressable>} />
    <View style={styles.map}><Text style={styles.mapTitle}>Türkiye Haritası</Text><Text style={styles.mapText}>Koordinatlı su kaynakları harita katmanına bağlanmaya hazır.</Text><Text style={styles.count}>{filtered.length} sonuç</Text></View>
    <FlatList data={filtered.slice(0,100)} keyExtractor={x=>x.id} renderItem={({item})=><View style={styles.row}><Text style={styles.name}>{item.name}</Text><Text style={styles.meta}>{[item.province,item.district].filter(Boolean).join(' • ')}</Text></View>} />
  </SafeAreaView>;
}
const styles=StyleSheet.create({container:{flex:1,backgroundColor:'#f6f8f7',padding:16},title:{fontSize:28,fontWeight:'800',color:'#123b32',marginTop:12},search:{backgroundColor:'#fff',borderRadius:12,padding:13,marginTop:12,borderWidth:1,borderColor:'#dbe5e1'},actions:{flexDirection:'row',gap:8,marginTop:10},button:{backgroundColor:'#fff',borderRadius:10,paddingVertical:10,paddingHorizontal:13},active:{backgroundColor:'#dcece7'},buttonText:{fontWeight:'700'},provinces:{marginTop:10,maxHeight:42},chip:{backgroundColor:'#fff',paddingHorizontal:12,paddingVertical:9,borderRadius:18,marginRight:7},chipActive:{backgroundColor:'#bfe4d7'},map:{height:190,borderRadius:18,backgroundColor:'#dcece7',marginVertical:14,alignItems:'center',justifyContent:'center',padding:24},mapTitle:{fontSize:22,fontWeight:'800',color:'#125744'},mapText:{textAlign:'center',color:'#4e6b62',marginTop:8},count:{marginTop:10,fontWeight:'800',color:'#087f5b'},row:{backgroundColor:'#fff',borderRadius:12,padding:13,marginBottom:8},name:{fontWeight:'700',fontSize:15,color:'#17352e'},meta:{fontSize:12,color:'#71817b',marginTop:3}});