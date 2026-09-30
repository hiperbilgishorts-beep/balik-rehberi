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
CREATE INDEX IF NOT EXISTS idx_water_body_location_feedback_user_id ON public.water_body_location_feedback(user_id);

CREATE TABLE IF NOT EXISTS public.water_body_feedback_summary (
  water_body_id uuid PRIMARY KEY REFERENCES public.water_bodies(id) ON DELETE CASCADE,
  correct_votes integer NOT NULL DEFAULT 0,
  incorrect_votes integer NOT NULL DEFAULT 0,
  unclear_votes integer NOT NULL DEFAULT 0,
  net_votes integer NOT NULL DEFAULT 0,
  community_confidence_grade text NOT NULL DEFAULT 'F'
    CHECK (community_confidence_grade IN ('A','B','C','D','E','F')),
  updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.water_body_feedback_summary ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS feedback_summary_public_read ON public.water_body_feedback_summary;
CREATE POLICY feedback_summary_public_read ON public.water_body_feedback_summary
  FOR SELECT TO anon, authenticated USING (true);
GRANT SELECT ON public.water_body_feedback_summary TO anon, authenticated;

-- Private trigger function updates the public aggregate without exposing individual votes.
CREATE OR REPLACE FUNCTION internal.refresh_water_body_feedback_summary()
RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = ''
AS $$
DECLARE
  target_id uuid;
  positives integer;
  negatives integer;
  unclear integer;
  net integer;
  grade text;
BEGIN
  IF tg_op='DELETE' THEN target_id:=old.water_body_id; ELSE target_id:=new.water_body_id; END IF;
  SELECT count(*) FILTER (WHERE vote='correct'),
         count(*) FILTER (WHERE vote='incorrect'),
         count(*) FILTER (WHERE vote='unclear')
    INTO positives,negatives,unclear
    FROM public.water_body_location_feedback WHERE water_body_id=target_id;
  positives:=coalesce(positives,0); negatives:=coalesce(negatives,0); unclear:=coalesce(unclear,0);
  net:=positives-negatives;
  grade:=CASE
    WHEN positives>=25 AND net>=25 THEN 'A'
    WHEN positives>=20 AND net>=20 THEN 'B'
    WHEN positives>=15 AND net>=15 THEN 'C'
    WHEN positives>=10 AND net>=10 THEN 'D'
    WHEN positives>=5 AND net>=5 THEN 'E'
    ELSE 'F'
  END;
  INSERT INTO public.water_body_feedback_summary(
    water_body_id,correct_votes,incorrect_votes,unclear_votes,net_votes,community_confidence_grade,updated_at
  ) VALUES (target_id,positives,negatives,unclear,net,grade,now())
  ON CONFLICT (water_body_id) DO UPDATE SET
    correct_votes=excluded.correct_votes, incorrect_votes=excluded.incorrect_votes,
    unclear_votes=excluded.unclear_votes, net_votes=excluded.net_votes,
    community_confidence_grade=excluded.community_confidence_grade, updated_at=now();
  UPDATE public.water_bodies SET community_confidence_grade=grade,updated_at=now() WHERE id=target_id;
  IF tg_op='DELETE' THEN RETURN old; ELSE RETURN new; END IF;
END;
$$;
REVOKE ALL ON FUNCTION internal.refresh_water_body_feedback_summary() FROM PUBLIC, anon, authenticated;
DROP TRIGGER IF EXISTS refresh_water_body_feedback_summary ON public.water_body_location_feedback;
CREATE TRIGGER refresh_water_body_feedback_summary
  AFTER INSERT OR UPDATE OR DELETE ON public.water_body_location_feedback
  FOR EACH ROW EXECUTE FUNCTION internal.refresh_water_body_feedback_summary();

INSERT INTO public.sources(name,organization,url,source_type,verification_status,notes,source_scope)
SELECT 'Olta Atlası - Meralar Arşivi','Olta Atlası','https://oltaatlasi.com/meralar/','secondary','pending',
  'Yalnız rota adı, bölge bilgisi ve yayınlanmış güven seviyesi referans olarak alındı; koordinatlar ve özgün açıklama metinleri kopyalanmadı. Kaynak yöntemi: https://oltaatlasi.com/hakkinda/',
  'Mera adları ve kaynak güven seviyeleri'
WHERE NOT EXISTS (SELECT 1 FROM public.sources WHERE name='Olta Atlası - Meralar Arşivi');
