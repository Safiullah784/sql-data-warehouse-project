/* ================================================================
   Stored Procedure: Load Bronze Layer (Source - > Bronze)
   ================================================================
   Script Purpose: Creates or replaces the stored procedure
                   bronze.load_bronze, which performs the raw-data
                   load from CRM and ERP CSV source files into the
                   existing bronze tables.

                   Key actions:
                   • Truncates each bronze table before loading.
                   • Uses BULK INSERT to import data from the
                     defined file paths.
                   • Prints row counts and step durations for
                     simple performance logging.
                   • Wraps all operations in TRY/CATCH for basic
                     error reporting and re-throwing.

   Usage:   Execute this script once to create or update the
            procedure. After that, run:
                EXEC bronze.load_bronze;
            whenever new source files need to be ingested.
   ================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @proc_start   DATETIME2 = SYSDATETIME();
    DECLARE @proc_end     DATETIME2;
    DECLARE @step_start   DATETIME2;
    DECLARE @rowcount     INT;

    PRINT '===========================================';
    PRINT 'Bronze Load Started at ' + CONVERT(VARCHAR(30), @proc_start, 120);
    PRINT '===========================================';

    BEGIN TRY
        /* =========================
           CRM Source
           ========================= */

        SET @step_start = SYSDATETIME();
        PRINT 'Loading CRM Customer Info...';
        TRUNCATE TABLE bronze.crm_cust_info;
        BULK INSERT bronze.crm_cust_info
        FROM 'F:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @rowcount = @@ROWCOUNT;
        PRINT 'CRM Customer Info loaded: ' + CAST(@rowcount AS VARCHAR) + ' rows in '
              + CAST(DATEDIFF(SECOND, @step_start, SYSDATETIME()) AS VARCHAR) + ' sec.';

        SET @step_start = SYSDATETIME();
        PRINT 'Loading CRM Product Info...';
        TRUNCATE TABLE bronze.crm_prd_info;
        BULK INSERT bronze.crm_prd_info
        FROM 'F:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @rowcount = @@ROWCOUNT;
        PRINT 'CRM Product Info loaded: ' + CAST(@rowcount AS VARCHAR) + ' rows in '
              + CAST(DATEDIFF(SECOND, @step_start, SYSDATETIME()) AS VARCHAR) + ' sec.';

        SET @step_start = SYSDATETIME();
        PRINT 'Loading CRM Sales Details...';
        TRUNCATE TABLE bronze.crm_sales_details;
        BULK INSERT bronze.crm_sales_details
        FROM 'F:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @rowcount = @@ROWCOUNT;
        PRINT 'CRM Sales Details loaded: ' + CAST(@rowcount AS VARCHAR) + ' rows in '
              + CAST(DATEDIFF(SECOND, @step_start, SYSDATETIME()) AS VARCHAR) + ' sec.';

        /* =========================
           ERP Source
           ========================= */

        SET @step_start = SYSDATETIME();
        PRINT 'Loading ERP Customer AZ12...';
        TRUNCATE TABLE bronze.erp_cust_az12;
        BULK INSERT bronze.erp_cust_az12
        FROM 'F:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @rowcount = @@ROWCOUNT;
        PRINT 'ERP Customer AZ12 loaded: ' + CAST(@rowcount AS VARCHAR) + ' rows in '
              + CAST(DATEDIFF(SECOND, @step_start, SYSDATETIME()) AS VARCHAR) + ' sec.';

        SET @step_start = SYSDATETIME();
        PRINT 'Loading ERP Location A101...';
        TRUNCATE TABLE bronze.erp_loc_a101;
        BULK INSERT bronze.erp_loc_a101
        FROM 'F:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @rowcount = @@ROWCOUNT;
        PRINT 'ERP Location A101 loaded: ' + CAST(@rowcount AS VARCHAR) + ' rows in '
              + CAST(DATEDIFF(SECOND, @step_start, SYSDATETIME()) AS VARCHAR) + ' sec.';

        SET @step_start = SYSDATETIME();
        PRINT 'Loading ERP Price Category G1V2...';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'F:\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @rowcount = @@ROWCOUNT;
        PRINT 'ERP Price Category G1V2 loaded: ' + CAST(@rowcount AS VARCHAR) + ' rows in '
              + CAST(DATEDIFF(SECOND, @step_start, SYSDATETIME()) AS VARCHAR) + ' sec.';

        /* =========================
           Completion
           ========================= */

        SET @proc_end = SYSDATETIME();
        PRINT '===========================================';
        PRINT 'All bronze tables loaded successfully.';
        PRINT 'Completed at ' + CONVERT(VARCHAR(30), @proc_end, 120);
        PRINT 'Total duration: ' + CAST(DATEDIFF(SECOND, @proc_start, @proc_end) AS VARCHAR) + ' sec.';
        PRINT '===========================================';

    END TRY
    BEGIN CATCH
        PRINT '*** ERROR: Bronze load failed ***';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
        PRINT 'Message: ' + ERROR_MESSAGE();
        PRINT 'Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
        PRINT 'Line: ' + CAST(ERROR_LINE() AS VARCHAR);
        THROW;
    END CATCH
END;
 
