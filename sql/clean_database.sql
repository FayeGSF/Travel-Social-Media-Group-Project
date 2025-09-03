-- For local database (This will be executed in local environment)
-- USE Wanderlog;

-- Note: For PythonAnywhere, the database TeamCHC$Wanderlog should already be selected
-- when executing this script.

-- Disable foreign key checks to allow clean deletion
SET FOREIGN_KEY_CHECKS = 0;

-- Truncate all tables
TRUNCATE TABLE `events`;
TRUNCATE TABLE `journeys`;
TRUNCATE TABLE `users`;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1; 