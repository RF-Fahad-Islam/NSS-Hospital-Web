-- Add is_doctor column to doctors table
ALTER TABLE doctors 
ADD COLUMN IF NOT EXISTS is_doctor BOOLEAN DEFAULT true;

-- Update existing records to be doctors by default
UPDATE doctors SET is_doctor = true WHERE is_doctor IS NULL;
