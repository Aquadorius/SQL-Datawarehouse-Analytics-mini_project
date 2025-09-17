/*
========================================================
Bronze Layer Survey Data Load Procedure
========================================================

Stored Procedure: bronze.load_bronze
Purpose: Load Survey Monkey dataset into bronze layer raw data table
Data Source: CSV file from edited Survey Monkey export
Target Table: bronze.survey_responses

Overview:
---------
This stored procedure automates the loading of survey response data
from an external CSV file into the bronze schema. It provides:
- Automated data loading with BULK INSERT for performance
- Progress monitoring with timestamped messages
- Error handling with detailed error reporting
- Load duration tracking for performance monitoring

File Requirements:
-----------------
- CSV file must be located at specified path
- First row contains column headers (skipped with FIRSTROW=2)
- Comma-separated values format
- File must be accessible by SQL Server service account

Warnings:
---------
⚠️  DATA OVERWRITE: TRUNCATE operation removes all existing data
⚠️  FILE PATH: Hard-coded path must exist and be accessible
⚠️  PERMISSIONS: SQL Server must have read access to file location
⚠️  DATA LOSS: No backup is created before truncation

Dependencies:
------------
- bronze.survey_responses table must exist
- CSV file must be present at specified location
- Appropriate file system permissions required

Usage:
------
EXEC bronze.load_bronze;
========================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	
	BEGIN TRY 
		SET @batch_start_time=GETDATE();
		PRINT('===============================');
		PRINT('LOADING THE BRONZE LAYER');
		PRINT('===============================');

		PRINT('-------------------------------');
		PRINT('Loading survey_responses table');
		PRINT('-------------------------------');

		SET @start_time= GETDATE();
		PRINT('>>Truncating Table:  bronze.survey_responses');
		TRUNCATE TABLE bronze.survey_responses;
		PRINT('>>Inserting Data into: bronze.survey_responses');
		BULK INSERT bronze.survey_responses
		FROM 'D:\SQL Learning\Edited_survey_monkey_dataset\edited_survey_monkey_dataset.csv'
		WITH(
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		TABLOCK);
		SET @end_time=GETDATE();
		PRINT('Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time)AS NVARCHAR)+'seconds');
		

		
		PRINT('================================');
		PRINT('LOADING DATA INTO BRONZE LAYER COMPLETED')
		PRINT('		-Loading Duration: ' + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time)AS NVARCHAR) +'seconds');


	END TRY
	BEGIN CATCH
		PRINT('===========================================');
		PRINT('ERROR OCCURRED DURINF LOADING BRONZE LAYER');
		PRINT('ERROR MESSAGE: '+ ERROR_MESSAGE());
		PRINT('ERROR NUMBER: '+CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('ERROR STATE: '+CAST(ERROR_STATE() AS NVARCHAR));
	END CATCH
	

END


GO


EXEC bronze.load_bronze;

