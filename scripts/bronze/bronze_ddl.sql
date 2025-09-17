/*
========================================================
Survey Monkey Database Infrastructure Setup
========================================================

Purpose: Create clean database environment for Survey Monkey data analysis
Database: survey_monkey
Architecture: Bronze-Silver-Gold medallion architecture

Operations Performed:
- Database recreation (drop existing if present)
- Schema creation for data layers (bronze, silver, gold)
- Base table creation for raw survey data

Warning: This script will DROP the existing survey_monkey database if it exists
========================================================
*/

USE master;

-- DATABASE RECREATION: Drop existing database if present
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'survey_monkey')
BEGIN
    PRINT ('Database survey_monkey found. Proceeding to drop...');
    
    -- Step 1: Set database to single user mode to disconnect all users
    ALTER DATABASE survey_monkey SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    PRINT ('Database set to single user mode.');
    
    -- Step 2: Drop the database
    DROP DATABASE survey_monkey;
    PRINT ('Database survey_monkey dropped successfully.');
END
ELSE
BEGIN
    PRINT ('Database survey_monkey does not exist.');
END
GO

-- Step 3: Create the database
CREATE DATABASE survey_monkey;
GO
PRINT ('Database survey_monkey created successfully.');

-- Step 4: Switch to the new database
USE survey_monkey;
GO

-- Step 5: Create schemas
CREATE SCHEMA bronze;
GO
PRINT ('Schema bronze created successfully.');

GO
CREATE SCHEMA silver;
GO
PRINT ('Schema silver created successfully.');
GO
CREATE SCHEMA gold;
GO
PRINT ('Schema gold created successfully.');
GO
PRINT( '========================================');
PRINT ('Database and schemas setup completed successfully!');
PRINT ('Ready for table creation and data loading.');
PRINT ('========================================');


/*
========================================================
Survey Monkey Dataset Table Creation
========================================================

Purpose: Create table structure for imported Survey Monkey data
Data Source: edited_survey_monkey_dataset  (excel csv file)
Table: survey_responses

Note: Column names contain special characters and spaces from Survey Monkey
      Consider creating views with cleaner column names for analysis
========================================================
*/

-- Drop table if exists
IF OBJECT_ID('bronze.survey_responses', 'U') IS NOT NULL
    DROP TABLE bronze.survey_responses;

-- Create main survey responses table
CREATE TABLE bronze.survey_responses (
    -- Basic Response Information
    [Respondent ID] BIGINT,
    [Start Date] VARCHAR(50),
    [End Date] VARCHAR(50),
    [Email Address] VARCHAR(255),
    [First Name] VARCHAR(100),
    [Last Name] VARCHAR(100),
    [Custom Data 1] VARCHAR(255),
    
    -- Demographic Information
    [Identify which division you work in.-Response] VARCHAR(255),
    [Identify which division you work in.-Other (please specify)] VARCHAR(255),
    [Which of the following best describes your position level?-Response] VARCHAR(255),
    [Which generation are you apart of?-Response] VARCHAR(255),
    [Please select the gender in which you identify.-Response] VARCHAR(100),
    [Which duration range best aligns with your tenure at your company?-Response] VARCHAR(255),
    [Which of the following best describes your employment type?-Response] VARCHAR(255),
    
    -- Survey Questions 1-4
    [Question 1-Response] VARCHAR(255),
    [Question 2-Response] VARCHAR(255),
    [Question 3-Open-Ended Response] TEXT,
    [Question 4-Response] VARCHAR(255),
    [Question 4-Other (please specify)] VARCHAR(255),
    
    -- Question 5 (Multiple Responses)
    [Question 5-Response 1] VARCHAR(255),
    [Question 5-Response 2] VARCHAR(255),
    [Question 5-Response 3] VARCHAR(255),
    [Question 5-Response 4] VARCHAR(255),
    [Question 5-Response 5] VARCHAR(255),
    [Question 5-Response 6] VARCHAR(255),
    
    -- Question 6 (Multiple Responses)
    [Question 6-Response 1] VARCHAR(255),
    [Question 6-Response 2] VARCHAR(255),
    [Question 6-Response 3] VARCHAR(255),
    [Question 6-Response 4] VARCHAR(255),
    [Question 6-Response 5] VARCHAR(255),
    [Question 6-Response 6] VARCHAR(255),
    
    -- Question 7 (Multiple Responses)
    [Question 7-Response 1] VARCHAR(255),
    [Question 7-Unscheduled] VARCHAR(255),
    
    -- Question 8 (Multiple Responses)
    [Question 8-Response 1] VARCHAR(255),
    [Question 8-Response 2] VARCHAR(255),
    [Question 8-Response 3] VARCHAR(255),
    [Question 8-Response 4] VARCHAR(255),
    
    -- Question 9 (Multiple Responses)
    [Question 9-Response 1] VARCHAR(255),
    [Question 9-Response 2] VARCHAR(255),
    [Question 9-Response 3] VARCHAR(255),
    [Question 9-Response 4] VARCHAR(255),
    
    -- Question 10 (Multiple Responses)
    [Question 10-Response 1] VARCHAR(255),
    [Question 10-Response 2] VARCHAR(255),
    [Question 10-Response 3] VARCHAR(255),
    [Question 10-Response 4] VARCHAR(255),
    [Question 10-Response 5] VARCHAR(255),
    
    -- Questions 11-12
    [Question 11-Reponse 1] VARCHAR(255),     -- Note: Original typo "Reponse" maintained
    [Question 11-Response 2] VARCHAR(255),
    [Question 12-Response] VARCHAR(255),
    
    -- Questions 13-21
    [Question 13-Response] VARCHAR(255),
    [Question 14-Response] VARCHAR(255),
    [Question 15-Response] VARCHAR(255),
    [Question 16-Response] VARCHAR(255),
    [Question 17-Response] VARCHAR(255),
    [Question 18-Response] VARCHAR(255),
    [Question 19-Response] VARCHAR(255),
    [Question 19-Other (please specify)] VARCHAR(255),
    [Question 20-Response] VARCHAR(255),
    [Question 21-Response] VARCHAR(255),
    
    -- Question 22 (Multiple Responses)
    [Question 22-Reponse 1] VARCHAR(255),     -- Note: Original typo "Reponse" maintained
    [Question 22-Reponse 2] VARCHAR(255),     -- Note: Original typo "Reponse" maintained
    [Question 23-Response] VARCHAR(255),
    
    -- Question 24 (Multiple Responses)
    [Question 24-Response 1] VARCHAR(255),
    [Question 24-Response 2] VARCHAR(255),
    [Question 24-Response 3] VARCHAR(255),
    [Question 24-Response 4] VARCHAR(255),
    [Question 24-Response 5] VARCHAR(255),
    
    -- Question 25 (Multiple Responses)
    [Question 25-Response 1] VARCHAR(255),
    [Question 25-Response 2] VARCHAR(255),
    [Question 25-Response 3] VARCHAR(255),
    [Question 25-Response 4] VARCHAR(255),
    [Question 25-Response 5] VARCHAR(255),
    [Question 25-Response 6] VARCHAR(255),
    [Question 25-Response 7] VARCHAR(255),
    [Question 25-Response 8] VARCHAR(255),
    [Question 25-Response 9] VARCHAR(255),
    
    -- Question 26 (Multiple Responses)
    [Question 26-Response 1] VARCHAR(255),
    [Question 26-Response 2] VARCHAR(255),
    [Question 26-Response 3] VARCHAR(255),
    [Question 26-Response 4] VARCHAR(255),
    
    -- Question 27 (Multiple Responses)
    [Question 27-Response 1] VARCHAR(255),
    [Question 27-Response 2] VARCHAR(255),
    [Question 28-Response] VARCHAR(255),
    
    -- Question 29 (Multiple Responses - 14 total)
    [Question 29-Response 1] VARCHAR(255),
    [Question 29-Response 2] VARCHAR(255),
    [Question 29-Response 3] VARCHAR(255),
    [Question 29-Response 4] VARCHAR(255),
    [Question 29-Response 5] VARCHAR(255),
    [Question 29-Response 6] VARCHAR(255),
    [Question 29-Response 7] VARCHAR(255),
    [Question 29-Response 8] VARCHAR(255),
    [Question 29-Response 9] VARCHAR(255),
    [Question 29-Response 10] VARCHAR(255),
    [Question 29-Response 11] VARCHAR(255),
    [Question 29-Response 12] VARCHAR(255),
    [Question 29-Response 13] VARCHAR(255),
    [Question 29-Response 14] VARCHAR(255),
    
    -- Question 30 (Multiple Responses)
    [Question 30-Response 1] VARCHAR(255),
    [Question 30-Response 2] VARCHAR(255),
    [Question 30-Response 3] VARCHAR(255)
);
GO


