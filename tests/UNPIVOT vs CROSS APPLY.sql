/*
========================================================
Educational Comparison: UNPIVOT vs CROSS APPLY with VALUES
========================================================

Purpose: Demonstrate the technical differences between SQL unpivoting methods
Context: Survey data transformation showing real-world impact of method choice
Teaching Goal: Show when CROSS APPLY preserves data integrity better than UNPIVOT

Key Learning: Different SQL techniques have different data handling behaviors
             Understanding these differences is crucial for accurate analysis
========================================================
*/

-- ========================================================
-- METHOD 1: UNPIVOT (Standard SQL Approach)
-- ========================================================
/*
RESULT: 9,664 rows (Missing data due to NULL exclusion)
BEHAVIOR: Automatically excludes rows where the answer value is NULL
IMPACT: Data loss - questions with no responses disappear from analysis
USE CASE: When you want to analyze only completed responses
*/

SELECT 
    [Respondent ID],
    [Start Date],
    [End Date],
    [Identify which division you work in.-Response] AS division_primary,
    [Identify which division you work in.-Other (please specify)] AS division_secondary,
    [Which of the following best describes your position level?-Response] AS position,
    [Which generation are you apart of?-Response] AS generation,
    [Please select the gender in which you identify.-Response] AS gender,
    [Which duration range best aligns with your tenure at your company?-Response] AS tenure,
    [Which of the following best describes your employment type?-Response] AS employement_type,
    [question+subquestion],
    answer 
FROM bronze.survey_responses

-- UNPIVOT OPERATION: Converts columns to rows but EXCLUDES NULL values
UNPIVOT (
    answer FOR [question+subquestion] IN (
        [Question 1-Response],
        [Question 2-Response],
        [Question 3-Open-Ended Response],
        [Question 4-Response],
        [Question 4-Other (please specify)],
        [Question 5-Response 1],
        [Question 5-Response 2],
        [Question 5-Response 3],
        [Question 5-Response 4],
        [Question 5-Response 5],
        [Question 5-Response 6],
        -- ... [Additional 73 question columns] ...
        [Question 30-Response 1],
        [Question 30-Response 2],
        [Question 30-Response 3]
    )
) AS unpvt;

-- ========================================================
-- METHOD 2: CROSS APPLY with VALUES (Explicit Control Approach)
-- ========================================================
/*
RESULT: 17,028 rows (Complete data preservation)
BEHAVIOR: Includes ALL rows regardless of NULL values
IMPACT: Data integrity maintained - can analyze response patterns and gaps
USE CASE: When you need complete data including non-responses for analysis
*/

SELECT 
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
    v.[question+subquestion],
    v.answer
FROM bronze.survey_responses AS s

-- CROSS APPLY with VALUES: Manual unpivot operation with full control
CROSS APPLY (VALUES
    ('Question 1-Response', s.[Question 1-Response]),
    ('Question 2-Response', s.[Question 2-Response]),
    ('Question 3-Open-Ended Response', s.[Question 3-Open-Ended Response]),
    ('Question 4-Response', s.[Question 4-Response]),
    ('Question 4-Other (please specify)', s.[Question 4-Other (please specify)]),
    ('Question 5-Response 1', s.[Question 5-Response 1]),
    ('Question 5-Response 2', s.[Question 5-Response 2]),
    ('Question 5-Response 3', s.[Question 5-Response 3]),
    ('Question 5-Response 4', s.[Question 5-Response 4]),
    ('Question 5-Response 5', s.[Question 5-Response 5]),
    ('Question 5-Response 6', s.[Question 5-Response 6]),
    -- ... [Additional 73 question-value pairs] ...
    ('Question 30-Response 1', s.[Question 30-Response 1]),
    ('Question 30-Response 2', s.[Question 30-Response 2]),
    ('Question 30-Response 3', s.[Question 30-Response 3])
) AS v([question+subquestion], answer)
ORDER BY s.[Respondent ID], v.[question+subquestion];

/*
========================================================
EDUCATIONAL ANALYSIS: Why the Row Count Difference Matters
========================================================

Data Loss Impact:
- UNPIVOT: 9,664 rows (43% data loss)
- CROSS APPLY: 17,028 rows (complete data)

What's Missing with UNPIVOT:
✗ Questions that respondents skipped
✗ Optional questions left blank
✗ Survey completion patterns
✗ Response rate analysis capability

What's Preserved with CROSS APPLY:
✅ Complete response matrix
✅ Non-response patterns
✅ Survey completion analysis
✅ Statistical validity maintained

Real-World Impact:
1. Survey Analysis: Missing data affects completion rate calculations
2. Statistical Validity: Sample sizes appear artificially inflated
3. Bias Introduction: Only "engaged" respondents represented
4. Pattern Recognition: Cannot identify question difficulty or survey fatigue

Best Practices:
- Use UNPIVOT when: Analyzing only completed responses
- Use CROSS APPLY when: Need complete data integrity
- Consider filtering: Add WHERE clauses to CROSS APPLY for custom control
- Document choice: Always explain why you chose each method
========================================================
*/

-- ========================================================
-- OPTIONAL: Filtered CROSS APPLY (Best of Both Worlds)
-- ========================================================
/*
This approach gives you the control of CROSS APPLY with the clean results of UNPIVOT
You can explicitly filter out NULLs while maintaining full awareness of what's excluded
*/

SELECT 
    s.[Respondent ID],
    s.[Start Date],
    s.[End Date],
    s.[Identify which division you work in.-Response] AS division_primary,
    -- ... other dimension columns ...
    v.[question+subquestion],
    v.answer
FROM bronze.survey_responses AS s
CROSS APPLY (VALUES
    ('Question 1-Response', s.[Question 1-Response]),
    ('Question 2-Response', s.[Question 2-Response]),
    -- ... additional values ...
) AS v([question+subquestion], answer)
WHERE v.answer IS NOT NULL                    -- EXPLICIT NULL FILTERING
    AND LTRIM(RTRIM(v.answer)) <> '';        -- EXPLICIT EMPTY STRING FILTERING

/*
This gives you:
✅ Explicit control over what gets excluded
✅ Clear documentation of filtering logic  
✅ Ability to easily modify filtering rules
✅ Same row count as UNPIVOT but with conscious choice
*/
