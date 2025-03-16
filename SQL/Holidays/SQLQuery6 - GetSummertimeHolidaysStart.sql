--SQLQuery6 - GetSummertimeHolidaysStart.sql 

USE VPD_311_Import
SET DATEFIRST 1;
GO

CREATE FUNCTION GetSummerHolidaysStart(@year AS SMALLINT) RETURNS DATE
BEGIN
	DECLARE @start_date	AS	DATE = DATEFROMPARTS(@year, 07, 31);
	DECLARE	@weekday	AS	TINYINT = DATEPART(WEEKDAY, @start_date);
	SET		@start_date =	DATEADD(DAY, -@weekday+1, @start_date);
	RETURN	@start_date;
END