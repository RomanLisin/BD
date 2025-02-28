--8.ƒл€ своей группы выставить расписание на Ѕазовый семестр, там где одну неделю проходит СHardware-PCТ либо СWindowsТ, 
--  следующую неделю проходит Сѕроцедурное программирование на €зыке —++;
USE VPD_311_Import
GO

SET DATEFIRST 1;


DECLARE	@group				AS INT			=	(SELECT group_id FROM Groups WHERE group_name = N'VPD_311');
DECLARE	@discipline_1		AS SMALLINT		=	(SELECT discipline_id FROM Disciplines WHERE discipline_name = N'Hardware-PC');
PRINT (@discipline_1)
DECLARE	@discipline_2		AS SMALLINT		=	(SELECT discipline_id FROM Disciplines WHERE discipline_name =  N'ѕроцедурное программирование на €зыке C++');
PRINT (@discipline_2)
DECLARE	@numberLessons_disc1	AS TINYINT		=	(SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_1);
PRINT (@numberLessons_disc1)
DECLARE	@numberLessons_disc2	AS TINYINT		=	(SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_2);
PRINT (@numberLessons_disc2)

DECLARE @max_value_numLess AS TINYINT;

SET @max_value_numLess = CASE 
						 WHEN @numberLessons_disc1 > @numberLessons_disc2 THEN @numberLessons_disc1
						 ELSE @numberLessons_disc2
						END;

DECLARE @min_value_numLess AS TINYINT;

SET @min_value_numLess = CASE 
						 WHEN @numberLessons_disc1 < @numberLessons_disc2 THEN @numberLessons_disc1
						 ELSE @numberLessons_disc2
						END;

DECLARE	@Teacher			AS SMALLINT		=	(SELECT teacher_id FROM Teachers WHERE first_name =  N'ќлег');
DECLARE	@start_date			AS	DATE		=	N'2024-09-01';
DECLARE	@date				AS	DATE		=	@start_date;
DECLARE	@time				AS	TIME(0)		=	N'12:00';
DECLARE @max_num_less_id	AS TINYINT		=	(SELECT discipline_id FROM Disciplines WHERE number_of_lessons = @max_value_numLess);

PRINT	(@group);
PRINT	(@discipline);
PRINT	(@number_of_lessons);
PRINT	(@teacher);
PRINT	(@start_date);
PRINT	(@time);
PRINT	('===============================');

--DEClARE	@diff_lesson_number		AS	TINYINT		=	@numberLessons_disc1 - @numberLessons_disc2;
	
-- IF  @diff_lesson_number >= 0

DECLARE @i AS TINYINT = 0;	


	WHILE	(@numberLessons_disc1 + @numberLessons_disc2 > 0)
	BEGIN
		WHILE (@i<=190)
		BEGIN
			IF	(@numberLessons_disc1 > 0 AND @numberLessons_disc2 > 0)
			BEGIN
				INSERT Schedule
						([group], discipline, teacher,[date],[time], spent)
				VALUES  (@group,IIF (@min_value_numLess % 2,@discipline_2,@discipline_1), @teacher, @date,  DATEADD(MINUTE, @i, @time),IIF(@date < GETDATE(), 1,0));	
				SET @numberLessons_disc2 = @numberLessons_disc2 - 1;
				SET @i = @i+95;
			END
			--INSERT Schedule
			--		([group], discipline, teacher,[date],[time], spent)
			--VALUES  (@group, IIF (@min_value_numLess % 2,@discipline_2,@discipline_1), @teacher, @date, DATEADD(MINUTE, 95, @time), IIF(@date < GETDATE(), 1,0));	
			--SET @numberLessons_disc2 = @numberLessons_disc2 - 1;
			--INSERT Schedule
			--		([group], discipline, teacher,[date],[time], spent)
			--VALUES  (@group, IIF (@min_value_numLess % 2,@discipline_2,@discipline_1), @teacher, @date, DATEADD(MINUTE, 190, @time), IIF(@date < GETDATE(), 1,0));
			--SET @numberLessons_disc2 = @numberLessons_disc2 - 1;
			IF (@numberLessons_disc1 > 0 OR @numberLessons_disc2 > 0) AND NOT (@numberLessons_disc1 > 0 AND @numberLessons_disc2 > 0)
			BEGIN
				INSERT Schedule
						([group], discipline, teacher,[date],[time], spent)
				VALUES  (@group,@max_num_less_id, @teacher, @date,  DATEADD(MINUTE, @i, @time),IIF(@date < GETDATE(), 1,0));	
				SET @numberLessons_disc2 = @numberLessons_disc2 - 1;
				SET @i = @i+95;
			END
		END
	PRINT('---------------------------------');
	SET @date = DATEADD(WEEK, 1, @date);
	SET @numberLessons_disc1 = @numberLessons_disc1-1;
	SET @numberLessons_disc2 = @numberLessons_disc2-1;
	END
		------------------------------------------------------------------------------------------
	


