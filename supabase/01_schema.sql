-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- 1. Create Branches Table
create table branches (
  id text not null,
  name text not null,
  address text primary key,
  phone text not null,
  email text not null,
  map_url text not null,
  image text not null,
  manager_name text,
  sequence integer default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

comment on column branches.manager_name is 'Name of the manager for this specific branch';
comment on column branches.sequence is 'Display order for branches (lower numbers show first)';
create index idx_branches_sequence on branches(sequence);

-- 2. Create Doctors Table
create table doctors (
  id text primary key,
  name text not null,
  specialty text not null,
  experience text not null,
  rating numeric not null,
  image text not null,
  branch_id text not null references branches(address) on delete cascade,
  education text,
  bio text,
  languages text[] not null,
  available_days text[] not null,
  role text not null default 'stuff' check (role in ('doctor', 'stuff', 'management')),
  sequence integer default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

comment on column doctors.branch_id is 'References branches(address) - the primary key of branches table';
comment on column doctors.role is 'Role type: doctor, stuff, or management';
comment on column doctors.sequence is 'Display order for doctors (lower numbers show first)';
create index idx_doctors_sequence on doctors(sequence);

-- 3. Create Services Table
create table services (
  id text primary key,
  title text not null,
  description text not null,
  full_description text not null,
  color text not null,
  bg_color text not null,
  features text[] not null,
  icon_name text not null, -- Storing icon name string instead of component
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 4. Create Gallery Items Table
create table gallery_items (
  id serial primary key,
  src text not null,
  alt text not null,
  category text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 5. Create Appointments Table
create table if not exists appointments (
  id uuid default uuid_generate_v4() primary key,
  patient_name text not null,
  patient_email text not null,
  patient_phone text not null,
  doctor_name text,
  branch_name text,
  service text,
  appointment_date date not null,
  appointment_time text not null,
  message text,
  status text default 'pending',
  is_read boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 6. Create User Roles table for Admin access
create table if not exists user_roles (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users not null,
  role text not null check (role in ('admin', 'staff', 'user')),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 7. Create Analytics Table
create table if not exists analytics (
  id uuid default uuid_generate_v4() primary key,
  page_path text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);


-- Enable Row Level Security (RLS)
alter table doctors enable row level security;
alter table services enable row level security;
alter table branches enable row level security;
alter table gallery_items enable row level security;
alter table appointments enable row level security;
alter table user_roles enable row level security;
alter table analytics enable row level security;

-- Create Policies (Public Read Access for Site Content)
create policy "Public doctors are viewable by everyone" on doctors for select using (true);
create policy "Public services are viewable by everyone" on services for select using (true);
create policy "Public branches are viewable by everyone" on branches for select using (true);
create policy "Public gallery items are viewable by everyone" on gallery_items for select using (true);

-- Admin CRUD Policies
-- Helper function to check if user is admin is not used directly in policies to avoid complexity, 
-- we use direct EXISTS queries as per original schema.

-- Doctors Policies
create policy "Admins can insert doctors" on doctors for insert with check (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);
create policy "Admins can update doctors" on doctors for update using (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);
create policy "Admins can delete doctors" on doctors for delete using (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);

-- Services Policies
create policy "Admins can insert services" on services for insert with check (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);
create policy "Admins can update services" on services for update using (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);
create policy "Admins can delete services" on services for delete using (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);

-- Branches Policies
create policy "Admins can insert branches" on branches for insert with check (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);
create policy "Admins can update branches" on branches for update using (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);
create policy "Admins can delete branches" on branches for delete using (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);

-- Gallery Items Policies
create policy "Admins can insert gallery items" on gallery_items for insert with check (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);
create policy "Admins can update gallery items" on gallery_items for update using (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);
create policy "Admins can delete gallery items" on gallery_items for delete using (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);

-- Appointments Policies
create policy "Anyone can insert appointments" on appointments for insert with check (true);
create policy "Admins can view all appointments" on appointments for select using (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);
create policy "Admins can update appointments" on appointments for update using (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);

-- Analytics Policies
create policy "Public can insert analytics" on analytics for insert with check (true);
create policy "Admins can view analytics" on analytics for select using (
  exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);

-- User Roles Policies
-- This avoids infinite recursion by not querying user_roles within a user_roles policy
create policy "Users can view their own roles" on user_roles for select using (
  user_id = auth.uid()
);

-- STORAGE BUCKET SETUP
insert into storage.buckets (id, name, public)
values ('images', 'images', true)
on conflict (id) do nothing;

create policy "Public Access" on storage.objects for select using ( bucket_id = 'images' );

create policy "Admin Upload" on storage.objects for insert with check (
  bucket_id = 'images' and exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);

create policy "Admin Update" on storage.objects for update using (
  bucket_id = 'images' and exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);

create policy "Admin Delete" on storage.objects for delete using (
  bucket_id = 'images' and exists (select 1 from user_roles where user_roles.user_id = auth.uid() and user_roles.role = 'admin')
);
