/*
========================================================
Silver Layer Survey Data Transformation Procedure
========================================================

Stored Procedure: silver.load_silver
Purpose: Transform wide survey data into normalized long format with question lookup
Database: survey_monkey
Target Table: silver.joined_survey_reponse

Overview:
---------
This procedure transforms the wide bronze survey data (1 row per respondent with 79+ columns)
into a normalized long format (multiple rows per respondent, one per question response).
It also enriches the data by joining with a questions lookup table to provide
question text alongside question codes.

Key Transformation:
- Wide format → Long format using CROSS APPLY with VALUES
- Adds question descriptions from bronze.questions_import lookup table
- Standardizes dimension column names
- Preserves all respondent demographics as repeated values

Dependencies:
- bronze.survey_responses (source survey data)
- bronze.questions_import (question text lookup)
- silver.joined_survey_reponse (target table must exist)

Warning: TRUNCATE operation removes all existing data
========================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    -- TIMING VARIABLES: Track execution performance
    DECLARE @start_time DATETIME2, @end_time DATETIME2, @batch_start_time DATETIME2, @batch_end_time DATETIME2;
    SET @batch_start_time=GETDATE();
    
    BEGIN TRY
        SET @start_time=GETDATE();
        
        -- PROGRESS MESSAGING: User feedback for execution monitoring
        PRINT('===============================');
        PRINT('LOADING THE SILVER LAYER');
        PRINT('===============================');

        -- DATA RESET: Clear existing silver table data
        PRINT('TRUNCATING TABLE: silver.joined_survey_reponse');
        IF OBJECT_ID('silver.joined_survey_reponse','U') IS NOT NULL
            TRUNCATE TABLE silver.joined_survey_reponse;
            
        PRINT('INSERTING DATA INTO TABLE: silver.joined_survey_reponse');

        -- MAIN ETL OPERATION: Transform and load survey data
        INSERT INTO silver.joined_survey_reponse(
            [Respondent ID],
            [Start Date],
            [End Date],
            [Division Primary],
            [Division Secondary],
            Position,
            Generation,
            Gender,
            Tenure,
            [Employment Type],
            [Question + Subquestion],
            Answer,
            Question
        )

        -- OUTER QUERY: Final result set with question descriptions
        SELECT 
            pd.[Respondent ID],
            pd.[Start Date],
            pd.[End Date],
            pd.division_primary,
            pd.division_secondary,
            pd.position,
            pd.generation,
            pd.gender,
            pd.tenure,
            pd.employement_type,
            pd.[Question+Subquestion],     -- Question code/identifier
            pd.answer,                     -- Response value
            qi.Question                    -- Question  from lookup
            
        FROM (
            -- ========================================================
            -- SUBQUERY 1 (ALIAS: pd): DATA TRANSFORMATION SUBQUERY
            -- Purpose: Transform wide survey format to long format
            -- Method: CROSS APPLY with VALUES to unpivot question columns because the alternative UNPIVOT ignores the null values
            -- ========================================================
            SELECT 
                -- DIMENSION COLUMNS: Respondent demographics (renamed for clarity)
                s.[Respondent ID],
                s.[Start Date],
                s.[End Date],
                s.[Identify which division you work in.-Response] AS division_primary,
                s.[Identify which division you work in.-Other (please specify)] AS division_secondary,
                s.[Which of the following best describes your position level?-Response] AS position,
                s.[Which generation are you apart of?-Response] AS generation,
                s.[Please select the gender in which you identify.-Response] AS gender,
                s.[Which duration range best aligns with your tenure at your company?-Response] AS tenure,
                s.[Which of the following best describes your employment type?-Response] AS employement_type,
                
                -- UNPIVOTED COLUMNS: Question identifier and response value
                v.[question+subquestion],   -- Question code (e.g., "Question 1-Response")
                v.answer                    -- Response value (e.g., "Answer 1", "Answer 2")
                
            FROM bronze.survey_responses AS s
            
            -- ========================================================
            -- CROSS APPLY with VALUES: UNPIVOT OPERATION
            -- Purpose: Convert 79+ question columns into rows
            -- Result: Each respondent gets 79+ rows (one per question)
            -- Structure: (question_name, response_value) pairs
            -- ========================================================
            CROSS APPLY (VALUES
                -- SURVEY QUESTIONS 1-4: Basic questions and open-ended
                ('Question 1-Response', s.[Question 1-Response]),
                ('Question 2-Response', s.[Question 2-Response]),
                ('Question 3-Open-Ended Response', s.[Question 3-Open-Ended Response]),
                ('Question 4-Response', s.[Question 4-Response]),
                ('Question 4-Other (please specify)', s.[Question 4-Other (please specify)]),
                
                -- QUESTION 5: Multiple choice with 6 sub-responses
                ('Question 5-Response 1', s.[Question 5-Response 1]),
                ('Question 5-Response 2', s.[Question 5-Response 2]),
                ('Question 5-Response 3', s.[Question 5-Response 3]),
                ('Question 5-Response 4', s.[Question 5-Response 4]),
                ('Question 5-Response 5', s.[Question 5-Response 5]),
                ('Question 5-Response 6', s.[Question 5-Response 6]),
                
                -- QUESTION 6: Multiple choice with 6 sub-responses
                ('Question 6-Response 1', s.[Question 6-Response 1]),
                ('Question 6-Response 2', s.[Question 6-Response 2]),
                ('Question 6-Response 3', s.[Question 6-Response 3]),
                ('Question 6-Response 4', s.[Question 6-Response 4]),
                ('Question 6-Response 5', s.[Question 6-Response 5]),
                ('Question 6-Response 6', s.[Question 6-Response 6]),
                
                -- QUESTIONS 7-8: Various response patterns
                ('Question 7-Response 1', s.[Question 7-Response 1]),
                ('Question 7-Unscheduled', s.[Question 7-Unscheduled]),
                ('Question 8-Response 1', s.[Question 8-Response 1]),
                ('Question 8-Response 2', s.[Question 8-Response 2]),
                ('Question 8-Response 3', s.[Question 8-Response 3]),
                ('Question 8-Response 4', s.[Question 8-Response 4]),
                
                -- QUESTIONS 9-10: Multiple sub-responses
                ('Question 9-Response 1', s.[Question 9-Response 1]),
                ('Question 9-Response 2', s.[Question 9-Response 2]),
                ('Question 9-Response 3', s.[Question 9-Response 3]),
                ('Question 9-Response 4', s.[Question 9-Response 4]),
                ('Question 10-Response 1', s.[Question 10-Response 1]),
                ('Question 10-Response 2', s.[Question 10-Response 2]),
                ('Question 10-Response 3', s.[Question 10-Response 3]),
                ('Question 10-Response 4', s.[Question 10-Response 4]),
                ('Question 10-Response 5', s.[Question 10-Response 5]),
                
                -- QUESTIONS 11-23: Mix of single and multiple responses
                ('Question 11-Reponse 1', s.[Question 11-Reponse 1]),        -- Note: Typo preserved
                ('Question 11-Response 2', s.[Question 11-Response 2]),
                ('Question 12-Response', s.[Question 12-Response]),
                ('Question 13-Response', s.[Question 13-Response]),
                ('Question 14-Response', s.[Question 14-Response]),
                ('Question 15-Response', s.[Question 15-Response]),
                ('Question 16-Response', s.[Question 16-Response]),
                ('Question 17-Response', s.[Question 17-Response]),
                ('Question 18-Response', s.[Question 18-Response]),
                ('Question 19-Response', s.[Question 19-Response]),
                ('Question 19-Other (please specify)', s.[Question 19-Other (please specify)]),
                ('Question 20-Response', s.[Question 20-Response]),
                ('Question 21-Response', s.[Question 21-Response]),
                ('Question 22-Reponse 1', s.[Question 22-Reponse 1]),        -- Note: Typo preserved
                ('Question 22-Reponse 2', s.[Question 22-Reponse 2]),        -- Note: Typo preserved
                ('Question 23-Response', s.[Question 23-Response]),
                
                -- QUESTIONS 24-25: Multiple response arrays
                ('Question 24-Response 1', s.[Question 24-Response 1]),
                ('Question 24-Response 2', s.[Question 24-Response 2]),
                ('Question 24-Response 3', s.[Question 24-Response 3]),
                ('Question 24-Response 4', s.[Question 24-Response 4]),
                ('Question 24-Response 5', s.[Question 24-Response 5]),
                ('Question 25-Response 1', s.[Question 25-Response 1]),
                ('Question 25-Response 2', s.[Question 25-Response 2]),
                ('Question 25-Response 3', s.[Question 25-Response 3]),
                ('Question 25-Response 4', s.[Question 25-Response 4]),
                ('Question 25-Response 5', s.[Question 25-Response 5]),
                ('Question 25-Response 6', s.[Question 25-Response 6]),
                ('Question 25-Response 7', s.[Question 25-Response 7]),
                ('Question 25-Response 8', s.[Question 25-Response 8]),
                ('Question 25-Response 9', s.[Question 25-Response 9]),
                
                -- QUESTIONS 26-28: Continued response patterns
                ('Question 26-Response 1', s.[Question 26-Response 1]),
                ('Question 26-Response 2', s.[Question 26-Response 2]),
                ('Question 26-Response 3', s.[Question 26-Response 3]),
                ('Question 26-Response 4', s.[Question 26-Response 4]),
                ('Question 27-Response 1', s.[Question 27-Response 1]),
                ('Question 27-Response 2', s.[Question 27-Response 2]),
                ('Question 28-Response', s.[Question 28-Response]),
                
                -- QUESTION 29: Largest response array (14 sub-responses)
                ('Question 29-Response 1', s.[Question 29-Response 1]),
                ('Question 29-Response 2', s.[Question 29-Response 2]),
                ('Question 29-Response 3', s.[Question 29-Response 3]),
                ('Question 29-Response 4', s.[Question 29-Response 4]),
                ('Question 29-Response 5', s.[Question 29-Response 5]),
                ('Question 29-Response 6', s.[Question 29-Response 6]),
                ('Question 29-Response 7', s.[Question 29-Response 7]),
                ('Question 29-Response 8', s.[Question 29-Response 8]),
                ('Question 29-Response 9', s.[Question 29-Response 9]),
                ('Question 29-Response 10', s.[Question 29-Response 10]),
                ('Question 29-Response 11', s.[Question 29-Response 11]),
                ('Question 29-Response 12', s.[Question 29-Response 12]),
                ('Question 29-Response 13', s.[Question 29-Response 13]),
                ('Question 29-Response 14', s.[Question 29-Response 14]),
                
                -- QUESTION 30: Final question with 3 responses
                ('Question 30-Response 1', s.[Question 30-Response 1]),
                ('Question 30-Response 2', s.[Question 30-Response 2]),
                ('Question 30-Response 3', s.[Question 30-Response 3])
                
            ) AS v([Question+Subquestion], answer)  -- Column aliases for the VALUES output
            
        ) AS pd  -- Subquery alias: "processed_data"

        -- ========================================================
        -- LEFT JOIN: QUESTION LOOKUP ENRICHMENT
        -- Purpose: Add question text descriptions to question codes
        -- Challenge: Handle spacing differences between tables
        -- ========================================================
        LEFT JOIN bronze.questions_import qi
            -- JOIN CONDITION with TEXT TRANSFORMATION:
            -- Problem: survey_responses has "Question 1-Response"
            --         questions_import has "Question 1 - Response" (extra spaces)
            -- Solution: Replace ' - ' with '-' to match formats
            ON pd.[Question+Subquestion] = REPLACE(qi.[Question + Subquestion], ' - ', '-');
        
        -- PERFORMANCE TRACKING: Record completion time
        SET @end_time=GETDATE();
        PRINT('Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds');
        
    END TRY
    BEGIN CATCH
        -- ERROR HANDLING: Capture and display error details
        PRINT('===========================================');
        PRINT('ERROR OCCURRED DURING LOADING SILVER LAYER');  -- Note: Says BRONZE but should be SILVER
        PRINT('ERROR MESSAGE: ' + ERROR_MESSAGE());
        PRINT('ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
        PRINT('ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR));
    END CATCH
    
    -- BATCH COMPLETION: Calculate total execution time
    SET @batch_end_time=GETDATE();
    PRINT('=======================================');
    PRINT('TOTAL LOADING TIME FOR SILVER LAYER: ' + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds');
    PRINT('=======================================');
END;

GO

-- PROCEDURE EXECUTION: Run the silver layer transformation
EXEC silver.load_silver;

/*
========================================================
Code Structure Summary:
========================================================

1. MAIN INSERT STATEMENT
   └── SELECT FROM subquery (pd) + lookup join

2. SUBQUERY (pd): Data Transformation
   ├── SELECT respondent dimensions
   └── CROSS APPLY with VALUES (unpivot operation)
       └── 79+ question-response pairs

3. LEFT JOIN: Question Enrichment  
   └── bronze.questions_import with text formatting

Data Flow:
----------
Input:  Wide format (1 row per respondent, 79+ columns)
        ↓
Step 1: CROSS APPLY transforms to long format
        ↓  
Step 2: LEFT JOIN adds question descriptions*/
