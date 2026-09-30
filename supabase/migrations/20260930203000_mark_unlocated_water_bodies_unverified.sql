-- Mark all water-body records without a complete coordinate pair as name-and-province-only.
-- These records are intentionally retained for future community/source verification.
-- Do not invent coordinates or imply that a location has been verified.
update public.water_bodies
set
  latitude = null,
  longitude = null,
  district_id = null,
  basin_name = null,
  surface_area_ha = null,
  description = null,
  source_id = null,
  verification_level = 'X',
  verification_status = 'pending',
  source_checked_at = null,
  last_verified_at = null,
  source_reference = null,
  external_source_id = null,
  source_year = null,
  dam_height_m = null,
  storage_capacity_mcm = null,
  irrigated_area_ha = null,
  hydroelectric_mw = null,
  coordinate_confidence_grade = 'F',
  coordinate_confidence_note = 'Konum koordinatları teyit edilmedi. Bu kayıt yalnızca su alanı adı ve il eşleştirmesini içerir; kullanıcı geri bildirimi veya güvenilir kaynakla doğrulama bekleniyor.',
  community_confidence_grade = 'F',
  updated_at = now()
where latitude is null or longitude is null;
