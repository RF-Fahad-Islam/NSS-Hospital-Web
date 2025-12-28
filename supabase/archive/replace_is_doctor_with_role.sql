-- Replace is_doctor boolean with role column
-- This allows identifying if a person is a doctor, staff, or manager

-- 1. Add the new role column
ALTER TABLE doctors 
ADD COLUMN IF NOT EXISTS role text DEFAULT 'staff';

-- 2. Migrate existing data (is_doctor = true -> 'doctor', is_doctor = false -> 'staff')
UPDATE doctors 
SET role = CASE 
  WHEN is_doctor = true THEN 'doctor'
  ELSE 'staff'
END;

-- 3. Drop the old is_doctor column
ALTER TABLE doctors DROP COLUMN IF EXISTS is_doctor;

-- 4. Add constraint to ensure only valid roles
ALTER TABLE doctors 
ADD CONSTRAINT doctors_role_check 
CHECK (role IN ('doctor', 'staff', 'management'));

-- 5. Add comment for clarity
COMMENT ON COLUMN doctors.role IS 'Role type: doctor, staff, or management';
