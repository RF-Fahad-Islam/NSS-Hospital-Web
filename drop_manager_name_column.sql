-- Drop the manager_name column from branches table
-- This is no longer needed as we're now storing managers in the doctors table with role='management'

ALTER TABLE branches
DROP COLUMN IF EXISTS manager_name;
