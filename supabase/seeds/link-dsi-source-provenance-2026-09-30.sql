-- Link already-verified DSİ source references to the corresponding source records.
-- This does not add or infer coordinates and does not change verification status.
update public.water_bodies
set source_id = case
  when water_type = 'pond' then '7450e8ea-f1e2-4a91-9636-e34eef21a27e'::uuid
  when water_type = 'reservoir' then '1270e0d8-d9db-4189-9745-dddde6927ad4'::uuid
  else source_id
end
where source_id is null
  and verification_status = 'verified'
  and verification_level = 'A'
  and (
    external_source_id ilike 'dsi-2024-dam-%'
    or external_source_id ilike 'dsi-2024-pond-%'
    or external_source_id ilike 'DSI-reservoir-%'
  )
  and water_type in ('reservoir', 'pond');
