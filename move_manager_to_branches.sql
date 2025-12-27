-- 1. Remove manager_name from doctors table
ALTER TABLE doctors DROP COLUMN IF EXISTS manager_name;

-- 2. Add manager_name to branches table
ALTER TABLE branches 
ADD COLUMN IF NOT EXISTS manager_name text;

-- 3. Comment for clarity
COMMENT ON COLUMN branches.manager_name IS 'Name of the manager for this specific branch';
