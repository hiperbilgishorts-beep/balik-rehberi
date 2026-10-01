import { useEffect, useMemo, useState } from 'react';
import { ActivityIndicator, FlatList, Linking, Modal, Pressable, SafeAreaView, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { getFish, getWaterBodies } from '../src/lib/data';
import { supabase } from '../src/config/supabase';
import type { Fish, WaterBody } from '../src/types/database';

type PickerKind = 'province' | 'type' | 'fish' | null;
const typeOptions = [
  { value: 'reservoir', label: 'Baraj gölü' },
  { value: 'natural_lake', label: 'Doğal göl' },
  { value: 'pond', label: 'Gölet' },
  { value: 'river', label: 'Akarsu' },
  { value: 'stream', label: 'Dere' },
  { value: 'sea', label: 'Deniz' },
];
const typeLabel = (value: string | null) => typeOptions.find(x => x.value === value)?.label ?? value ?? 'Su kaynağı';

export default function MapScreen() {
  const router = useRouter();
  const params = useLocalSearchParams<{ search?: string }>();
  const [items, setItems] = useState<WaterBody[]>([]);
  const [fish, setFish] = useState<Fish[]>([]);
  const [search, setSearch] = useState(typeof params.search === 'string' ? params.search : '');
  const [province, setProvince] = useState('');
  const [waterType, setWaterType] = useState('');
  const [fishId, setFishId] = useState('');
  const [fishWaterIds, setFishWaterIds] = useState<string[] | null>(null);
  const [picker, setPicker] = useState<PickerKind>(null);
  const [pickerSearch, setPickerSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [filterLoading, setFilterLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    let alive = true;
    Promise.all([getWaterBodies(), getFish()]).then(([waters, species]) => {
      if (!alive) return;
      setItems(waters.data);
      setFish(species.data);
      if (waters.error) setError('Su kaynakları yüklenemedi. İnternet bağlantını kontrol edip tekrar dene.');
      setLoading(false);
    }).catch(() => { if (alive) { setError('Veriler yüklenemedi. Lütfen tekrar dene.'); setLoading(false); } });
    return () => { alive = false; };
  }, []);

  useEffect(() => {
    let alive = true;
    if (!fishId) { setFishWaterIds(null); return () => { alive = false; }; }
    if (!supabase) { setFishWaterIds([]); return () => { alive = false; }; }
    setFilterLoading(true);
    supabase.from('fish_water_bodies').select('water_body_id').eq('fish_id', fishId).then(({ data, error: relationError }) => {
      if (!alive) return;
      setFishWaterIds(relationError ? [] : Array.from(new Set((data ?? []).map(row => row.water_body_id as string))));
      setFilterLoading(false);
    });
    return () => { alive = false; };
  }, [fishId]);

  const provinces = useMemo(() => Array.from(new Set(items.map(x => x.province).filter((x): x is string => Boolean(x)))).sort((a,b)=>a.localeCompare(b,'tr-TR')), [items]);
  const selectedFish = fish.find(x => x.id === fishId);
  const filtered = useMemo(() => {
    const q = search.trim().toLocaleLowerCase('tr-TR');
    return items.filter(item =>
      (!q || [item.name, item.province, item.basin_name].filter(Boolean).some(value => String(value).toLocaleLowerCase('tr-TR').includes(q))) &&
      (!province || item.province === province) &&
      (!waterType || item.water_type === waterType || (waterType === 'river' && ['river','stream','watercourse'].includes(item.water_type ?? ''))) &&
      (!fishId || (fishWaterIds ?? []).includes(item.id))
    );
  }, [items, search, province, waterType, fishId, fishWaterIds]);

  const openPicker = (kind: PickerKind) => { setPickerSearch(''); setPicker(kind); };
  const resetFilters = () => { setProvince(''); setWaterType(''); setFishId(''); setSearch(''); };
  const openMap = async (item: WaterBody) => {
    if (item.latitude == null || item.longitude == null) return;
    const url = 'https://www.google.com/maps/search/?api=1&query=' + Number(item.latitude) + ',' + Number(item.longitude);
    try { await Linking.openURL(url); } catch { /* Keep the app open if no map handler is installed. */ }
  };
  const pickerItems = picker === 'province'
    ? provinces.map(value => ({ value, label: value }))
    : picker === 'type'
      ? typeOptions.map(x => ({ value: x.value, label: x.label }))
      : fish.map(x => ({ value: x.id, label: x.common_name_tr + (x.scientific_name ? ' · ' + x.scientific_name : '') }));
  const pickerFiltered = pickerItems.filter(x => x.label.toLocaleLowerCase('tr-TR').includes(pickerSearch.toLocaleLowerCase('tr-TR')));

  return <SafeAreaView style={styles.container}>
    <View style={styles.header}>
      <Text style={styles.eyebrow}>KEŞFET</Text>
      <Text style={styles.title}>Su kaynakları</Text>
      <Text style={styles.subtitle}>İl, su türü ve hedef balığa göre aramanı daralt.</Text>
      <TextInput value={search} onChangeText={setSearch} placeholder="Göl, baraj, akarsu veya il ara..." placeholderTextColor="#85938d" style={styles.search}/>
    </View>
    <View style={styles.filterPanel}>
      <View style={styles.filterHeader}><Text style={styles.filterTitle}>Filtreler</Text><Pressable onPress={resetFilters}><Text style={styles.clear}>Temizle</Text></Pressable></View>
      <View style={styles.pickerRow}>
        <Pressable style={styles.pickerButton} onPress={() => openPicker('type')}><Text style={styles.pickerLabel}>SU TÜRÜ</Text><Text numberOfLines={1} style={styles.pickerValue}>{waterType ? typeLabel(waterType) : 'Tüm türler'}⌄</Text></Pressable>
        <Pressable style={styles.pickerButton} onPress={() => openPicker('province')}><Text style={styles.pickerLabel}>İL</Text><Text numberOfLines={1} style={styles.pickerValue}>{province || 'Tüm iller'}⌄</Text></Pressable>
      </View>
      <Pressable style={styles.fishPicker} onPress={() => openPicker('fish')}><View style={{flex:1}}><Text style={styles.pickerLabel}>HEDEF BALIK</Text><Text style={styles.pickerValue}>{selectedFish?.common_name_tr ?? 'Tüm balık türleri'}  ⌄</Text></View><Text style={styles.fishIcon}>🐟</Text></Pressable>
      {(province || waterType || fishId) ? <View style={styles.activeFilters}><Text style={styles.activeText}>Seçili: {[province,waterType?typeLabel(waterType):'',selectedFish?.common_name_tr].filter(Boolean).join(' · ')}</Text></View> : null}
    </View>

    <View style={styles.resultsHeading}><View><Text style={styles.resultsTitle}>Keşfedilecek yerler</Text><Text style={styles.resultsSubtitle}>{filterLoading ? 'Balık eşleşmeleri aranıyor…' : filtered.length + ' su kaynağı'}</Text></View><View style={styles.resultBadge}><Text style={styles.resultBadgeText}>⌖</Text></View></View>
    {loading ? <ActivityIndicator size="large" color="#087f5b" style={{marginTop:28}}/> : error ? <View style={styles.empty}><Text style={styles.emptyText}>{error}</Text><Pressable style={styles.retry} onPress={()=>{setLoading(true);setError('');void Promise.all([getWaterBodies(),getFish()]).then(([w,f])=>{setItems(w.data);setFish(f.data);setLoading(false);if(w.error)setError('Su kaynakları yüklenemedi.');}).catch(()=>{setLoading(false);setError('Veriler yüklenemedi.');});}}><Text style={styles.retryText}>Tekrar dene</Text></Pressable></View> : <FlatList data={filtered.slice(0,250)} keyExtractor={x=>x.id} contentContainerStyle={styles.list} ListEmptyComponent={<View style={styles.empty}><Text style={styles.emptyText}>{fishId ? 'Bu balıkla eşleşen su kaynağı bulunamadı.' : 'Bu filtrelerle eşleşen su kaynağı bulunamadı.'}</Text><Pressable onPress={resetFilters}><Text style={styles.clear}>Filtreleri temizle</Text></Pressable></View>} renderItem={({item})=><Pressable style={styles.card} onPress={()=>router.push({pathname:'/water-body/[id]',params:{id:item.id}})}><View style={styles.cardIcon}><Text style={styles.cardIconText}>{item.water_type==='river'||item.water_type==='stream'?'≈':item.water_type==='natural_lake'?'◉':'⌖'}</Text></View><View style={styles.cardCopy}><Text style={styles.cardTitle}>{item.name}</Text><Text style={styles.cardMeta}>{[item.province,typeLabel(item.water_type)].filter(Boolean).join(' · ')}</Text>{fishId ? <Text style={styles.fishMatch}>✓ {selectedFish?.common_name_tr} kaydıyla eşleşiyor</Text> : null}</View><View style={styles.cardActions}>{item.latitude!=null&&item.longitude!=null?<Pressable style={styles.mapButton} onPress={()=>void openMap(item)}><Text style={styles.mapButtonText}>Harita ↗</Text></Pressable>:null}<Text style={styles.chevron}>›</Text></View></Pressable>}/>}
    <View style={styles.bottomBar}><Pressable onPress={()=>router.back()} style={styles.backButton}><Text style={styles.backText}>‹  Geri</Text></Pressable><Text style={styles.bottomHint}>Genel konumlar · erişim izni değildir</Text></View>

    <Modal visible={picker !== null} transparent animationType="slide" onRequestClose={()=>setPicker(null)}>
      <View style={styles.modalBackdrop}><View style={styles.modalSheet}><View style={styles.modalHandle}/><View style={styles.modalHeader}><Text style={styles.modalTitle}>{picker==='province'?'İl seç':picker==='type'?'Su türü seç':'Balık türü seç'}</Text><Pressable onPress={()=>setPicker(null)}><Text style={styles.modalClose}>Kapat ✕</Text></Pressable></View><TextInput value={pickerSearch} onChangeText={setPickerSearch} placeholder="Listede ara..." placeholderTextColor="#87958f" style={styles.modalSearch}/><FlatList data={[{value:'',label:picker==='province'?'Tüm iller':picker==='type'?'Tüm türler':'Tüm balık türleri'},...pickerFiltered]} keyExtractor={x=>x.value||'all'} keyboardShouldPersistTaps="handled" renderItem={({item})=>{const selected=picker==='province'?province===item.value:picker==='type'?waterType===item.value:fishId===item.value;return <Pressable style={[styles.option,selected&&styles.optionSelected]} onPress={()=>{if(picker==='province')setProvince(item.value);else if(picker==='type')setWaterType(item.value);else setFishId(item.value);setPicker(null);}}><Text style={[styles.optionText,selected&&styles.optionTextSelected]}>{item.label}</Text><Text style={[styles.optionCheck,selected&&styles.optionTextSelected]}>{selected?'✓':''}</Text></Pressable>}}/></View></View>
    </Modal>
  </SafeAreaView>;
}

const styles=StyleSheet.create({
 container:{flex:1,backgroundColor:'#f5f8f6'},header:{paddingHorizontal:18,paddingTop:14,paddingBottom:12},eyebrow:{fontSize:10,fontWeight:'900',letterSpacing:1.8,color:'#16805c'},title:{fontSize:29,fontWeight:'900',color:'#153d32',marginTop:4},subtitle:{fontSize:13,color:'#71827a',marginTop:4,marginBottom:13},search:{backgroundColor:'#fff',borderWidth:1,borderColor:'#dfe8e3',borderRadius:14,paddingHorizontal:14,paddingVertical:12,fontSize:14,color:'#183d32'},
 filterPanel:{marginHorizontal:16,backgroundColor:'#fff',borderRadius:18,padding:13,borderWidth:1,borderColor:'#e3ebe6'},filterHeader:{flexDirection:'row',justifyContent:'space-between',alignItems:'center',marginBottom:10},filterTitle:{fontSize:14,fontWeight:'900',color:'#1b4034'},clear:{fontSize:12,fontWeight:'800',color:'#087f5b'},pickerRow:{flexDirection:'row',gap:9},pickerButton:{flex:1,borderWidth:1,borderColor:'#dfe8e3',borderRadius:12,padding:11,backgroundColor:'#f9fbfa'},pickerLabel:{fontSize:9,fontWeight:'900',letterSpacing:1,color:'#84928b'},pickerValue:{fontSize:13,fontWeight:'800',color:'#244b3e',marginTop:5},fishPicker:{marginTop:9,flexDirection:'row',alignItems:'center',borderWidth:1,borderColor:'#dfe8e3',borderRadius:12,padding:11,backgroundColor:'#f9fbfa'},fishIcon:{fontSize:20,marginHorizontal:6},activeFilters:{marginTop:10,backgroundColor:'#e8f5ee',padding:9,borderRadius:9},activeText:{fontSize:11,color:'#27624d',fontWeight:'700'},
 resultsHeading:{marginHorizontal:18,marginTop:18,marginBottom:6,flexDirection:'row',alignItems:'center',justifyContent:'space-between'},resultsTitle:{fontSize:17,fontWeight:'900',color:'#193e33'},resultsSubtitle:{fontSize:11,color:'#7b8a83',marginTop:3},resultBadge:{width:35,height:35,borderRadius:12,backgroundColor:'#dcefe6',alignItems:'center',justifyContent:'center'},resultBadgeText:{fontSize:21,color:'#087f5b'},list:{paddingHorizontal:16,paddingBottom:12},card:{backgroundColor:'#fff',borderRadius:15,padding:13,marginTop:8,flexDirection:'row',alignItems:'center',gap:11,borderWidth:1,borderColor:'#e7ede9'},cardIcon:{width:40,height:40,borderRadius:13,backgroundColor:'#e3f1ea',alignItems:'center',justifyContent:'center'},cardIconText:{fontSize:22,color:'#087f5b'},cardCopy:{flex:1},cardTitle:{fontSize:14,fontWeight:'900',color:'#193e33'},cardMeta:{fontSize:11,color:'#788980',marginTop:4},fishMatch:{fontSize:10,color:'#087f5b',fontWeight:'800',marginTop:5},cardActions:{alignItems:'flex-end',gap:6},mapButton:{backgroundColor:'#e4f2ea',borderRadius:9,paddingHorizontal:9,paddingVertical:7},mapButtonText:{fontSize:10,fontWeight:'900',color:'#087f5b'},chevron:{fontSize:22,color:'#a2afa8'},empty:{alignItems:'center',padding:26},emptyText:{color:'#6c7c74',textAlign:'center',lineHeight:20},retry:{backgroundColor:'#087f5b',paddingHorizontal:16,paddingVertical:10,borderRadius:10,marginTop:12},retryText:{color:'#fff',fontWeight:'800'},bottomBar:{paddingHorizontal:18,paddingVertical:10,flexDirection:'row',alignItems:'center',justifyContent:'space-between',borderTopWidth:1,borderTopColor:'#e3ebe6',backgroundColor:'#fff'},backButton:{paddingVertical:7,paddingHorizontal:12,borderRadius:11,backgroundColor:'#e7f2ec'},backText:{color:'#155640',fontWeight:'900',fontSize:14},bottomHint:{fontSize:10,color:'#84928b'},
 modalBackdrop:{flex:1,justifyContent:'flex-end',backgroundColor:'rgba(10,28,22,0.38)'},modalSheet:{maxHeight:'78%',backgroundColor:'#fff',borderTopLeftRadius:24,borderTopRightRadius:24,paddingHorizontal:18,paddingTop:10,paddingBottom:24},modalHandle:{width:42,height:4,borderRadius:4,backgroundColor:'#d5dfd9',alignSelf:'center',marginBottom:16},modalHeader:{flexDirection:'row',justifyContent:'space-between',alignItems:'center',marginBottom:12},modalTitle:{fontSize:20,fontWeight:'900',color:'#173d32'},modalClose:{fontWeight:'800',color:'#087f5b'},modalSearch:{borderWidth:1,borderColor:'#dfe8e3',backgroundColor:'#f8faf9',borderRadius:12,padding:12,marginBottom:9,color:'#173d32'},option:{flexDirection:'row',justifyContent:'space-between',alignItems:'center',paddingVertical:13,paddingHorizontal:12,borderRadius:10},optionSelected:{backgroundColor:'#e7f4ed'},optionText:{fontSize:14,color:'#284b3e'},optionTextSelected:{fontWeight:'900',color:'#087f5b'},optionCheck:{fontWeight:'900',color:'#087f5b'}
});