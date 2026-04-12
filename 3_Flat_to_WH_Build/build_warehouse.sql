-- Master build script for data warehouse and mart pipeline
-- This file runs all steps in sequence to build the complete warehouse and marts
--
-- Usage (Local):
--   Run this script with: duckdb flat_wh.duckdb -c ".read build_warehouse.sql"
--
-- Usage (MotherDuck):
--   Run CREATE DATABASE flat_wh; to create the DB in MotherDuck
--   Run this script with: duckdb "md:flat_wh" -c ".read build_warehouse.sql"
--   Note: Ensure MOTHERDUCK_TOKEN is already exported in your environment
--   Uncomment the ATTACH statement below to connect to MotherDuck
--
-- Note: The database file "flat_wh.duckdb" will be created if it doesn't exist (local only)
--       To use a different database file, replace "flat_wh.duckdb" with your filename

-- Uncomment below to connect to MotherDuck after building locally:
-- ATTACH 'md:flat_wh';
-- Note: Ensure MOTHERDUCK_TOKEN is already exported in your environment

-- Step 0: Load data from Google Cloud Storage
.read 00_load_data.sql

-- Step 1: Create all tables
.read 01_create_tables.sql

-- Step 2: Populate company dimension
.read 02_populate_company_dim.sql

-- Step 3: Populate skills dimension
.read 03_populate_skills_dim.sql

-- Step 4: Populate fact table
.read 04_populate_fact_table.sql

-- Step 5: Populate bridge table
.read 05_populate_bridge_table.sql

-- Step 6: Verify star schema
.read 06_verify_schema.sql

-- Final summary
SELECT 'Warehouse build completed successfully!' as status;