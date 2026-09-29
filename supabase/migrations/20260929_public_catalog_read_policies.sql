-- Read-only policies for public catalogue data consumed by the mobile app.
-- Do not change the separate import/administration tables here.
do $$
declare
  t text;
begin
  foreach t in array array[
    'water_bodies','provinces','districts','fish_species',
    'fish_methods','fish_baits','fishing_methods','baits','fish_seasons'
  ] loop
    if not exists (
      select 1 from pg_policies
      where schemaname='public' and tablename=t and policyname=t || '_public_read'
    ) then
      execute format('create policy %I on public.%I for select to anon, authenticated using (true)', t || '_public_read', t);
    end if;
  end loop;
end $$;

-- Only verified source metadata is public; pending sources remain internal for review.
do $$
begin
  if not exists (select 1 from pg_policies where schemaname='public' and tablename='sources' and policyname='sources_verified_public_read') then
    create policy sources_verified_public_read on public.sources
      for select to anon, authenticated using (verification_status = 'verified');
  end if;
end $$;

grant select on public.water_bodies, public.provinces, public.districts, public.fish_species,
  public.fish_water_bodies, public.fishing_rules, public.fish_methods, public.fish_baits,
  public.fishing_methods, public.baits, public.fish_seasons to anon, authenticated;
grant select on public.sources to anon, authenticated;
