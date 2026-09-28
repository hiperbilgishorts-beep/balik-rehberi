import { useEffect, useState } from 'react';
import { ActivityIndicator, Pressable, SafeAreaView, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { getWaterBodyDetail } from '../../src/lib/data';
import type { WaterBodyDetail } from '../../src/types/database';

export default function WaterBodyDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const [detail, setDetail] = useState<WaterBodyDetail | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!id) return;
    getWaterBodyDetail(id).then(result => { setDetail(result.data); setLoading(false); });
  }, [id]);

  if (loading) return <SafeAreaView style={styles.center}><ActivityIndicator /><Text style={styles.muted}>Su kaynağı bilgileri yükleniyor...</Text></SafeAreaView>;
  if (!detail) return <SafeAreaView style={styles.center}><Text>Su kaynağı bulunamadı.</Text><Pressable onPress={() => router.back()}><Text style={styles.link}>Geri dön</Text></Pressable></SafeAreaView>;

  return <SafeAreaView style={styles.container}>
    <ScrollView contentContainerStyle={styles.content}>
      <Pressable onPress={() => router.back()}><Text style={styles.back}>‹ Geri</Text></Pressable>
      <Text style={styles.title}>{detail.waterBody.name}</Text>
      <Text style={styles.location}>{[detail.waterBody.province, detail.waterBody.district].filter(Boolean).join(' • ')}</Text>
      <View style={styles.badge}><Text style={styles.badgeText}>{detail.waterBody.water_type || 'Su kaynağı'}</Text></View>

      <View style={styles.card}>
        <Text style={styles.section}>Avlanma durumu</Text>
        <Text style={styles.status}>{detail.waterBody.fishing_allowed === false ? '⛔ Avlanmaya izin verilmiyor' : detail.waterBody.fishing_allowed === true ? '🎣 Avlanma bilgisi mevcut' : '⚠️ Güncel mevzuat kontrol edilmeli'}</Text>
        {detail.waterBody.verification_level ? <Text style={styles.muted}>Doğrulama: {detail.waterBody.verification_level}</Text> : null}
      </View>

      <View style={styles.card}>
        <Text style={styles.section}>Bu suda bulunan balıklar</Text>
        {detail.fish.length === 0 ? <Text style={styles.muted}>Henüz doğrulanmış tür kaydı bulunmuyor.</Text> : detail.fish.map(fish => (
          <View key={fish.id} style={styles.fishRow}><Text style={styles.fishName}>{fish.common_name_tr}</Text>{fish.scientific_name ? <Text style={styles.scientific}>{fish.scientific_name}</Text> : null}{fish.habitat ? <Text style={styles.muted}>{fish.habitat}</Text> : null}</View>
        ))}
      </View>

      <View style={styles.card}>
        <Text style={styles.section}>Konum</Text>
        {detail.waterBody.latitude != null && detail.waterBody.longitude != null ? <Text style={styles.muted}>{Number(detail.waterBody.latitude).toFixed(5)}, {Number(detail.waterBody.longitude).toFixed(5)}</Text> : <Text style={styles.muted}>Koordinat bilgisi bulunmuyor.</Text>}
      </View>
    </ScrollView>
  </SafeAreaView>;
}

const styles = StyleSheet.create({ container:{flex:1,backgroundColor:'#f6f8f7'}, content:{padding:18,paddingBottom:40}, center:{flex:1,alignItems:'center',justifyContent:'center',gap:10}, back:{fontWeight:'800',color:'#087f5b',marginBottom:14}, title:{fontSize:28,fontWeight:'800',color:'#123b32'}, location:{marginTop:5,color:'#71817b'}, badge:{alignSelf:'flex-start',backgroundColor:'#dcece7',paddingHorizontal:12,paddingVertical:7,borderRadius:16,marginTop:12}, badgeText:{fontWeight:'700',color:'#125744'}, card:{backgroundColor:'#fff',borderRadius:16,padding:16,marginTop:14,borderWidth:1,borderColor:'#dbe5e1'}, section:{fontSize:18,fontWeight:'800',color:'#17352e',marginBottom:10}, status:{fontWeight:'700',color:'#276b58',marginBottom:7}, fishRow:{paddingVertical:10,borderBottomWidth:1,borderBottomColor:'#edf2ef'}, fishName:{fontSize:16,fontWeight:'800',color:'#17352e'}, scientific:{fontStyle:'italic',color:'#71817b',marginTop:2}, muted:{color:'#71817b'}, link:{color:'#087f5b',fontWeight:'800',marginTop:10} });