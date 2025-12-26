-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Create Doctors Table
create table doctors (
  id text primary key,
  name text not null,
  specialty text not null,
  experience text not null,
  rating numeric not null,
  image text not null,
  branch_id text not null,
  education text not null,
  bio text not null,
  languages text[] not null,
  available_days text[] not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create Services Table
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

-- Create Branches Table
create table branches (
  id text primary key,
  name text not null,
  address text not null,
  phone text not null,
  email text not null,
  map_url text not null,
  image text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create Gallery Items Table
create table gallery_items (
  id serial primary key,
  src text not null,
  alt text not null,
  category text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create Appointments Table (if not already created)
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

-- Create User Roles table for Admin access
create table if not exists user_roles (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users not null,
  role text not null check (role in ('admin', 'staff', 'user')),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security (RLS)
alter table doctors enable row level security;
alter table services enable row level security;
alter table branches enable row level security;
alter table gallery_items enable row level security;
alter table appointments enable row level security;
alter table user_roles enable row level security;

-- Create Policies (Public Read Access for Site Content)
create policy "Public doctors are viewable by everyone" on doctors for select using (true);
create policy "Public services are viewable by everyone" on services for select using (true);
create policy "Public branches are viewable by everyone" on branches for select using (true);
create policy "Public gallery items are viewable by everyone" on gallery_items for select using (true);

-- Create Policies (Appointments: Public Insert, Admin Read/Update)
create policy "Anyone can insert appointments" on appointments for insert with check (true);
create policy "Admins can view all appointments" on appointments for select using (
  exists (
    select 1 from user_roles
    where user_roles.user_id = auth.uid()
    and user_roles.role = 'admin'
  )
);
create policy "Admins can update appointments" on appointments for update using (
  exists (
    select 1 from user_roles
    where user_roles.user_id = auth.uid()
    and user_roles.role = 'admin'
  )
);

-- Create Policies (User Roles: Admin Read Only)
create policy "Admins can view user roles" on user_roles for select using (
  exists (
    select 1 from user_roles
    where user_roles.user_id = auth.uid()
    and user_roles.role = 'admin'
  )
);

-- STORAGE BUCKET SETUP
-- Note: You can run this, but sometimes creating buckets via SQL requires super admin. 
-- It is often easier to create the bucket 'images' in the Supabase Dashboard > Storage.

insert into storage.buckets (id, name, public)
values ('images', 'images', true)
on conflict (id) do nothing;

-- Storage Policies for 'images' bucket
create policy "Public Access"
  on storage.objects for select
  using ( bucket_id = 'images' );

create policy "Admin Upload"
  on storage.objects for insert
  with check (
    bucket_id = 'images' 
    and exists (
      select 1 from user_roles
      where user_roles.user_id = auth.uid()
      and user_roles.role = 'admin'
    )
  );
