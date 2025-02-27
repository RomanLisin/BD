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

DECLARE @min_value_numLess AS TINYINT;

SET @min_value_numLess = CASE 
						 WHEN @numberLessons_disc1 < @numberLessons_disc2 THEN @numberLessons_disc1
						 ELSE @numberLessons_disc2
						END;

DECLARE	@Teacher			AS SMALLINT		=	(SELECT teacher_id FROM Teachers WHERE first_name =  N'ќлег');
DECLARE	@start_date			AS	DATE		=	N'2024-09-01';
DECLARE	@date				AS	DATE		=	@start_date;
DECLARE	@time				AS	TIME(0)		=	N'12:00';

PRINT	(@group);
PRINT	(@discipline);
PRINT	(@number_of_lessons);
PRINT	(@teacher);
PRINT	(@start_date);
PRINT	(@time);
PRINT	('===============================');

DEClARE	@diff_lesson_number		AS	TINYINT		=	@numberLessons_disc1 - @numberLessons_disc2;
	
IF  @diff_lesson_number >= 0
BEGIN


	WHILE	(@numberLessons_disc2 >= 0)
	BEGIN

		INSERT Schedule
				([group], discipline, teacher,[date],[time], spent)
		VALUES  (@group,IIF (@numberLessons_disc2%2,@discipline_2,@discipline_1), @teacher, @date,  @time,IIF(@date < GETDATE(), 1,0));	
		SET @numberLessons_disc2 = @numberLessons_disc2 - 1;

		INSERT Schedule
				([group], discipline, teacher,[date],[time], spent)
		VALUES  (@group, IIF (@numberLessons_disc2%2,@discipline_2,@discipline_1), @teacher, @date, DATEADD(MINUTE, 95, @time), IIF(@date < GETDATE(), 1,0));	
		SET @numberLessons_disc2 = @numberLessons_disc2 - 1;
		INSERT Schedule
				([group], discipline, teacher,[date],[time], spent)
		VALUES  (@group, IIF (@numberLessons_disc2%2,@discipline_2,@discipline_1), @teacher, @date, DATEADD(MINUTE, 190, @time), IIF(@date < GETDATE(), 1,0));
		SET @numberLessons_disc2 = @numberLessons_disc2 - 1;

	PRINT('---------------------------------');
	SET @date = DATEADD(WEEK, 1, @date);
	END
		------------------------------------------------------------------------------------------
		PRINT(@lesson_number+1);
		PRINT(DATEADD(MINUTE, 95,@time));

		
		SET @lesson_number = @lesson_number + 1;

	END
	PRINT('---------------------------------');
	SET @date = DATEADD(DAY, 1, @date);
END
