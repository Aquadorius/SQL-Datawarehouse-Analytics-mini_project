
IF OBJECT_ID('gold.joined_survey_reponse','V') IS NOT NULL
	DROP VIEW gold.joined_survey_reponse;
GO
CREATE VIEW gold.joined_survey_reponse AS (

SELECT
jsr.*,
r.Respondents,
COALESCE(s.[Same Answer],0) AS [Same Answer]
FROM silver.joined_survey_reponse jsr
--How many People Responded to a Question. For instance 119 people responded to Question 1
LEFT JOIN (
			SELECT
			Question,
			COUNT(DISTINCT [Respondent ID]) Respondents
			FROM silver.joined_survey_reponse
			WHERE Answer is not null
			GROUP BY Question) r
ON r.Question=jsr.Question
----how many people had the same answer per question
LEFT JOIN (
			SELECT
			Question,
			Answer,
			count(Answer) [Same Answer]
			FROM silver.joined_survey_reponse
			GROUP BY Question,Answer)s
ON s.Question=jsr.Question and s.Answer=jsr.Answer
);

GO



CREATE OR ALTER PROCEDURE gold.ordered_survey_response AS
BEGIN
SELECT * FROM gold.joined_survey_reponse
ORDER BY  CAST(TRIM(RIGHT(Question,2)) AS INT);

END;

GO

EXEC gold.ordered_survey_response



