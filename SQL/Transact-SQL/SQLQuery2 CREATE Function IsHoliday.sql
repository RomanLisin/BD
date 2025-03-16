--SQLQuery2 CREATE Function IsHoliday.sql

USE VPD_311_Import
SET DATEFIRST 1;
GO

-- Удаляем старые данные, если они есть
IF OBJECT_ID('dbo.Holidays', 'U') IS NOT NULL
    DROP TABLE dbo.Holidays;

-- Создаём таблицу с праздниками
CREATE TABLE Holidays (
    HolidayDate DATE PRIMARY KEY,
    HolidayName NVARCHAR(50)
);

DECLARE @year INT = 2025; -- Можно изменить на нужный год при этом нужно пересчитать даты пасхи
DECLARE @easter DATE;

---- вычисляем дату Пасхи по алгоритму Гаусса
--DECLARE @a INT = @year % 19;
--DECLARE @b INT = @year % 4;
--DECLARE @c INT = @year % 7;
--DECLARE @m INT = 15;
--DECLARE @n INT = 6;
--DECLARE @d INT = (19 * @a + @m) % 30;
--DECLARE @e INT = (2 * @b + 4 * @c + 6 * @d + @n) % 7;

--SET @easter = DATEADD(DAY, @d + @e + 13, DATEFROMPARTS(@year, 4, 1));

--новогодние каникулы (1-14 января)
INSERT INTO Holidays
	SELECT DATEADD(DAY, number, DATEFROMPARTS(@year, 1, 1)), N'Новогодние каникулы'
	FROM master.dbo.spt_values 
	WHERE type = 'P' AND number BETWEEN 0 AND 13
	AND NOT EXISTS (
    SELECT 1 FROM Holidays WHERE HolidayDate = DATEADD(DAY, number, DATEFROMPARTS(@year, 1, 1)));

-- 23 Февраля и 8 Марта
INSERT INTO Holidays 
	SELECT d, n FROM (VALUES
	    (DATEFROMPARTS(@year, 2, 23), N'День защитника Отечества'),
	    (DATEFROMPARTS(@year, 3, 8), N'Международный женский день')) 
		AS v(d, n)
	WHERE NOT EXISTS (SELECT 1 FROM Holidays WHERE HolidayDate = v.d);

-- Майские праздники (1-10 мая)
INSERT INTO Holidays
	SELECT DATEADD(DAY, number, DATEFROMPARTS(@year, 5, 1)), N'Майские праздники'
	FROM master.dbo.spt_values 
	WHERE type = 'P' AND number BETWEEN 0 AND 9
	AND NOT EXISTS (
    SELECT 1 FROM Holidays WHERE HolidayDate = DATEADD(DAY, number, DATEFROMPARTS(@year, 5, 1)));

--летние каникулы (последняя неделя июля + первая неделя августа)
INSERT INTO Holidays
	SELECT DATEADD(DAY, number, DATEFROMPARTS(@year, 7, 25)), N'Летние каникулы'
	FROM master.dbo.spt_values 
	WHERE type = 'P' AND number BETWEEN 0 AND 13
	AND NOT EXISTS (
    SELECT 1 FROM Holidays WHERE HolidayDate = DATEADD(DAY, number, DATEFROMPARTS(@year, 7, 25)));

----Пасха и 2 дополнительных дня
--INSERT INTO Holidays 
--SELECT d, n FROM (VALUES
--    (@easter, N'Пасха'),
--    (DATEADD(DAY, 1, @easter), N'Пасхальный понедельник'),
--    (DATEADD(DAY, 2, @easter), N'Пасхальный вторник')
--) AS v(d, n)
--WHERE NOT EXISTS (SELECT 1 FROM Holidays WHERE HolidayDate = v.d);

-- пасха и два дополнительных дня (20-22 апреля)
INSERT INTO Holidays VALUES 
    ('2025-04-20', N'Пасха'),
    ('2025-04-21', N'Пасхальный понедельник'),
    ('2025-04-22', N'Пасхальный вторник');


	--DELETE FROM Holidays WHERE HolidayDate >= '2025-01-01' AND HolidayDate <= '2025-12-31';