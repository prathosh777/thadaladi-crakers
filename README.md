# Thadaladi Crackers — remote admin setup (≈10 min)

The shop stays a static site (same hosting as now). Products, prices, photos and the WhatsApp number now live in Supabase (free plan is enough), so any change you make from the admin screen shows up for every customer on every device.

## 1. Create the Supabase project
1. supabase.com → New project (region: Mumbai / `ap-south-1`).
2. **SQL Editor → New query** → paste all of `supabase-setup.sql` → Run.
   Creates the `products` and `settings` tables, the `product-images` bucket, the security rules (everyone can read, only the logged-in admin can write) and seeds your current catalogue.

## 2. Create the admin login
**Authentication → Users → Add user → Create new user**: your email + a strong password, tick *Auto Confirm User*.

Then **Authentication → Sign In / Providers → Email** → turn **off** "Allow new users to sign up". This matters: otherwise anyone could register and get write access.

## 3. Connect the site
**Project Settings → API** → copy the Project URL and the `anon` public key into the top of the script in `index.html`:

```js
const SUPABASE_URL = "https://xxxx.supabase.co";
const SUPABASE_ANON_KEY = "eyJ...";
```
Upload `index.html` next to your existing product images (`vikas.jpeg`, etc.). Never put the `service_role` key in this file.

## 4. Use it
Tap the shop name 5 times → login → add / edit / delete products, upload photos, change the WhatsApp number or password. Works from any phone or computer.

## Notes
- Fix the placeholder prices after setup (several seeded items are ₹1–₹10, and Prathosh was ₹42,00,000 — seeded as ₹420).
- Images already in your folder (`./vikas.jpeg` …) keep working; new uploads go to Supabase Storage.
- Supabase free projects pause after a week of no activity; any visit to the shop counts as activity.
