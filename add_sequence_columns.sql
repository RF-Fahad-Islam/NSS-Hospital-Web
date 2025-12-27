-- Add sequence columns to branches and doctors tables for display ordering

-- 1. Add sequence column to branches table
ALTER TABLE branches 
ADD COLUMN IF NOT EXISTS sequence integer DEFAULT 0;

-- 2. Add sequence column to doctors table
ALTER TABLE doctors 
ADD COLUMN IF NOT EXISTS sequence integer DEFAULT 0;

-- 3. Add comments
COMMENT ON COLUMN branches.sequence IS 'Display order for branches (lower numbers show first)';
COMMENT ON COLUMN doctors.sequence IS 'Display order for doctors (lower numbers show first)';

-- 4. Create indexes for better performance when ordering
CREATE INDEX IF NOT EXISTS idx_branches_sequence ON branches(sequence);
CREATE INDEX IF NOT EXISTS idx_doctors_sequence ON doctors(sequence);
