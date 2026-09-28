create table if not exists public.spot_reports (id uuid primary key default gen_random_uuid(), spot_id uuid not null references public.fishing_spots(id) on delete cascade, user_id uuid not null references auth.users(id) on delete cascade, report_type text not null check (report_type in ('catch','access','closure','hazard','species','update')), title text, body text not null, fish_species_id uuid references public.fish_species(id), observed_at timestamptz, status text not null default 'pending' check (status in ('pending','published','rejected')), created_at timestamptz not null default now());
create index if not exists idx_spot_reports_spot_status on public.spot_reports(spot_id,status,created_at desc);
alter table public.spot_reports enable row level security;
create policy spot_reports_public_read on public.spot_reports for select using (status='published' or auth.uid()=user_id);
create policy spot_reports_owner_insert on public.spot_reports for insert with check (auth.uid()=user_id);
create policy spot_reports_owner_update on public.spot_reports for update using (auth.uid()=user_id) with check (auth.uid()=user_id);

create table if not exists public.favorite_spots (user_id uuid not null references auth.users(id) on delete cascade, spot_id uuid not null references public.fishing_spots(id) on delete cascade, created_at timestamptz not null default now(), primary key(user_id,spot_id));
alter table public.favorite_spots enable row level security;
create policy favorite_spots_owner_all on public.favorite_spots for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

create table if not exists public.trip_plans (id uuid primary key default gen_random_uuid(), user_id uuid not null references auth.users(id) on delete cascade, title text not null, notes text, planned_start timestamptz, planned_end timestamptz, status text not null default 'draft' check (status in ('draft','planned','completed','cancelled')), created_at timestamptz not null default now(), updated_at timestamptz not null default now());
alter table public.trip_plans enable row level security;
create policy trip_plans_owner_all on public.trip_plans for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

create table if not exists public.trip_plan_items (trip_plan_id uuid not null references public.trip_plans(id) on delete cascade, spot_id uuid not null references public.fishing_spots(id) on delete cascade, sort_order integer not null default 0, notes text, primary key(trip_plan_id,spot_id));
alter table public.trip_plan_items enable row level security;
create policy trip_plan_items_owner_all on public.trip_plan_items for all using (exists(select 1 from public.trip_plans p where p.id=trip_plan_id and p.user_id=auth.uid())) with check (exists(select 1 from public.trip_plans p where p.id=trip_plan_id and p.user_id=auth.uid()));

create table if not exists public.weather_snapshots (id uuid primary key default gen_random_uuid(), spot_id uuid references public.fishing_spots(id) on delete cascade, latitude double precision, longitude double precision, observed_at timestamptz not null default now(), source_url text, wind_speed_ms numeric, wind_direction_deg numeric, wave_height_m numeric, air_temp_c numeric, water_temp_c numeric, precipitation_probability numeric, raw_payload jsonb);
create index if not exists idx_weather_snapshots_spot_time on public.weather_snapshots(spot_id,observed_at desc);
alter table public.weather_snapshots enable row level security;
create policy weather_public_read on public.weather_snapshots for select using (true);

create table if not exists public.spot_safety_notes (id uuid primary key default gen_random_uuid(), spot_id uuid not null references public.fishing_spots(id) on delete cascade, category text not null check (category in ('access','current','cliff','boat','crowd','private_property','weather','equipment','other')), severity text not null default 'medium' check (severity in ('low','medium','high')), note text not null, source_id uuid references public.sources(id), last_verified_at timestamptz, created_at timestamptz not null default now());
alter table public.spot_safety_notes enable row level security;
create policy spot_safety_public_read on public.spot_safety_notes for select using (true);