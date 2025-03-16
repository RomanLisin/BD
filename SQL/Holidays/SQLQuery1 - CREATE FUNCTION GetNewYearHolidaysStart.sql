--SQLQuery1 - CREATE FUNCTION GetNewYearHolidaysStart.sql

USE VPD_311_Import
SET DATEFIRST 1; -- Первый день понедельник = 1
GO

ALTER FUNCTION GetNewYearHolidaysStart (@year AS SMALLINT) RETURNS DATE
BEGIN
	DECLARE @new_year	AS DATE		=	DATEFROMPARTS(@year, 01, 01);
	DECLARE	@weekday	AS TINYINT	=	DATEPART(WEEKDAY, @new_year);
	SET @weekday	= IIF(@weekday = 1, 3, @weekday);
	SET @weekday	= IIF(@weekday = 2, 4, @weekday);
	RETURN	DATEADD(DAY, -@weekday+1, @new_year);
END