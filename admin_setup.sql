-- OPTION 1: GRANT ADMIN ACCESS TO AN EXISTING USER
-- 1. Sign up a user in the app at /admin or in Supabase Auth Dashboard.
-- 2. Copy their User UID (e.g., 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11')
-- 3. Run this command, replacing the ID:

INSERT INTO user_roles (user_id, role)
VALUES ('REPLACE_WITH_USER_UUID', 'admin');


-- OPTION 2: CHECK CURRENT ROLES
SELECT * FROM user_roles;


-- OPTION 3: REMOVE ADMIN ACCESS
-- DELETE FROM user_roles WHERE user_id = 'REPLACE_WITH_USER_UUID';
