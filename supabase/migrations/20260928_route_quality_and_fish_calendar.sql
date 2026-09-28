alter table public.water_bodies add column if not exists access_level text;
alter table public.water_bodies add column if not exists location_precision text;
alter table public.water_bodies add column if not exists source_url text;
alter table public.water_bodies add column if not exists last_verified_at timestamptz;
alter table public.water_bodies add column if not exists verification_notes text;

create table if not exists public.fish_activity_calendar (
  id uuid primary key default gen_random_uuid(),
  fish_id uuid not null references public.fish_species(id) on delete cascade,
  month smallint not null check (month between 1 and 12),
  activity_level text not null check (activity_level in ('low','medium','high')),
  depth_note text,
  method_note text,
  bait_note text,
  source_url text,
  last_verified_at timestamptz default now(),
  unique(fish_id, month)
);
create index if not exists idx_fish_activity_calendar_fish_month on public.fish_activity_calendar(fish_id, month);

comment on column public.water_bodies.verification_level is 'Source confidence, kept separate from fishing permission.';
comment on column public.water_bodies.location_precision is 'Exact, area, district or province-level location precision.';
comment on column public.water_bodies.access_level is 'General access context; not a legal fishing permission.';
