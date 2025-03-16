--SQLQuery2 CREATE Function IsHoliday.sql

USE VPD_311_Import
SET DATEFIRST 1;
GO

-- ������� ������ ������, ���� ��� ����
IF OBJECT_ID('dbo.Holidays', 'U') IS NOT NULL
    DROP TABLE dbo.Holidays;

-- ������ ������� � �����������
CREATE TABLE Holidays (
    HolidayDate DATE PRIMARY KEY,
    HolidayName NVARCHAR(50)
);

DECLARE @year INT = 2025; -- ����� �������� �� ������ ���
DECLARE @easter DATE;

-- ��������� ���� ����� �� ��������� ������
DECLARE @a INT = @year % 19;
DECLARE @b INT = @year % 4;
DECLARE @c INT = @year % 7;
DECLARE @m INT = 15;
DECLARE @n INT = 6;
DECLARE @d INT = (19 * @a + @m) % 30;
DECLARE @e INT = (2 * @b + 4 * @c + 6 * @d + @n) % 7;

SET @easter = DATEADD(DAY, @d + @e + 13, DATEFROMPARTS(@year, 4, 1));

---- ���������� �������� (1-14 ������)
--INSERT INTO Holidays
--SELECT DATEADD(DAY, number, DATEFROMPARTS(@year, 1, 1)), N'���������� ��������'
--FROM master.dbo.spt_values WHERE type = 'P' AND number BETWEEN 0 AND 13;

---- 23 ������� � 8 �����
--INSERT INTO Holidays VALUES 
--    (DATEFROMPARTS(@year, 2, 23), N'���� ��������� ���������'),
--    (DATEFROMPARTS(@year, 3, 8), N'������������� ������� ����');

---- ������� ��������� (1-10 ���)
--INSERT INTO Holidays
--SELECT DATEADD(DAY, number, DATEFROMPARTS(@year, 5, 1)), N'������� ���������'
--FROM master.dbo.spt_values WHERE type = 'P' AND number BETWEEN 0 AND 9;

---- ������ �������� (��������� ������ ���� + ������ ������ �������)
--INSERT INTO Holidays
--SELECT DATEADD(DAY, number, DATEFROMPARTS(@year, 7, 25)), N'������ ��������'
--FROM master.dbo.spt_values WHERE type = 'P' AND number BETWEEN 0 AND 13;

---- ����� � 2 �������������� ��� (���������� ����������� � �������)
--INSERT INTO Holidays VALUES 
--    (@easter, N'�����'),
--    (DATEADD(DAY, 1, @easter), N'���������� �����������'),
--    (DATEADD(DAY, 2, @easter), N'���������� �������');

--PRINT '������� Holidays ������� ���������!';



-- ���������� �������� (1-14 ������)
INSERT INTO Holidays
SELECT DATEADD(DAY, number, DATEFROMPARTS(@year, 1, 1)), N'���������� ��������'
FROM master.dbo.spt_values 
WHERE type = 'P' AND number BETWEEN 0 AND 13
AND NOT EXISTS (
    SELECT 1 FROM Holidays WHERE HolidayDate = DATEADD(DAY, number, DATEFROMPARTS(@year, 1, 1))
);

-- 23 ������� � 8 �����
INSERT INTO Holidays 
SELECT d, n FROM (VALUES
    (DATEFROMPARTS(@year, 2, 23), N'���� ��������� ���������'),
    (DATEFROMPARTS(@year, 3, 8), N'������������� ������� ����')
) AS v(d, n)
WHERE NOT EXISTS (SELECT 1 FROM Holidays WHERE HolidayDate = v.d);

-- ������� ��������� (1-10 ���)
INSERT INTO Holidays
SELECT DATEADD(DAY, number, DATEFROMPARTS(@year, 5, 1)), N'������� ���������'
FROM master.dbo.spt_values 
WHERE type = 'P' AND number BETWEEN 0 AND 9
AND NOT EXISTS (
    SELECT 1 FROM Holidays WHERE HolidayDate = DATEADD(DAY, number, DATEFROMPARTS(@year, 5, 1))
);

-- ������ �������� (��������� ������ ���� + ������ ������ �������)
INSERT INTO Holidays
SELECT DATEADD(DAY, number, DATEFROMPARTS(@year, 7, 25)), N'������ ��������'
FROM master.dbo.spt_values 
WHERE type = 'P' AND number BETWEEN 0 AND 13
AND NOT EXISTS (
    SELECT 1 FROM Holidays WHERE HolidayDate = DATEADD(DAY, number, DATEFROMPARTS(@year, 7, 25))
);

-- ����� � 2 �������������� ���
INSERT INTO Holidays 
SELECT d, n FROM (VALUES
    (@easter, N'�����'),
    (DATEADD(DAY, 1, @easter), N'���������� �����������'),
    (DATEADD(DAY, 2, @easter), N'���������� �������')
) AS v(d, n)
WHERE NOT EXISTS (SELECT 1 FROM Holidays WHERE HolidayDate = v.d);