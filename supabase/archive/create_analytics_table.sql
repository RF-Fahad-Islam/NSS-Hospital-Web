-- Create analytics table
create table if not exists analytics (
  id uuid default uuid_generate_v4() primary key,
  page_path text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS
alter table analytics enable row level security;

-- Policies
-- Allow anyone (anon users) to insert tracking data
create policy "Anyone can insert analytics" on analytics for insert with check (true);

-- Allow only admins to view analytics data
create policy "Admins can view analytics" on analytics for select using (
  exists (
    select 1 from user_roles
    where user_roles.user_id = auth.uid()
    and user_roles.role = 'admin'
  )
);
