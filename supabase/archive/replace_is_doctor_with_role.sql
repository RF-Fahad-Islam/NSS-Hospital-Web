-- Robust migration script to switch from is_doctor to role column
-- Handles various states (is_doctor missing, role already exists, Bangla values present)

DO $$
BEGIN
    -- 1. Add 'role' column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'doctors' AND column_name = 'role') THEN
        ALTER TABLE doctors ADD COLUMN role text DEFAULT 'staff';
    END IF;

    -- 2. Update 'role' based on 'is_doctor' if 'is_doctor' still exists
    -- This migrates legacy boolean data
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'doctors' AND column_name = 'is_doctor') THEN
        UPDATE doctors 
        SET role = CASE 
            WHEN is_doctor = true THEN 'doctor' 
            ELSE 'staff' 
        END;
    END IF;

    -- 3. Fix any existing Bangla values to English
    -- This handles cases where a previous Bangla migration was run
    UPDATE doctors SET role = 'doctor' WHERE role = 'ডাক্তার';
    UPDATE doctors SET role = 'staff' WHERE role = 'স্টাফ';
    UPDATE doctors SET role = 'management' WHERE role = 'ম্যানেজমেন্ট';
    
    -- Ensure any nulls default to staff
    UPDATE doctors SET role = 'staff' WHERE role IS NULL;

    -- 4. Drop 'is_doctor' column if it exists
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'doctors' AND column_name = 'is_doctor') THEN
        ALTER TABLE doctors DROP COLUMN is_doctor;
    END IF;

    -- 5. Update/Reset the check constraint to enforce English roles
    -- We drop the constraint first to avoid errors if it exists with different rules
    ALTER TABLE doctors DROP CONSTRAINT IF EXISTS doctors_role_check;
    
    ALTER TABLE doctors 
    ADD CONSTRAINT doctors_role_check 
    CHECK (role IN ('doctor', 'staff', 'management'));
    
    -- 6. Add comment
    COMMENT ON COLUMN doctors.role IS 'Role type: doctor, staff, or management';

END $$;
