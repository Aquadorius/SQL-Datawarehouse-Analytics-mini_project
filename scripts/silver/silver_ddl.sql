/*
Creates Table in the silver schema
to allow for inserting pivoted and joined data
from bronze schema
*/


IF OBJECT_ID('silver.joined_survey_reponse','U') IS NOT NULL
	DROP TABLE silver.joined_survey_reponse;

CREATE TABLE silver.joined_survey_reponse(
[Respondent ID] BIGINT,
[Start Date] DATETIME,
[End Date] DATETIME,
[Division Primary] VARCHAR(255),
[Division Secondary] VARCHAR(255),
Position VARCHAR(255),
Generation	VARCHAR (255),
Gender VARCHAR(255),
Tenure VARCHAR(255),
[Employment Type] VARCHAR(255),
[Question + Subquestion] VARCHAR(255),
Answer VARCHAR(255),
Question VARCHAR(255)
);

GO
