/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT '================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;

		BULK INSERT bronze.crm_cust_info
		FROM 'C:\sql_project\source_crm\cust_info.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

		SET @end_time = GETDATE();
		PRINT 'crm_cust_info Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

		-- product
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info;

		BULK INSERT bronze.crm_prd_info
		FROM 'C:\sql_project\source_crm\prd_info.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

		SET @end_time = GETDATE();
		PRINT 'crm_prd_info Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

		-- sales
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details;

		BULK INSERT bronze.crm_sales_details
		FROM 'C:\sql_project\source_crm\sales_details.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

		SET @end_time = GETDATE();
		PRINT 'crm_sales_details Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';

		-- loc
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_loc_a101;

		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\sql_project\source_erp\loc_a101.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

		SET @end_time = GETDATE();
		PRINT 'erp_loc_a101 Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

		-- cust
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_cust_az12;

		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\sql_project\source_erp\cust_az12.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

		SET @end_time = GETDATE();
		PRINT 'erp_cust_az12 Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

		-- category
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\sql_project\source_erp\px_cat_g1v2.csv'
		WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);

		SET @end_time = GETDATE();
		PRINT 'erp_px_cat_g1v2 Load Time: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);

		SET @batch_end_time = GETDATE();

		PRINT '==========================================';
		PRINT 'Loading Completed';
		PRINT 'Total Time: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR);
		PRINT '==========================================';

	END TRY
	BEGIN CATCH
		PRINT 'ERROR: ' + ERROR_MESSAGE();
	END CATCH
END
