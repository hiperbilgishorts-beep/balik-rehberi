import { useEffect, useState } from 'react';
import { FlatList, Pressable, SafeAreaView, StyleSheet, Text, TextInput } from 'react-native';
import { useRouter } from 'expo-router';
import { getFish } from '../src/lib/data';
import type { Fish } from '../src/types/database';

export default function FishScreen() {
  const router = useRouter();
  const [items, setItems] = useState<Fish[]>([]);
  const [search, setSearch] = useState('');
  useEffect(() => { getFish().then(r => setItems(r.data)); }, []);
  const filtered = items.filter(x => `${x.common_name_tr} ${x.scientific_name ?? ''}`.toLocaleLowerCase('tr-TR').includes(search.toLocaleLowerCase('tr-TR')));
  return <SafeAreaView style={styles.container}>
    <Text style={styles.title}>Balık Rehberi</Text><Text style={styles.subtitle}>Tür, yaşam alanı ve av bilgilerini keşfet.</Text>
    <TextInput value={search} onChangeText={setSearch} placeholder="Balık ara..." style={styles.input} />
    <FlatList data={filtered} keyExtractor={x=>x.id} contentContainerStyle={{paddingTop:14,paddingBottom:30}}
      ListEmptyComponent={<Text style={styles.empty}>Henüz eşleşen balık verisi yok.</Text>}
      renderItem={({item})=><Pressable onPress={() => router.push(`/fish/${item.id}`)} style={styles.card}>
        <Text style={styles.name}>{item.common_name_tr}</Text><Text style={styles.scientific}>{item.scientific_name ?? 'Bilimsel adı eklenmemiş'}</Text>
        {item.description ? <Text numberOfLines={2} style={styles.body}>{item.description}</Text> : null}{item.habitat ? <Text style={styles.meta}>Habitat: {item.habitat}</Text> : null}
        <Text style={styles.open}>Detayları görüntüle ›</Text>
      </Pressable>}/>
  </SafeAreaView>;
}
const styles=StyleSheet.create({container:{flex:1,backgroundColor:'#f6f8f7',padding:16},title:{fontSize:28,fontWeight:'800',color:'#123b32',marginTop:12},subtitle:{color:'#61706b',marginTop:4,marginBottom:16},input:{backgroundColor:'#fff',borderWidth:1,borderColor:'#dce5e1',borderRadius:12,padding:12},card:{backgroundColor:'#fff',borderRadius:14,padding:15,marginBottom:10,borderWidth:1,borderColor:'#e5ebe8'},name:{fontSize:18,fontWeight:'800',color:'#17352e'},scientific:{fontStyle:'italic',color:'#71817b',marginTop:3},body:{color:'#4f625b',lineHeight:20,marginTop:10},meta:{color:'#0a7455',fontWeight:'600',marginTop:10},open:{color:'#087f5b',fontWeight:'800',marginTop:12},empty:{textAlign:'center',padding:30,color:'#687771'}});
