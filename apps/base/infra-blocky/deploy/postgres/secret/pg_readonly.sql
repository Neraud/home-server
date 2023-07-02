-- Create Role
CREATE ROLE readaccess;

-- Assign Permission
GRANT CONNECT ON DATABASE blocky TO readaccess;
--GRANT USAGE ON SCHEMA public TO readaccess;
--GRANT SELECT ON ALL TABLES IN SCHEMA public TO readaccess;

-- Grant access to future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readaccess;

-- Create a final user with password
CREATE USER readonly WITH PASSWORD 'changeme';
GRANT readaccess TO readonly;
