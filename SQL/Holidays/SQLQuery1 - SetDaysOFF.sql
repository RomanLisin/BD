--SQLQuery1 - SetDaysOFF.sql

USE VPD_311_Import
SET DATEFIRST 1; -- Первый день понедельник = 1
GO

ALTER PROCEDURE sp_SetDaysOFF
		@holiday_name	AS NVARCHAR(150),
		@year			AS SMALLINT
AS
BEGIN
	DECLARE	@holiday_id AS TINYINT = (SELECT holiday_id FROM Holidays2 WHERE holiday_name LIKE @holiday_name);
	DECLARE	@duration   AS TINYINT = (SELECT duration	FROM Holidays2 WHERE holiday_id = @holiday_id);
	DECLARE @start_date	AS DATE	   = dbo.GetHolidaysStartDate(@holiday_name, @year);
	DECLARE @date		AS DATE		= @start_date;
	DECLARE @day		AS TINYINT	= 0;

	WHILE @day < @duration
	BEGIN
		PRINT @date;
		IF NOT EXISTS (SELECT [date] FROM DaysOFF)
		BEGIN
			INSERT DaysOFF  VALUES (@date, @holiday_id);
		END
		SET @date = DATEADD(DAY, 1, @date);
		SET @day += 1;
	END
END