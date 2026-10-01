import { useCallback, useEffect, useState } from 'react';
import { ActivityIndicator, Linking, Pressable, SafeAreaView, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { router } from 'expo-router';
import { getWaterBodies } from '../src/lib/data';
import type { WaterBody } from '../src/types/database';

const menu = [
  { icon: '⌖', title: 'Haritada keşfet', subtitle: 'Su kaynaklarını konumlarına göre incele', route: '/map', color: '#d8eee5' },
  { icon: '◉', title: 'Su kaynakları', subtitle: 'Göl, baraj, gölet ve akarsular', route: '/meralar', color: '#e1e9fb' },
  { icon: '🐟', title: 'Balık rehberi', subtitle: 'Türleri, yaşam alanlarını ve bilgileri keşfet', route: '/fish', color: '#f9e9cf' },
] as const;

export default function Home() {
  const [items, setItems] = useState<WaterBody[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(false);

  const load = useCallback(async (value = '') => {
    setLoading(true);
    const result = await getWaterBodies({ search: value });
    setItems(result.data.slice(0, 6));
    setLoading(false);
  }, []);

  useEffect(() => { void load(); }, [load]);

  return <SafeAreaView style={styles.container}>
    <ScrollView contentContainerStyle={styles.content} keyboardShouldPersistTaps="handled">
      <View style={styles.hero}>
        <View style={styles.brandRow}><View style={styles.logo}><Text style={styles.logoText}>B</Text></View><Text style={styles.brand}>BALIK REHBERİ</Text><View style={styles.countryPill}><Text style={styles.countryText}>TÜRKİYE</Text></View></View>
        <Text style={styles.title}>Yeni rotanı keşfet.</Text>
        <Text style={styles.subtitle}>Sana uygun su kaynaklarını bul, balık türlerini tanı ve keşfe hazırlan.</Text>
        <Pressable style={styles.heroButton} onPress={() => router.push('/map')}><Text style={styles.heroButtonText}>Keşfe başla  →</Text></Pressable>
        <View style={styles.waveOne}/><View style={styles.waveTwo}/>
      </View>

      <View style={styles.sectionHeading}><Text style={styles.sectionTitle}>Nereye gitmek istersin?</Text><Text style={styles.sectionCaption}>Bir alan seçerek devam et</Text></View>
      {menu.map(item => <Pressable key={item.route} style={styles.menuCard} onPress={() => router.push(item.route)}><View style={[styles.menuIcon,{backgroundColor:item.color}]}><Text style={styles.menuIconText}>{item.icon}</Text></View><View style={styles.menuCopy}><Text style={styles.menuTitle}>{item.title}</Text><Text style={styles.menuSubtitle}>{item.subtitle}</Text></View><Text style={styles.chevron}>›</Text></Pressable>)}

      <View style={styles.sectionHeading}><Text style={styles.sectionTitle}>Hızlı su kaynağı arama</Text></View>
      <View style={styles.searchBox}><Text style={styles.searchIcon}>⌕</Text><TextInput value={search} onChangeText={v => { setSearch(v); void load(v); }} onSubmitEditing={() => router.push({pathname:'/map',params:{search}})} returnKeyType="search" placeholder="Örn. Konya, Beyşehir Gölü..." placeholderTextColor="#83928c" style={styles.input}/><Pressable onPress={() => router.push({pathname:'/map',params:{search}})}><Text style={styles.searchAction}>Ara</Text></Pressable></View>
      {search.trim().length > 0 ? <View style={styles.results}>{loading ? <ActivityIndicator color="#087f5b"/> : items.map(item => <Pressable key={item.id} style={styles.resultRow} onPress={() => router.push({pathname:'/water-body/[id]',params:{id:item.id}})}><View style={styles.resultDot}/><View style={{flex:1}}><Text style={styles.resultName}>{item.name}</Text><Text style={styles.resultMeta}>{[item.province,item.water_type].filter(Boolean).join(' · ')}</Text></View><Text style={styles.chevron}>›</Text></Pressable>)}</View> : <View style={styles.tip}><Text style={styles.tipIcon}>✦</Text><View style={{flex:1}}><Text style={styles.tipTitle}>Keşif için küçük bir ipucu</Text><Text style={styles.tipText}>İl ve balık türü filtrelerini kullanarak aramanı daraltabilirsin.</Text></View></View>}

      <Pressable style={styles.privacy} onPress={() => void Linking.openURL('https://github.com/hiperbilgishorts-beep/balik-rehberi/blob/main/PRIVACY_POLICY.md')}><Text style={styles.privacyText}>Gizlilik politikası</Text></Pressable>
    </ScrollView>
  </SafeAreaView>;
}

const styles=StyleSheet.create({
 container:{flex:1,backgroundColor:'#f5f8f6'},content:{padding:18,paddingBottom:30},
 hero:{backgroundColor:'#103d33',borderRadius:26,padding:22,paddingTop:20,minHeight:248,overflow:'hidden',position:'relative'},
 brandRow:{flexDirection:'row',alignItems:'center',gap:9},logo:{width:30,height:30,borderRadius:10,backgroundColor:'#c5e8d9',alignItems:'center',justifyContent:'center'},logoText:{fontSize:18,fontWeight:'900',color:'#103d33'},brand:{fontSize:11,fontWeight:'900',letterSpacing:1.5,color:'#e7f6ef'},countryPill:{marginLeft:'auto',backgroundColor:'#235849',paddingHorizontal:9,paddingVertical:5,borderRadius:12},countryText:{fontSize:9,fontWeight:'800',color:'#d4f0e4',letterSpacing:1},
 title:{fontSize:31,fontWeight:'900',color:'#fff',marginTop:25,letterSpacing:-.7},subtitle:{fontSize:14,lineHeight:21,color:'#d4e7df',marginTop:7,maxWidth:290},heroButton:{alignSelf:'flex-start',backgroundColor:'#d0f0df',borderRadius:13,paddingHorizontal:16,paddingVertical:12,marginTop:17,zIndex:2},heroButtonText:{color:'#124b3a',fontWeight:'900'},waveOne:{position:'absolute',width:190,height:190,borderRadius:95,borderWidth:24,borderColor:'rgba(190,232,214,0.09)',right:-68,bottom:-100},waveTwo:{position:'absolute',width:130,height:130,borderRadius:65,backgroundColor:'rgba(190,232,214,0.07)',right:24,bottom:-75},
 sectionHeading:{marginTop:24,marginBottom:12},sectionTitle:{fontSize:18,fontWeight:'900',color:'#183c32'},sectionCaption:{fontSize:12,color:'#7a8b83',marginTop:3},
 menuCard:{backgroundColor:'#fff',borderRadius:17,padding:14,marginBottom:10,flexDirection:'row',alignItems:'center',borderWidth:1,borderColor:'#e5ece8',gap:13},menuIcon:{width:48,height:48,borderRadius:15,alignItems:'center',justifyContent:'center'},menuIconText:{fontSize:24,color:'#1b5643'},menuCopy:{flex:1},menuTitle:{fontSize:15,fontWeight:'900',color:'#1c3b32'},menuSubtitle:{fontSize:12,color:'#71827a',marginTop:4,lineHeight:17},chevron:{fontSize:28,color:'#9ba9a2'},
 searchBox:{backgroundColor:'#fff',borderRadius:14,borderWidth:1,borderColor:'#dfe8e3',flexDirection:'row',alignItems:'center',paddingHorizontal:12},searchIcon:{fontSize:24,color:'#648277',marginRight:8},input:{flex:1,paddingVertical:14,fontSize:14,color:'#173d32'},searchAction:{fontWeight:'900',color:'#087f5b',paddingHorizontal:8},results:{backgroundColor:'#fff',borderRadius:14,marginTop:8,paddingHorizontal:12,borderWidth:1,borderColor:'#e5ece8'},resultRow:{flexDirection:'row',alignItems:'center',gap:10,paddingVertical:12,borderBottomWidth:1,borderBottomColor:'#eef2ef'},resultDot:{width:8,height:8,borderRadius:4,backgroundColor:'#16835f'},resultName:{fontWeight:'800',color:'#173d32'},resultMeta:{fontSize:11,color:'#74847d',marginTop:3},
 tip:{flexDirection:'row',gap:11,alignItems:'center',backgroundColor:'#e8f2ed',borderRadius:15,padding:14,marginTop:14},tipIcon:{fontSize:21,color:'#087f5b'},tipTitle:{fontWeight:'800',color:'#235443',fontSize:13},tipText:{fontSize:12,color:'#60786d',marginTop:3,lineHeight:17},privacy:{alignSelf:'center',padding:18},privacyText:{fontSize:12,color:'#7b8c84',textDecorationLine:'underline'}
});