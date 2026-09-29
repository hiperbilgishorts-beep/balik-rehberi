# Meralar feature: product and data design (2026-09-29)

## Review of Olta Atlasi

The public `/meralar/` page presents a nationwide directory with filters for province, district, water type, region, confidence, and reported fish. Its rendered page reports 1,441 route records, with 288 strong-verification and 1,153 general-location records. Individual route pages expose a summary, general coordinates (when available), water type, confidence, access notes, source and last-checked date. The site explicitly distinguishes a general map location from exact shore access or permission to fish.

Use the site as a secondary corroboration source and a reference for UX. Do not bulk-copy its catalogue or treat its content as authoritative without checking each candidate against the waterbody name, province/district, water type, and a primary or independent geographic source. Preserve the source URL and retrieval date. A missing coordinate should remain missing rather than be guessed.

## Proposed Balık Rehberi experience

Add a dedicated **Meralar** entry beside Harita, Su Kaynakları, and Balık Rehberi.

### Directory screen
- Search by name, province, district, and water type.
- Filters: province/district, water type (sea, lake, reservoir, pond, river/stream), and verification confidence.
- List cards show name, area, linked waterbody, concise description, water type, confidence, and last checked date.
- Map pins represent a broad water/area location, not a fishing-access point.
- Empty/error states and pagination should work with the full dataset.

### Mera detail screen
- Name, province/district, water type, general-location coordinates and a short overview.
- Source links and last-checked date visible to users.
- Confidence/status label with a plain-language explanation.
- Optional reported fish species only where a sourced relationship exists.
- Access/permission shown as **unknown** unless supported by current evidence; never infer permission from a coordinate.
- Map-app links may open the general coordinate but must not label it as a safe or public entry point.

## Data model

Do not repurpose `public.fishing_spots`: it models more specific spots and includes access notes. Introduce a separate `public.fishing_areas` table for broad-area/mera records, with:
- UUID id, name, slug, short description
- nullable `water_body_id`, `province_id`, `district_id`
- nullable general `latitude` and `longitude`
- `water_type`, `location_precision` (default `general_area`)
- `access_status` and `fishing_status` (default `unknown`)
- `verification_level`, `verification_status`, `source_id`, `source_reference`, `source_checked_at`, `last_verified_at`
- created/updated timestamps

Enable RLS. Public clients should have read-only access to published records; inserts/updates should be limited to a trusted admin workflow. Do not expose private review queues.

## Coordinate verification workflow

1. Candidate discovery from Olta Atlasi, OpenStreetMap/OSM-derived gazetteers, GeoNames, and official water-resources sources.
2. Normalize name, compare water type, and confirm province/district. A name-only match is not enough.
3. Store candidate evidence in a review table; retain the source URL and retrieval timestamp.
4. Accept coordinates only when identity and geographic context agree. Record whether a pin is a dam structure, reservoir/general water feature, lake centroid, or broad area.
5. Do not change fishing permission, public access, or exact fishing-spot fields during a coordinate-only verification.
6. Run post-import checks for duplicate names, coordinates outside Turkey, missing provenance, and duplicate/near-duplicate pins.

## Phased delivery

1. **MVP:** read-only Meralar directory and detail pages backed by `fishing_areas`, with search, basic filters, source/confidence badges, and broad-location map links.
2. **Data enrichment:** match existing waterbody records to mera records without overwriting stronger coordinates; log provenance and confidence.
3. **Community contribution:** suggested corrections, photos, and reports enter moderation first; never publish user-submitted coordinates as verified automatically.
4. **Later:** saved meralar, seasonal notes, weather, and sourced fish-species relationships.

## Current coordinate coverage snapshot

At the time of this review, `public.water_bodies` has 1,695 records; 798 have both latitude and longitude (47.1%), and 897 are missing at least one coordinate. This is a coordinate-coverage metric only, not an overall project-completion percentage.
