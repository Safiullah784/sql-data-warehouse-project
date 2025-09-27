/* 
=======================================
Create Database and Schemas
=======================================
Script Purpose:
This script creates a new database named 'DataWarehouse' after checking if it already exists.
If the database exists., it is dropped and recreated. Additionaly, the script sets up three 
schemas within the database: 'bronze', 'silver', 'gold'.

WARNING: 
Running this script will drop the entire 'DataWarehouse' database if it exists.
All data in the database will permenantly be deleted. Proceed with caution
and ensure you have proper backups before running this script.
*/

USE master;  -- Operate at the server level
GO

-- Drop database if it already exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DataWarehouse')
BEGIN
    -- Force single-user mode to terminate active sessions before drop
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END
GO

-- Create a fresh database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;  -- Switch context to the new database
GO

-- Create schemas for data layers
CREATE SCHEMA bronze;  -- Raw data
GO
CREATE SCHEMA silver;  -- Cleaned and Standardized data
GO
CREATE SCHEMA gold;    -- Analytics-ready data
GO
