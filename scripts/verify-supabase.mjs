const url = process.env.EXPO_PUBLIC_SUPABASE_URL;
const key = process.env.EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY || process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

if (!url || !key) {
  console.error('Supabase check failed: set EXPO_PUBLIC_SUPABASE_URL and EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY (or legacy EXPO_PUBLIC_SUPABASE_ANON_KEY).');
  process.exit(1);
}

const endpoint = new URL('/rest/v1/water_bodies?select=id&limit=1', url);
const response = await fetch(endpoint, {
  headers: { apikey: key, Authorization: `Bearer ${key}` },
});

if (!response.ok) {
  console.error(`Supabase REST check failed with HTTP ${response.status}.`);
  process.exit(1);
}

const rows = await response.json();
if (!Array.isArray(rows)) {
  console.error('Supabase REST check failed: response was not a row array.');
  process.exit(1);
}

console.log(`Supabase REST connection OK (HTTP ${response.status}); water_bodies query returned ${rows.length} row(s).`);
