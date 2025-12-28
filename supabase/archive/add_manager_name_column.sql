-- Add manager_name column to doctors table
alter table doctors 
add column if not exists manager_name text;

-- Add comment
comment on column doctors.manager_name is 'Name of the manager associated with this doctor/staff';
