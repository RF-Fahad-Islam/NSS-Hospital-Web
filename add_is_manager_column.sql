-- Add is_manager column to doctors table
alter table doctors 
add column if not exists is_manager boolean default false;

-- Add comment
comment on column doctors.is_manager is 'Flag to identify if the staff member is a manager';
