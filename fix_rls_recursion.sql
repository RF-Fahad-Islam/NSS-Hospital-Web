-- Helper function to check if user is admin (avoids RLS recursion)
create or replace function public.is_admin(user_id uuid)
returns boolean
language plpgsql
security definer
as $$
begin
  return exists (
    select 1 from public.user_roles
    where user_roles.user_id = is_admin.user_id
    and user_roles.role = 'admin'
  );
end;
$$;

-- Optional: Grant execute permission
grant execute on function public.is_admin(uuid) to authenticated;
