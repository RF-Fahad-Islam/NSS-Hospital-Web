-- 1. Drop the existing foreign key constraint (referencing branches.id)
ALTER TABLE doctors DROP CONSTRAINT IF EXISTS doctors_branch_id_fkey;

-- 2. Ensure branches.address is unique (required for it to be a foreign key target)
ALTER TABLE branches ADD CONSTRAINT branches_address_key UNIQUE (address);

-- 3. Data Migration: Update existing doctors' branch_id from ID to Address
-- This assumes current branch_ids match branches.id. 
-- It creates a temporary execution to switch values to address so they match the NEW constraint.
UPDATE doctors 
SET branch_id = branches.address 
FROM branches 
WHERE doctors.branch_id = branches.id;

-- 4. Add the new foreign key constraint (referencing branches.address)
ALTER TABLE doctors 
ADD CONSTRAINT doctors_branch_id_fkey 
FOREIGN KEY (branch_id) 
REFERENCES branches(address) 
ON UPDATE CASCADE;

-- 5. Comment for clarity
COMMENT ON COLUMN doctors.branch_id IS 'References branches(address) instead of id';
