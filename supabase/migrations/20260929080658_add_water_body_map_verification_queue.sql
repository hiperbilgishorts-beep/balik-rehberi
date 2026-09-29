-- Water-body location verification queue.
-- This migration tracks candidate map matches separately from canonical coordinates.
-- A provider match is not treated as verified until evidence has been reviewed.
CREATE TABLE IF NOT EXISTS public.water_body_location_checks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  water_body_id uuid NOT NULL REFERENCES public.water_bodies(id) ON DELETE CASCADE,
  provider text NOT NULL CHECK (provider IN ('google_maps','yandex_maps','openstreetmap','manual')),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','candidate_found','verified','rejected','needs_review')),
  candidate_name text,
  candidate_latitude double precision CHECK (candidate_latitude IS NULL OR candidate_latitude BETWEEN -90 AND 90),
  candidate_longitude double precision CHECK (candidate_longitude IS NULL OR candidate_longitude BETWEEN -180 AND 180),
  provider_place_id text,
  match_confidence numeric(4,3) CHECK (match_confidence IS NULL OR match_confidence BETWEEN 0 AND 1),
  evidence_url text,
  checked_at timestamptz,
  reviewer_notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (water_body_id, provider)
);

CREATE INDEX IF NOT EXISTS idx_water_body_location_checks_status_provider
  ON public.water_body_location_checks (status, provider);
CREATE INDEX IF NOT EXISTS idx_water_body_location_checks_water_body
  ON public.water_body_location_checks (water_body_id);

ALTER TABLE public.water_body_location_checks ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.water_body_location_checks FROM PUBLIC, anon, authenticated;

-- Create pending review work items only. No map coordinates are guessed or copied into water_bodies.
INSERT INTO public.water_body_location_checks (water_body_id, provider, status)
SELECT wb.id, provider.provider, 'pending'
FROM public.water_bodies wb
CROSS JOIN (VALUES ('google_maps'::text), ('yandex_maps'::text)) AS provider(provider)
ON CONFLICT (water_body_id, provider) DO NOTHING;
