-- Final targeted performance fixes from Supabase advisors.
CREATE INDEX IF NOT EXISTS idx_favorite_spots_spot_id ON public.favorite_spots (spot_id);
CREATE INDEX IF NOT EXISTS idx_fish_baits_bait_id ON public.fish_baits (bait_id);
CREATE INDEX IF NOT EXISTS idx_fish_methods_method_id ON public.fish_methods (method_id);
CREATE INDEX IF NOT EXISTS idx_fishing_rules_district_id ON public.fishing_rules (district_id);
CREATE INDEX IF NOT EXISTS idx_trip_plan_items_spot_id ON public.trip_plan_items (spot_id);
CREATE INDEX IF NOT EXISTS idx_water_access_info_source_id ON public.water_access_info (source_id);
CREATE INDEX IF NOT EXISTS idx_water_features_source_id ON public.water_features (source_id);

ALTER POLICY favorite_spots_owner_all ON public.favorite_spots
  USING ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);
ALTER POLICY spot_reports_owner_insert ON public.spot_reports
  WITH CHECK ((select auth.uid()) = user_id);
ALTER POLICY spot_reports_owner_update ON public.spot_reports
  USING ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);
ALTER POLICY spot_reports_public_read ON public.spot_reports
  USING ((status = 'published'::text) OR ((select auth.uid()) = user_id));
ALTER POLICY trip_plans_owner_all ON public.trip_plans
  USING ((select auth.uid()) = user_id)
  WITH CHECK ((select auth.uid()) = user_id);
ALTER POLICY trip_plan_items_owner_all ON public.trip_plan_items
  USING (EXISTS (
    SELECT 1 FROM public.trip_plans p
    WHERE p.id = trip_plan_items.trip_plan_id
      AND p.user_id = (select auth.uid())
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.trip_plans p
    WHERE p.id = trip_plan_items.trip_plan_id
      AND p.user_id = (select auth.uid())
  ));
