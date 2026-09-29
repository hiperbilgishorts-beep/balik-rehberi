create table if not exists public.source_registry (
  id uuid primary key default gen_random_uuid(),
  source_key text not null unique,
  name text not null,
  kind text not null check (kind in ('official','scientific','secondary','community')),
  priority integer not null default 50 check (priority between 0 and 100),
  base_url text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.data_claims (
  id uuid primary key default gen_random_uuid(),
  source_id uuid not null references public.source_registry(id) on delete restrict,
  entity_type text not null,
  entity_id uuid,
  claim_key text not null,
  claim_value jsonb not null,
  confidence text not null default 'unreviewed' check (confidence in ('unreviewed','low','medium','high','authoritative')),
  observed_at timestamptz not null default now(),
  verified_at timestamptz,
  verification_note text
);
create unique index if not exists idx_data_claims_identity
  on public.data_claims(source_id, entity_type, coalesce(entity_id, '00000000-0000-0000-0000-000000000000'::uuid), claim_key);
create index if not exists idx_data_claims_entity on public.data_claims(entity_type, entity_id);
create index if not exists idx_data_claims_source on public.data_claims(source_id);

create table if not exists public.data_ingestion_runs (
  id uuid primary key default gen_random_uuid(),
  source_id uuid references public.source_registry(id) on delete set null,
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  status text not null default 'running' check (status in ('running','completed','partial','failed')),
  records_seen integer not null default 0,
  records_accepted integer not null default 0,
  records_rejected integer not null default 0,
  records_needing_review integer not null default 0,
  error_message text
);

insert into public.source_registry (source_key,name,kind,priority,base_url) values
('tarim_orman_amator','Tarım ve Orman Bakanlığı','official',100,'https://www.tarimorman.gov.tr/'),
('resmi_gazete','Resmî Gazete','official',100,'https://www.resmigazete.gov.tr/'),
('dsi','Devlet Su İşleri Genel Müdürlüğü','official',95,'https://www.dsi.gov.tr/'),
('il_tarim','İl Tarım ve Orman Müdürlükleri','official',95,'https://www.tarimorman.gov.tr/'),
('fishbase','FishBase','scientific',90,'https://www.fishbase.se/'),
('oltaatlasi','Olta Atlası','secondary',65,'https://oltaatlasi.com/'),
('balikrotasi','Balık Rotası','secondary',60,'https://balikrotasi.com/')
on conflict (source_key) do update set name=excluded.name,kind=excluded.kind,priority=excluded.priority,base_url=excluded.base_url,updated_at=now();

-- These are internal ingestion/audit tables. Do not expose them to mobile clients.
alter table public.source_registry enable row level security;
alter table public.data_claims enable row level security;
alter table public.data_ingestion_runs enable row level security;
revoke all on public.source_registry, public.data_claims, public.data_ingestion_runs from anon, authenticated;
grant all on public.source_registry, public.data_claims, public.data_ingestion_runs to service_role;
