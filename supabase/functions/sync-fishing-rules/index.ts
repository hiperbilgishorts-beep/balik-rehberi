import { createClient } from '@supabase/supabase-js';

const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const admin = createClient(supabaseUrl, serviceKey);
const PARSER_VERSION = '1.0.0';
const DATE_RE = /(\d{1,2})[./](\d{1,2})[./](\d{4})\s*(?:-|–|—|ile|ila)\s*(\d{1,2})[./](\d{1,2})[./](\d{4})/g;

function iso(d:number,m:number,y:number){return `${y}-${String(m).padStart(2,'0')}-${String(d).padStart(2,'0')}`;}
function clean(text:string){return text.replace(/\s+/g,' ').trim();}
function extractRanges(text:string){const out:{closed_start:string;closed_end:string}[]=[];let m:RegExpExecArray|null;while((m=DATE_RE.exec(text)))out.push({closed_start:iso(+m[1],+m[2],+m[3]),closed_end:iso(+m[4],+m[5],+m[6])});return out.filter((v,i,a)=>a.findIndex(x=>x.closed_start===v.closed_start&&x.closed_end===v.closed_end)===i).slice(0,20);}

Deno.serve(async req=>{
  if(req.method!=='POST')return new Response(JSON.stringify({error:'POST required'}),{status:405,headers:{'content-type':'application/json'}});
  const started=await admin.from('regulation_sync_runs').insert({status:'running'}).select('id').single();
  const runId=started.data?.id;
  try{
    const {data:sources,error}=await admin.from('sources').select('id,name,url,source_scope').eq('source_type','official');
    if(error)throw error;
    const candidates=(sources||[]).filter((s:any)=>/av yasağı|av sezonu|su ürünleri av|avcılık|avlanma|6\/2.*amatör/i.test(`${s.name} ${s.url} ${s.source_scope||''}`));
    let changed=0,inserted=0,updated=0,rejected=0;
    const {data:provs}=await admin.from('provinces').select('id,name');
    for(const source of candidates){
      let response:Response;try{response=await fetch(source.url,{redirect:'follow',headers:{'user-agent':'BalikRehberi-RegulationSync/1.0'}})}catch{rejected++;continue;}
      const body=await response.text();
      const text=clean(body.replace(/<script[\s\S]*?<\/script>/gi,' ').replace(/<style[\s\S]*?<\/style>/gi,' ').replace(/<[^>]+>/g,' '));
      const digest=await crypto.subtle.digest('SHA-256',new TextEncoder().encode(text));
      const hash=Array.from(new Uint8Array(digest)).map(x=>x.toString(16).padStart(2,'0')).join('');
      const ranges=extractRanges(text);
      const previous=await admin.from('regulation_source_snapshots').select('id,content_hash').eq('source_url',source.url).order('fetched_at',{ascending:false}).limit(1).maybeSingle();
      if(previous.data?.content_hash===hash)continue;
      changed++;
      await admin.from('regulation_source_snapshots').insert({source_url:source.url,source_title:source.name,source_scope:source.source_scope,content_hash:hash,http_status:response.status,parser_version:PARSER_VERSION,parsed_payload:{ranges},parse_status:response.ok?'parsed':'rejected'});
      await admin.from('sources').update({last_checked_at:new Date().toISOString(),accessed_at:new Date().toISOString()}).eq('id',source.id);
      if(!ranges.length) {rejected++;continue;}
      const province=(provs||[]).find((p:any)=>`${source.name} ${source.source_scope||''} ${text}`.toLocaleLowerCase('tr-TR').includes(p.name.toLocaleLowerCase('tr-TR')));
      if(!province){rejected++;continue;}
      for(const range of ranges){
        const rule={province_id:province.id,regulation_name:source.name,regulation_version:PARSER_VERSION,closed_start:range.closed_start,closed_end:range.closed_end,status:'restricted',source_id:source.id,verification_level:'A',source_checked_at:new Date().toISOString(),last_verified_at:new Date().toISOString(),source_reference:source.url,notes:'Otomatik resmi kaynak senkronizasyonu; tür/su kaynağı belirtilmeyen il geneli kural.'};
        const existing=await admin.from('fishing_rules').select('id').eq('province_id',province.id).eq('source_id',source.id).eq('closed_start',range.closed_start).eq('closed_end',range.closed_end).limit(1).maybeSingle();
        if(existing.data?.id){await admin.from('fishing_rules').update(rule).eq('id',existing.data.id);updated++;}else{await admin.from('fishing_rules').insert(rule);inserted++;}
      }
    }
    await admin.from('regulation_sync_runs').update({finished_at:new Date().toISOString(),status:'success',source_count:candidates.length,changed_count:changed,inserted_count:inserted,updated_count:updated,rejected_count:rejected}).eq('id',runId);
    return new Response(JSON.stringify({ok:true,source_count:candidates.length,changed_count:changed,inserted_count:inserted,updated_count:updated,rejected_count:rejected}),{headers:{'content-type':'application/json'}});
  }catch(e){
    await admin.from('regulation_sync_runs').update({finished_at:new Date().toISOString(),status:'failed',error_message:String(e)}).eq('id',runId);
    return new Response(JSON.stringify({ok:false,error:String(e)}),{status:500,headers:{'content-type':'application/json'}});
  }
});
