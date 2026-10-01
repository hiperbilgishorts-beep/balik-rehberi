import { useCallback, useEffect, useState } from 'react';
import { ActivityIndicator, FlatList, Linking, Pressable, SafeAreaView, StyleSheet, Text, TextInput, View } from 'react-native';
import { router } from 'expo-router';
import { getWaterBodies } from '../src/lib/data';
import type { WaterBody } from '../src/types/database';

export default function Home() {
  const [items, setItems] = useState<WaterBody[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async (value = '') => {
    setLoading(true); setError(null);
    const result = await getWaterBodies({ search: value });
    if (result.error) setError('Su kaynakları yüklenemedi. Bağlantıyı kontrol edip tekrar deneyebilirsin.');
    setItems(result.data);
    setLoading(false);
  }, []);

  useEffect(() => { load(); }, [load]);

  return <SafeAreaView style={styles.container}>
    <View style={styles.header}><Text style={styles.title}>Balık Rehberi Türkiye</Text><Text style={styles.subtitle}>Su kaynaklarını ve genel mera bölgelerini keşfet</Text></View>
    <View style={styles.actions}>
      <Pressable style={styles.primary} onPress={() => router.push('/map')}><Text style={styles.primaryText}>Haritayı Aç</Text></Pressable>
      <Pressable style={styles.secondary} onPress={() => router.push('/meralar')}><Text style={styles.secondaryText}>Meralar & Göletler</Text></Pressable>
      <Pressable style={styles.secondary} onPress={() => router.push('/fish')}><Text style={styles.secondaryText}>Balık Rehberi</Text></Pressable>
    </View>
    <Pressable style={styles.privacyLink} onPress={() => void Linking.openURL('https://github.com/hiperbilgishorts-beep/balik-rehberi/blob/main/PRIVACY_POLICY.md')} accessibilityRole="link"><Text style={styles.privacyText}>Gizlilik Politikası</Text></Pressable>
    <TextInput value={search} onChangeText={v => { setSearch(v); load(v); }} placeholder="Göl, baraj, akarsu ara..." placeholderTextColor="#7b8794" style={styles.input} />
    {loading ? <ActivityIndicator size="large" style={{ marginTop: 30 }} /> : error ? <View style={styles.state}><Text style={styles.error}>{error}</Text><Pressable style={styles.retry} onPress={() => load(search)}><Text style={styles.retryText}>Tekrar dene</Text></Pressable></View> : <FlatList data={items.slice(0, 50)} keyExtractor={x => x.id} contentContainerStyle={{ paddingBottom: 30 }} ListHeaderComponent={<Text style={styles.section}>Su kaynakları</Text>} renderItem={({ item }) => <Pressable style={styles.card} onPress={() => router.push({ pathname: '/water-body/[id]', params: { id: item.id } })}><View style={styles.cardDot} /><View style={{ flex: 1 }}><Text style={styles.cardTitle}>{item.name}</Text><Text style={styles.cardMeta}>{[item.province, item.water_type].filter(Boolean).join(' • ')}</Text></View><Text style={styles.chevron}>›</Text></Pressable>} ListEmptyComponent={<Text style={styles.empty}>Bu aramaya uygun su kaynağı bulunamadı.</Text>} />}
  </SafeAreaView>;
}
const styles=StyleSheet.create({container:{flex:1,backgroundColor:'#f6f8f7',paddingHorizontal:16},header:{paddingTop:20,paddingBottom:16},title:{fontSize:27,fontWeight:'800',color:'#123b32'},subtitle:{fontSize:14,color:'#61706b',marginTop:4},privacyLink:{alignSelf:'flex-start',marginTop:-4,marginBottom:10},privacyText:{fontSize:12,color:'#58736a',textDecorationLine:'underline'},actions:{flexDirection:'row',flexWrap:'wrap',gap:10,marginBottom:14},primary:{backgroundColor:'#087f5b',paddingHorizontal:18,paddingVertical:12,borderRadius:12},primaryText:{color:'#fff',fontWeight:'700'},secondary:{backgroundColor:'#e2eee9',paddingHorizontal:18,paddingVertical:12,borderRadius:12},secondaryText:{color:'#075c46',fontWeight:'700'},input:{backgroundColor:'#fff',borderWidth:1,borderColor:'#dce5e1',borderRadius:12,paddingHorizontal:14,paddingVertical:12,fontSize:15},section:{fontSize:17,fontWeight:'800',color:'#20352f',marginTop:22,marginBottom:10},card:{backgroundColor:'#fff',borderRadius:14,padding:14,marginBottom:9,flexDirection:'row',alignItems:'center',borderWidth:1,borderColor:'#e7ecea'},cardDot:{width:10,height:10,borderRadius:5,backgroundColor:'#0b8f68',marginRight:12},cardTitle:{fontSize:16,fontWeight:'700',color:'#17352e'},cardMeta:{fontSize:12,color:'#70817b',marginTop:4},chevron:{fontSize:28,color:'#9aa7a2'},state:{alignItems:'center',padding:30},error:{textAlign:'center',color:'#8a4a42',lineHeight:20},retry:{marginTop:12,backgroundColor:'#087f5b',paddingHorizontal:18,paddingVertical:10,borderRadius:10},retryText:{color:'#fff',fontWeight:'800'},empty:{textAlign:'center',color:'#687771',padding:30}});