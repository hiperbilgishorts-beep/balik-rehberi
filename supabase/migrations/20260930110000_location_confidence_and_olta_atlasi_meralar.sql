-- Location confidence grades, community feedback and the sourced mera directory.
-- Coordinate trust is deliberately separate from overall record verification.
ALTER TABLE public.water_bodies
  ADD COLUMN IF NOT EXISTS coordinate_confidence_grade text NOT NULL DEFAULT 'F'
    CHECK (coordinate_confidence_grade IN ('A','B','C','D','E','F'));
ALTER TABLE public.water_bodies ADD COLUMN IF NOT EXISTS coordinate_confidence_note text;
ALTER TABLE public.water_bodies
  ADD COLUMN IF NOT EXISTS community_confidence_grade text NOT NULL DEFAULT 'F'
    CHECK (community_confidence_grade IN ('A','B','C','D','E','F'));

UPDATE public.water_bodies
SET coordinate_confidence_grade = CASE
  WHEN latitude IS NULL OR longitude IS NULL THEN 'F'
  WHEN source_reference ILIKE '%cross-check%' OR source_reference ILIKE '%çapraz kontrol%' THEN 'A'
  WHEN source_reference ILIKE '%exact normalized%' OR source_reference ILIKE '%exact water-name%'
    OR source_reference ILIKE '%exact distinctive%' OR source_reference ILIKE '%Meraloji Engine%'
    OR source_reference ILIKE '%named water feature%' THEN 'B'
  WHEN COALESCE(source_reference,'') <> '' THEN 'C'
  ELSE 'D'
END,
coordinate_confidence_note = CASE
  WHEN latitude IS NULL OR longitude IS NULL THEN 'Koordinat henüz kaynakla eşleştirilmedi.'
  WHEN source_reference ILIKE '%cross-check%' OR source_reference ILIKE '%çapraz kontrol%'
    THEN 'Birden fazla kaynakla çapraz kontrol kaydı mevcut; pin su gövdesinin genel konumunu gösterir.'
  WHEN source_reference ILIKE '%exact normalized%' OR source_reference ILIKE '%exact water-name%'
    OR source_reference ILIKE '%exact distinctive%' OR source_reference ILIKE '%Meraloji Engine%'
    OR source_reference ILIKE '%named water feature%'
    THEN 'Ad ve coğrafi bağlam eşleşmesi kaynak notunda kayıtlı; pin kıyı erişimi değildir.'
  WHEN COALESCE(source_reference,'') <> ''
    THEN 'Kaynak notu mevcut ancak çapraz doğrulama sınırlı; konumu gitmeden önce kontrol edin.'
  ELSE 'Koordinat var ancak izlenebilir kaynak notu eksik; kontrol edin.'
END;

CREATE TABLE IF NOT EXISTS public.fishing_areas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_slug text NOT NULL UNIQUE,
  name text NOT NULL,
  province_name text,
  district_name text,
  zone_name text,
  water_type text,
  source_grade text NOT NULL CHECK (source_grade IN ('A','B','C','D')),
  location_confidence_grade text NOT NULL CHECK (location_confidence_grade IN ('A','B','C','D','E','F')),
  source_url text NOT NULL,
  source_name text NOT NULL DEFAULT 'Olta Atlası',
  general_note text NOT NULL DEFAULT 'Bu kayıt genel mera rehberidir; kesin kıyı noktası, erişim izni veya güncel av uygunluğu anlamına gelmez.',
  coordinates_imported boolean NOT NULL DEFAULT false CHECK (coordinates_imported = false),
  source_checked_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.fishing_areas ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS fishing_areas_public_read ON public.fishing_areas;
CREATE POLICY fishing_areas_public_read ON public.fishing_areas
  FOR SELECT TO anon, authenticated USING (true);
GRANT SELECT ON public.fishing_areas TO anon, authenticated;

CREATE TABLE IF NOT EXISTS public.water_body_location_feedback (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  water_body_id uuid NOT NULL REFERENCES public.water_bodies(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  vote text NOT NULL CHECK (vote IN ('correct','incorrect','unclear')),
  note text CHECK (note IS NULL OR char_length(note) <= 500),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (water_body_id,user_id)
);
ALTER TABLE public.water_body_location_feedback ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS location_feedback_read_own ON public.water_body_location_feedback;
CREATE POLICY location_feedback_read_own ON public.water_body_location_feedback
  FOR SELECT TO authenticated USING (user_id = (SELECT auth.uid()));
DROP POLICY IF EXISTS location_feedback_insert_own ON public.water_body_location_feedback;
CREATE POLICY location_feedback_insert_own ON public.water_body_location_feedback
  FOR INSERT TO authenticated WITH CHECK (user_id = (SELECT auth.uid()));
DROP POLICY IF EXISTS location_feedback_update_own ON public.water_body_location_feedback;
CREATE POLICY location_feedback_update_own ON public.water_body_location_feedback
  FOR UPDATE TO authenticated USING (user_id = (SELECT auth.uid()))
  WITH CHECK (user_id = (SELECT auth.uid()));
GRANT SELECT, INSERT, UPDATE ON public.water_body_location_feedback TO authenticated;

CREATE OR REPLACE FUNCTION public.submit_water_body_location_feedback(
  p_water_body_id uuid, p_vote text, p_note text DEFAULT NULL
) RETURNS jsonb
LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  uid uuid;
  positives integer;
  negatives integer;
  net integer;
  grade text;
BEGIN
  uid := auth.uid();
  IF uid IS NULL THEN RAISE EXCEPTION 'Geri bildirim için giriş yapmalısınız.'; END IF;
  IF p_vote NOT IN ('correct','incorrect','unclear') THEN RAISE EXCEPTION 'Geçersiz geri bildirim türü.'; END IF;
  IF p_note IS NOT NULL AND char_length(p_note) > 500 THEN RAISE EXCEPTION 'Not en fazla 500 karakter olabilir.'; END IF;
  INSERT INTO public.water_body_location_feedback(water_body_id,user_id,vote,note)
  VALUES (p_water_body_id,uid,p_vote,nullif(trim(p_note),''))
  ON CONFLICT (water_body_id,user_id) DO UPDATE
    SET vote=excluded.vote,note=excluded.note,updated_at=now();
  SELECT count(*) FILTER (WHERE vote='correct'), count(*) FILTER (WHERE vote='incorrect')
    INTO positives,negatives
    FROM public.water_body_location_feedback WHERE water_body_id=p_water_body_id;
  net := positives - negatives;
  grade := CASE
    WHEN positives >= 25 AND net >= 25 THEN 'A'
    WHEN positives >= 20 AND net >= 20 THEN 'B'
    WHEN positives >= 15 AND net >= 15 THEN 'C'
    WHEN positives >= 10 AND net >= 10 THEN 'D'
    WHEN positives >= 5 AND net >= 5 THEN 'E'
    ELSE 'F'
  END;
  UPDATE public.water_bodies SET community_confidence_grade=grade,updated_at=now()
    WHERE id=p_water_body_id;
  RETURN jsonb_build_object('correct_votes',positives,'incorrect_votes',negatives,
    'net_votes',net,'community_confidence_grade',grade);
END;
$$;
REVOKE ALL ON FUNCTION public.submit_water_body_location_feedback(uuid,text,text) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.submit_water_body_location_feedback(uuid,text,text) TO authenticated;

CREATE OR REPLACE FUNCTION public.get_water_body_location_feedback_summary(p_water_body_id uuid)
RETURNS jsonb
LANGUAGE sql SECURITY DEFINER SET search_path = ''
AS $$
  SELECT jsonb_build_object(
    'correct_votes',count(*) FILTER (WHERE f.vote='correct'),
    'incorrect_votes',count(*) FILTER (WHERE f.vote='incorrect'),
    'unclear_votes',count(*) FILTER (WHERE f.vote='unclear'),
    'community_confidence_grade',coalesce(max(w.community_confidence_grade),'F'))
  FROM public.water_body_location_feedback f
  JOIN public.water_bodies w ON w.id=f.water_body_id
  WHERE f.water_body_id=p_water_body_id
$$;
REVOKE ALL ON FUNCTION public.get_water_body_location_feedback_summary(uuid) FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.get_water_body_location_feedback_summary(uuid) TO authenticated;

INSERT INTO public.sources(name,organization,url,source_type,verification_status,notes,source_scope)
SELECT 'Olta Atlası - Meralar Arşivi','Olta Atlası','https://oltaatlasi.com/meralar/','secondary','pending',
  'Yalnız rota adı, bölge bilgisi ve yayınlanmış güven seviyesi referans olarak alındı; koordinatlar ve özgün açıklama metinleri kopyalanmadı. Kaynak yöntemi: https://oltaatlasi.com/hakkinda/',
  'Mera adları ve kaynak güven seviyeleri'
WHERE NOT EXISTS (SELECT 1 FROM public.sources WHERE name='Olta Atlası - Meralar Arşivi');
