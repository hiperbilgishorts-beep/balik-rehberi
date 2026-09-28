create table if not exists public.regulation_sync_runs (
  id uuid primary key default gen_random_uuid(),
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  status text not null check (status in ('running','success','partial','failed')),
  source_count integer not null default 0,
  changed_count integer not null default 0,
  inserted_count integer not null default 0,
  updated_count integer not null default 0,
  rejected_count integer not null default 0,
  error_message text,
  created_at timestamptz not null default now()
);

create table if not exists public.regulation_source_snapshots (
  id uuid primary key default gen_random_uuid(),
  source_url text not null,
  source_title text,
  source_scope text,
  fetched_at timestamptz not null default now(),
  content_hash text not null,
  http_status integer,
  parser_version text not null default '1',
  parsed_payload jsonb not null default '{}'::jsonb,
  parse_status text not null default 'pending' check (parse_status in ('pending','parsed','rejected')),
  error_message text,
  unique(source_url, content_hash)
);

create index if not exists regulation_source_snapshots_url_idx on public.regulation_source_snapshots(source_url, fetched_at desc);
create index if not exists fishing_rules_scope_idx on public.fishing_rules(province_id, district_id, water_body_id, fish_id);
create index if not exists fish_water_bodies_scope_idx on public.fish_water_bodies(water_body_id, fish_id, verification_level);

alter table public.regulation_sync_runs enable row level security;
alter table public.regulation_source_snapshots enable row level security;

create policy regulation_sync_runs_read on public.regulation_sync_runs for select to anon, authenticated using (true);
create policy regulation_source_snapshots_read on public.regulation_source_snapshots for select to anon, authenticated using (true);
create policy fishing_rules_read on public.fishing_rules for select to anon, authenticated using (true);
create policy fish_water_bodies_read on public.fish_water_bodies for select to anon, authenticated using (true);
