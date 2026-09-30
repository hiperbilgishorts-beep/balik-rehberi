-- Database hardening after full Supabase/GitHub audit.
-- Keep tables without public policies private; this migration does not open RLS.
DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT p.oid::regprocedure AS routine
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'internal'
      AND p.proname IN (
        'hydro_key',
        'verify_next_water_body_photon',
        'water_name_key2',
        'find_photon_waterbody_match',
        'fetch_photon_term',
        'water_name_key',
        'water_name_key_numbered',
        'water_feature_key'
      )
  LOOP
    EXECUTE format(
      'ALTER FUNCTION %s SET search_path = pg_catalog, extensions, public, internal, auth',
      r.routine
    );
  END LOOP;
END $$;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_extension e
    JOIN pg_namespace n ON n.oid = e.extnamespace
    WHERE e.extname = 'pg_trgm' AND n.nspname = 'public'
  ) THEN
    ALTER EXTENSION pg_trgm SET SCHEMA extensions;
  END IF;
END $$;

DO $$
DECLARE
  r record;
  cols text;
  idx_name text;
BEGIN
  FOR r IN
    SELECT c.oid, c.conrelid, c.conkey, c.conname,
           ns.nspname AS schema_name, tbl.relname AS table_name
    FROM pg_constraint c
    JOIN pg_class tbl ON tbl.oid = c.conrelid
    JOIN pg_namespace ns ON ns.oid = tbl.relnamespace
    WHERE c.contype = 'f'
      AND ns.nspname = 'public'
      AND NOT EXISTS (
        SELECT 1
        FROM pg_index i
        WHERE i.indrelid = c.conrelid
          AND i.indisvalid
          AND i.indisready
          AND i.indpred IS NULL
          AND i.indnkeyatts >= cardinality(c.conkey)
          AND (i.indkey::smallint[])[1:cardinality(c.conkey)] = c.conkey
      )
  LOOP
    SELECT string_agg(format('%I', a.attname), ', ' ORDER BY k.ord)
      INTO cols
    FROM unnest(r.conkey) WITH ORDINALITY AS k(attnum, ord)
    JOIN pg_attribute a
      ON a.attrelid = r.conrelid AND a.attnum = k.attnum;

    idx_name := left(
      'fkidx_' || r.table_name || '_' ||
      substr(md5(r.conrelid::text || ':' || r.conkey::text), 1, 12),
      63
    );

    EXECUTE format(
      'CREATE INDEX IF NOT EXISTS %I ON %I.%I (%s)',
      idx_name, r.schema_name, r.table_name, cols
    );
  END LOOP;
END $$;
