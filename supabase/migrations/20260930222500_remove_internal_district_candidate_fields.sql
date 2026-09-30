-- District-level location metadata is not part of the product model.
-- Remove it from internal matching candidates as well as the public schema.
begin;
alter table internal.olta_atlasi_candidates drop column if exists district;
alter table internal.olta_atlasi_cards drop column if exists district;
alter table internal.photon_bulk_candidates drop column if exists district;
alter table internal.photon_verified_matches drop column if exists district;
commit;
