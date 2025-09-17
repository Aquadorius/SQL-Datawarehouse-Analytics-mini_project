--Unpivot is not recommended as it ignores the null values and the output rows are reduceed to 9664
SELECT 
[Respondent ID]
,[Start Date]
,[End Date]
,[Identify which division you work in.-Response] AS division_primary
,[Identify which division you work in.-Other (please specify)] AS division_secondary
,[Which of the following best describes your position level?-Response] AS position
,[Which generation are you apart of?-Response] AS generation
,[Please select the gender in which you identify.-Response] AS gender
,[Which duration range best aligns with your tenure at your company?-Response] tenure
,[Which of the following best describes your employment type?-Response] employement_type,

[question+subquestion],
answer FROM bronze.survey_responses

	  UNPIVOT (

	  answer FOR [question+subquestion] IN (
      [Question 1-Response]
      ,[Question 2-Response]
      ,[Question 3-Open-Ended Response]
      ,[Question 4-Response]
      ,[Question 4-Other (please specify)]
      ,[Question 5-Response 1]
      ,[Question 5-Response 2]
      ,[Question 5-Response 3]
      ,[Question 5-Response 4]
      ,[Question 5-Response 5]
      ,[Question 5-Response 6]
      ,[Question 6-Response 1]
      ,[Question 6-Response 2]
      ,[Question 6-Response 3]
      ,[Question 6-Response 4]
      ,[Question 6-Response 5]
      ,[Question 6-Response 6]
      ,[Question 7-Response 1]
      ,[Question 7-Unscheduled]
      ,[Question 8-Response 1]
      ,[Question 8-Response 2]
      ,[Question 8-Response 3]
      ,[Question 8-Response 4]
      ,[Question 9-Response 1]
      ,[Question 9-Response 2]
      ,[Question 9-Response 3]
      ,[Question 9-Response 4]
      ,[Question 10-Response 1]
      ,[Question 10-Response 2]
      ,[Question 10-Response 3]
      ,[Question 10-Response 4]
      ,[Question 10-Response 5]
      ,[Question 11-Reponse 1]
      ,[Question 11-Response 2]
      ,[Question 12-Response]
      ,[Question 13-Response]
      ,[Question 14-Response]
      ,[Question 15-Response]
      ,[Question 16-Response]
      ,[Question 17-Response]
      ,[Question 18-Response]
      ,[Question 19-Response]
      ,[Question 19-Other (please specify)]
      ,[Question 20-Response]
      ,[Question 21-Response]
      ,[Question 22-Reponse 1]
      ,[Question 22-Reponse 2]
      ,[Question 23-Response]
      ,[Question 24-Response 1]
      ,[Question 24-Response 2]
      ,[Question 24-Response 3]
      ,[Question 24-Response 4]
      ,[Question 24-Response 5]
      ,[Question 25-Response 1]
      ,[Question 25-Response 2]
      ,[Question 25-Response 3]
      ,[Question 25-Response 4]
      ,[Question 25-Response 5]
      ,[Question 25-Response 6]
      ,[Question 25-Response 7]
      ,[Question 25-Response 8]
      ,[Question 25-Response 9]
      ,[Question 26-Response 1]
      ,[Question 26-Response 2]
      ,[Question 26-Response 3]
      ,[Question 26-Response 4]
      ,[Question 27-Response 1]
      ,[Question 27-Response 2]
      ,[Question 28-Response]
      ,[Question 29-Response 1]
      ,[Question 29-Response 2]
      ,[Question 29-Response 3]
      ,[Question 29-Response 4]
      ,[Question 29-Response 5]
      ,[Question 29-Response 6]
      ,[Question 29-Response 7]
      ,[Question 29-Response 8]
      ,[Question 29-Response 9]
      ,[Question 29-Response 10]
      ,[Question 29-Response 11]
      ,[Question 29-Response 12]
      ,[Question 29-Response 13]
      ,[Question 29-Response 14]
      ,[Question 30-Response 1]
      ,[Question 30-Response 2]
      ,[Question 30-Response 3])) AS unpvt



--Using cross apply we are preserving the null values and the out put rows are 17028
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
    ('Question 6-Response 1', s.[Question 6-Response 1]),
    ('Question 6-Response 2', s.[Question 6-Response 2]),
    ('Question 6-Response 3', s.[Question 6-Response 3]),
    ('Question 6-Response 4', s.[Question 6-Response 4]),
    ('Question 6-Response 5', s.[Question 6-Response 5]),
    ('Question 6-Response 6', s.[Question 6-Response 6]),
    ('Question 7-Response 1', s.[Question 7-Response 1]),
    ('Question 7-Unscheduled', s.[Question 7-Unscheduled]),
    ('Question 8-Response 1', s.[Question 8-Response 1]),
    ('Question 8-Response 2', s.[Question 8-Response 2]),
    ('Question 8-Response 3', s.[Question 8-Response 3]),
    ('Question 8-Response 4', s.[Question 8-Response 4]),
    ('Question 9-Response 1', s.[Question 9-Response 1]),
    ('Question 9-Response 2', s.[Question 9-Response 2]),
    ('Question 9-Response 3', s.[Question 9-Response 3]),
    ('Question 9-Response 4', s.[Question 9-Response 4]),
    ('Question 10-Response 1', s.[Question 10-Response 1]),
    ('Question 10-Response 2', s.[Question 10-Response 2]),
    ('Question 10-Response 3', s.[Question 10-Response 3]),
    ('Question 10-Response 4', s.[Question 10-Response 4]),
    ('Question 10-Response 5', s.[Question 10-Response 5]),
    ('Question 11-Reponse 1', s.[Question 11-Reponse 1]),
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
    ('Question 22-Reponse 1', s.[Question 22-Reponse 1]),
    ('Question 22-Reponse 2', s.[Question 22-Reponse 2]),
    ('Question 23-Response', s.[Question 23-Response]),
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
    ('Question 26-Response 1', s.[Question 26-Response 1]),
    ('Question 26-Response 2', s.[Question 26-Response 2]),
    ('Question 26-Response 3', s.[Question 26-Response 3]),
    ('Question 26-Response 4', s.[Question 26-Response 4]),
    ('Question 27-Response 1', s.[Question 27-Response 1]),
    ('Question 27-Response 2', s.[Question 27-Response 2]),
    ('Question 28-Response', s.[Question 28-Response]),
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
    ('Question 30-Response 1', s.[Question 30-Response 1]),
    ('Question 30-Response 2', s.[Question 30-Response 2]),
    ('Question 30-Response 3', s.[Question 30-Response 3])
) AS v([Question+Subquestion], answer)
ORDER BY s.[Respondent ID], v.[Question+Subquestion];



