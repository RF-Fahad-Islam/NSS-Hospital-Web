-- Add missing columns to doctors table
ALTER TABLE doctors 
ADD COLUMN IF NOT EXISTS is_doctor BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS education TEXT,
ADD COLUMN IF NOT EXISTS bio TEXT,
ADD COLUMN IF NOT EXISTS languages TEXT[],
ADD COLUMN IF NOT EXISTS available_days TEXT[];

-- Add foreign key relationship for branches
ALTER TABLE doctors 
DROP CONSTRAINT IF EXISTS doctors_branch_id_fkey;

ALTER TABLE doctors
ADD CONSTRAINT doctors_branch_id_fkey
FOREIGN KEY (branch_id)
REFERENCES branches(id)
ON DELETE CASCADE;

-- Update existing records to have defaults if needed
UPDATE doctors SET is_doctor = true WHERE is_doctor IS NULL;

-- Fix User Roles RLS recursion
DROP POLICY IF EXISTS "Users can view their own roles" ON user_roles;
CREATE POLICY "Users can view their own roles" ON user_roles FOR SELECT USING (user_id = auth.uid());
