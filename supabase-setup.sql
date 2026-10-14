-- Thadaladi Crackers — Supabase schema
-- Run this once in: Supabase Dashboard → SQL Editor → New query → Run

-- ============ tables ============
create table if not exists public.products (
  id          uuid primary key default gen_random_uuid(),
  sort_order  bigint generated always as identity,
  name        text    not null check (length(trim(name)) > 0),
  category    text    not null check (length(trim(category)) > 0),
  unit        text    not null,
  price       numeric not null check (price > 0),
  mrp         numeric check (mrp is null or mrp > price),
  img         text,
  created_at  timestamptz not null default now()
);

create table if not exists public.settings (
  key   text primary key,
  value text not null
);

-- ============ row level security ============
-- Everyone can READ. Only a logged-in admin can write.
alter table public.products enable row level security;
alter table public.settings enable row level security;

drop policy if exists "products public read"  on public.products;
drop policy if exists "products admin insert" on public.products;
drop policy if exists "products admin update" on public.products;
drop policy if exists "products admin delete" on public.products;

create policy "products public read"  on public.products for select using (true);
create policy "products admin insert" on public.products for insert to authenticated with check (true);
create policy "products admin update" on public.products for update to authenticated using (true) with check (true);
create policy "products admin delete" on public.products for delete to authenticated using (true);

drop policy if exists "settings public read"  on public.settings;
drop policy if exists "settings admin insert" on public.settings;
drop policy if exists "settings admin update" on public.settings;

create policy "settings public read"  on public.settings for select using (true);
create policy "settings admin insert" on public.settings for insert to authenticated with check (true);
create policy "settings admin update" on public.settings for update to authenticated using (true) with check (true);

-- ============ image storage ============
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

drop policy if exists "images public read"  on storage.objects;
drop policy if exists "images admin insert" on storage.objects;
drop policy if exists "images admin update" on storage.objects;
drop policy if exists "images admin delete" on storage.objects;

create policy "images public read"  on storage.objects for select using (bucket_id = 'product-images');
create policy "images admin insert" on storage.objects for insert to authenticated with check (bucket_id = 'product-images');
create policy "images admin update" on storage.objects for update to authenticated using (bucket_id = 'product-images');
create policy "images admin delete" on storage.objects for delete to authenticated using (bucket_id = 'product-images');

-- ============ seed data (copied from the current catalogue) ============
-- NOTE: several prices below look like placeholders (e.g. 0 is rejected, 1, 3, 4200000).
-- Seeded values are corrected to a positive number so the constraints pass;
-- fix the real prices from the admin screen after setup.
insert into public.settings (key, value) values ('whatsapp_number', '918438014305')
on conflict (key) do nothing;

insert into public.products (name, category, unit, price, mrp, img) values
  ('Vikas',        'Ground Chakras', 'box of 10',  3,       400,  './vikas.jpeg'),
  ('Vikram',       'Ground Chakras', 'box of 5',   4,       480,  './vikram.png'),
  ('Sivaram',      'Ground Chakras', 'pack of 10', 1,       180,  './sivaram.jpg'),
  ('Siva prasath', 'Ground Chakras', 'pack of 5',  180,     null, './siva.jpg'),
  ('Sakiram',      'Sparklers',      'box of 10',  9,       110,  './sakiram.jpg'),
  ('Lokesh',       'Sparklers',      'box of 10',  1,       150,  './lokesh.png'),
  ('Saran',        'Sparklers',      'box of 10',  1,       null, './saran.jpg'),
  ('Kavin',        'Sparklers',      'box of 5',   110,     130,  './kavin.jpg'),
  ('Aravind',      'Aerial',         '1 piece',    5,       650,  './aravind.jpg'),
  ('Hemanth',      'Aerial',         '1 piece',    1,       1450, './hemanth.png'),
  ('Harish',       'Aerial',         'box of 10',  1,       null, './harish.png'),
  ('Prathosh',     'Aerial',         'box of 10',  420,     480,  './prathosh.jpeg'),
  ('Santhosh',     'Sound Crackers', 'box of 100', 10,      250,  './santhosh.jpg'),
  ('Karthick',     'Sound Crackers', '1 piece',    10,      null, './karthick.jpg'),
  ('Abhi',         'Gift Boxes',     '1 box',      1800,    null, 'https://images.unsplash.com/photo-1509557965875-b88c97052f0e?w=300&q=60'),
  ('Lokesh',       'Gift Boxes',     '1 box',      3200,    null, './lokesh.png'),
  ('Kavin',        'Gift Boxes',     '1 box',      650,     5000, './kavin.jpg');
