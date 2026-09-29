import { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, Linking, Platform, Pressable, SafeAreaView, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { getWaterBodyDetail } from '../../src/lib/data';
import type { WaterBodyDetail } from '../../src/types/database';

export default function WaterBodyDetailScreen(){
 const {id}=useLocalSearchParams<{id:string}>();const router=useRouter();const[detail,setDetail]=useState<WaterBodyDetail|null>(null);const[loading,setLoading]=useState(true);const[error,setError]=useState<string|null>(null);
 useEffect(()=>{if(!id){setLoading(false);setError('Su kaynağı kimliği bulunamadı.');return}getWaterBodyDetail(id).then(r=>{setDetail(r.data);setError(r.error?.message??null);setLoading(false)})},[id]);
 if(loading)return <SafeAreaView style={styles.center}><ActivityIndicator/><Text style={styles.muted}>Su kaynağı bilgileri yükleniyor...</Text></SafeAreaView>;
 if(!detail)return <SafeAreaView style={styles.center}><Text>{error??'Su kaynağı bulunamadı.'}</Text><Pressable onPress={()=>router.back()}><Text style={styles.link}>Geri dön</Text></Pressable></SafeAreaView>;
 const w=detail.waterBody;
 const openNavigation = async (provider: 'chooser' | 'google' | 'yandex' | 'apple') => {
   if (w.latitude == null || w.longitude == null) {
     Alert.alert('Koordinat bulunamadı', 'Bu su kaynağı için doğrulanmış koordinat olmadığı için yol tarifi açılamıyor.');
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
     catch { Alert.alert('Harita açılamadı', 'Cihazınızda uyumlu bir harita uygulaması veya tarayıcı bulunamadı.'); }
   }
 };
 const showNavigationOptions = () => Alert.alert(
   'Yol tarifi al',
   'Hangi harita uygulamasında açmak istersiniz?',
   [
     { text: 'Google Maps', onPress: () => { void openNavigation('google'); } },
     { text: 'Yandex Maps', onPress: () => { void openNavigation('yandex'); } },
     ...(Platform.OS === 'ios' ? [{ text: 'Apple Haritalar', onPress: () => { void openNavigation('apple'); } }] : []),
     { text: 'Cihazın harita uygulaması', onPress: () => { void openNavigation('chooser'); } },
     { text: 'İptal', style: 'cancel' as const },
   ],
 );
 return <SafeAreaView style={styles.container}><ScrollView contentContainerStyle={styles.content}>
  <Pressable onPress={()=>router.back()}><Text style={styles.back}>‹ Geri</Text></Pressable><Text style={styles.title}>{w.name}</Text><Text style={styles.location}>{[w.province,w.district].filter(Boolean).join(' • ')||'Konum bilgisi yok'}</Text><View style={styles.badge}><Text style={styles.badgeText}>{w.water_type||'Su kaynağı'}</Text></View>
  <View style={styles.card}><Text style={styles.section}>Kaynak ve doğrulama</Text><View style={styles.grid}><Info label="Doğrulama seviyesi" value={w.verification_level||'Belirtilmemiş'}/><Info label="Kayıt durumu" value={w.verification_status||'Belirtilmemiş'}/><Info label="Erişim" value={w.access_level||'Ayrıca kontrol edilmeli'}/><Info label="Son kontrol" value={w.last_verified_at?new Date(w.last_verified_at).toLocaleDateString('tr-TR'):'Belirtilmemiş'}/></View>{w.source_name?<Text style={styles.muted}>Kaynak: {w.source_name}</Text>:null}{w.source_url?<Text style={styles.source}>{w.source_url}</Text>:null}{w.source_reference&&w.source_reference!==w.source_url?<Text style={styles.muted}>Kaynak notu: {w.source_reference}</Text>:null}{w.description?<Text style={styles.body}>{w.description}</Text>:null}{!w.source_url&&!w.source_reference?<Text style={styles.warning}>Doğrudan kaynak bağlantısı bulunmuyor; bu kayıt ayrıca doğrulanmalı.</Text>:null}</View>
  <View style={styles.card}><Text style={styles.section}>Avlanma mevzuatı</Text><Text style={styles.status}>⚠️ Bu su kaynağı kaydı tek başına avlanma izni göstermez.</Text><Text style={styles.muted}>Güncel il, su, tür ve tarih kısıtları resmî mevzuatla kontrol edilmelidir. Erişim, özel mülkiyet ve saha güvenliği bilgileri ayrıca doğrulanmalıdır.</Text></View>
  <View style={styles.card}><Text style={styles.section}>Bu suda bulunan balıklar</Text>{detail.fish.length===0?<Text style={styles.muted}>Henüz ilişkilendirilmiş tür kaydı bulunmuyor.</Text>:detail.fish.map(f=><Pressable key={f.id} onPress={()=>router.push(`/fish/${f.id}`)} style={styles.fishRow}><Text style={styles.fishName}>{f.common_name_tr}</Text>{f.scientific_name?<Text style={styles.scientific}>{f.scientific_name}</Text>:null}<Text style={styles.open}>Tür ayrıntısını aç ›</Text></Pressable>)}</View>
  <View style={styles.card}><Text style={styles.section}>Koordinat bilgisi</Text>{w.latitude!=null&&w.longitude!=null?<><Text style={styles.muted}>{Number(w.latitude).toFixed(5)}, {Number(w.longitude).toFixed(5)}</Text><Text style={styles.warning}>Bu koordinat su kaynağını gösterir; kıyı girişi, halka açık erişim veya güvenli varış noktası olduğu ayrıca doğrulanmalıdır.</Text><Pressable style={styles.mapButton} onPress={showNavigationOptions}><Text style={styles.mapButtonText}>Yol tarifi al · Harita uygulamasında aç</Text></Pressable></>:<><Text style={styles.muted}>Bu kayıtta koordinat yok; harita uygulamasında güvenilir yol tarifi oluşturulamıyor.</Text><Pressable style={[styles.mapButton,{opacity:0.5}]} onPress={()=>Alert.alert('Koordinat eksik','Konum doğrulanana kadar yol tarifi bağlantısı oluşturulamaz.')}><Text style={styles.mapButtonText}>Yol tarifi kullanılamıyor</Text></Pressable></>}</View>
 </ScrollView></SafeAreaView>;
}
function Info({label,value}:{label:string;value:string}){return <View style={styles.info}><Text style={styles.infoLabel}>{label}</Text><Text style={styles.infoValue}>{value}</Text></View>}
const styles=StyleSheet.create({container:{flex:1,backgroundColor:'#f6f8f7'},content:{padding:18,paddingBottom:40},center:{flex:1,alignItems:'center',justifyContent:'center',gap:10},back:{fontWeight:'800',color:'#087f5b',marginBottom:14},title:{fontSize:28,fontWeight:'800',color:'#123b32'},location:{marginTop:5,color:'#71817b'},badge:{alignSelf:'flex-start',backgroundColor:'#dcece7',paddingHorizontal:12,paddingVertical:7,borderRadius:16,marginTop:12},badgeText:{fontWeight:'700',color:'#125744'},card:{backgroundColor:'#fff',borderRadius:16,padding:16,marginTop:14,borderWidth:1,borderColor:'#dbe5e1'},section:{fontSize:18,fontWeight:'800',color:'#17352e',marginBottom:10},grid:{flexDirection:'row',flexWrap:'wrap',gap:10},info:{width:'47%',backgroundColor:'#f6f8f7',borderRadius:10,padding:10},infoLabel:{fontSize:11,color:'#71817b'},infoValue:{fontWeight:'800',color:'#17352e',marginTop:4},status:{fontWeight:'700',color:'#765c20',marginBottom:7},fishRow:{paddingVertical:11,borderBottomWidth:1,borderBottomColor:'#edf2ef'},fishName:{fontSize:16,fontWeight:'800',color:'#17352e'},scientific:{fontStyle:'italic',color:'#71817b',marginTop:2},muted:{color:'#71817b',lineHeight:19},body:{color:'#4f625b',lineHeight:19,marginTop:8},warning:{color:'#765c20',lineHeight:19,marginTop:8},open:{color:'#087f5b',fontWeight:'800',marginTop:7},mapButton:{marginTop:12,backgroundColor:'#dcece7',paddingVertical:11,borderRadius:10,alignItems:'center'},mapButtonText:{fontWeight:'800',color:'#125744'},source:{fontSize:11,color:'#71817b',marginTop:8},link:{color:'#087f5b',fontWeight:'800',marginTop:10}});