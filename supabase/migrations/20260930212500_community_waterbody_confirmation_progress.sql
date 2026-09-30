-- Keep community confirmation grades synchronized for inserts, vote changes,
-- deletes, and any reassignment of a user's vote to another water body.
-- Community grade is separate from source-based coordinate confidence.
CREATE OR REPLACE FUNCTION internal.refresh_water_body_feedback_summary()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  target_id uuid;
  target_ids uuid[];
  positives integer;
  negatives integer;
  unclear integer;
  net integer;
  grade text;
BEGIN
  IF TG_OP = 'DELETE' THEN
    target_ids := ARRAY[OLD.water_body_id];
  ELSIF TG_OP = 'UPDATE' AND OLD.water_body_id IS DISTINCT FROM NEW.water_body_id THEN
    target_ids := ARRAY[OLD.water_body_id, NEW.water_body_id];
  ELSE
    target_ids := ARRAY[NEW.water_body_id];
  END IF;

  FOREACH target_id IN ARRAY target_ids LOOP
    SELECT count(*) FILTER (WHERE vote = 'correct'),
           count(*) FILTER (WHERE vote = 'incorrect'),
           count(*) FILTER (WHERE vote = 'unclear')
      INTO positives, negatives, unclear
      FROM public.water_body_location_feedback
      WHERE water_body_id = target_id;

    positives := coalesce(positives, 0);
    negatives := coalesce(negatives, 0);
    unclear := coalesce(unclear, 0);
    net := positives - negatives;

    grade := CASE
      WHEN positives >= 25 AND net >= 25 THEN 'A'
      WHEN positives >= 20 AND net >= 20 THEN 'B'
      WHEN positives >= 15 AND net >= 15 THEN 'C'
      WHEN positives >= 10 AND net >= 10 THEN 'D'
      WHEN positives >= 5 AND net >= 5 THEN 'E'
      ELSE 'F'
    END;

    INSERT INTO public.water_body_feedback_summary (
      water_body_id, correct_votes, incorrect_votes, unclear_votes,
      net_votes, community_confidence_grade, updated_at
    ) VALUES (
      target_id, positives, negatives, unclear, net, grade, now()
    )
    ON CONFLICT (water_body_id) DO UPDATE SET
      correct_votes = excluded.correct_votes,
      incorrect_votes = excluded.incorrect_votes,
      unclear_votes = excluded.unclear_votes,
      net_votes = excluded.net_votes,
      community_confidence_grade = excluded.community_confidence_grade,
      updated_at = now();

    UPDATE public.water_bodies
       SET community_confidence_grade = grade,
           updated_at = now()
     WHERE id = target_id;
  END LOOP;

  IF TG_OP = 'DELETE' THEN RETURN OLD; END IF;
  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION internal.refresh_water_body_feedback_summary()
  FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS refresh_water_body_feedback_summary
  ON public.water_body_location_feedback;

CREATE TRIGGER refresh_water_body_feedback_summary
  AFTER INSERT OR UPDATE OR DELETE ON public.water_body_location_feedback
  FOR EACH ROW EXECUTE FUNCTION internal.refresh_water_body_feedback_summary();
