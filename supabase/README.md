# Database Setup

This directory contains the organized database files for setting up the Supabase project.

## Files

- **`01_schema.sql`**: Contains the complete schema definition (tables, indexes, RLS policies, functions). Run this first to create the database structure.
- **`02_seeds.sql`**: Contains initial seed data for branches, services, and doctors. Run this second to populate the database.
- **`archive/`**: Contains old migration and schema files that have been consolidated into the files above.

## How to Setup

1.  **Reset Database**: Go to your Supabase SQL Editor.
2.  **Run Schema**: Copy the content of `01_schema.sql` and run it. this will (re)create all tables.
    *   *Note*: If you have existing data you want to keep, DO NOT run this blindly. This is for a fresh setup or strict migration.
3.  **Run Seeds**: Copy the content of `02_seeds.sql` and run it to insert initial data.

## Admin Setup

To make a user an admin:
1.  Sign up the user in your application.
2.  Go to Supabase Auth -> Users and copy the `User UID`.
3.  Run the following SQL:
    ```sql
    INSERT INTO user_roles (user_id, role) VALUES ('<USER_UID>', 'admin');
    ```
