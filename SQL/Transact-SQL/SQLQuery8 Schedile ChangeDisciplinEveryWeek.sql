--8.ƒл€ своей группы выставить расписание на Ѕазовый семестр, там где одну неделю проходит СHardware-PCТ либо СWindowsТ, 
--  следующую неделю проходит Сѕроцедурное программирование на €зыке —++;
USE VPD_311_Import
GO

SET DATEFIRST 1;

DECLARE	@group					AS INT			=	(SELECT group_id		  FROM Groups	   WHERE group_name      = N'VPD_311');
DECLARE	@discipline_1			AS SMALLINT		=	(SELECT discipline_id	  FROM Disciplines WHERE discipline_name = N'Hardware-PC');
DECLARE	@discipline_2			AS SMALLINT		=	(SELECT discipline_id     FROM Disciplines WHERE discipline_name = N'ѕроцедурное программирование на €зыке C++');
DECLARE	@numberLessons_disc1	AS TINYINT		=	(SELECT number_of_lessons FROM Disciplines WHERE discipline_id	 = @discipline_1);
DECLARE	@numberLessons_disc2	AS TINYINT		=	(SELECT number_of_lessons FROM Disciplines WHERE discipline_id   = @discipline_2);

DECLARE	@Teacher				AS SMALLINT		=	(SELECT teacher_id		  FROM Teachers    WHERE first_name		 = N'ќлег');
DECLARE	@start_date				AS	DATE		=	N'2024-09-01';
DECLARE	@date					AS	DATE		=	@start_date;
DECLARE	@time					AS	TIME(0)		=	N'12:00';

DECLARE @current_discipline		AS SMALLINT;
DECLARE @week_counter			AS INT			=	0;
DECLARE @i						AS TINYINT		=	0;

WHILE (@numberLessons_disc1 > 0 OR @numberLessons_disc2 > 0)
BEGIN
	SET @i = 0;
    IF @week_counter % 2 = 0
        SET @current_discipline = @discipline_1;
    ELSE
        SET @current_discipline = @discipline_2;
	WHILE (@i < 3)
	BEGIN
		IF @current_discipline = @discipline_1 AND @numberLessons_disc1 > 0
		BEGIN
		    INSERT INTO Schedule ([group], discipline, teacher, [date], [time], spent)
				VALUES (@group, @discipline_1, @teacher, @date,DATEADD(MINUTE,95*@i,@time), IIF(@date < GETDATE(), 1, 0));
		    SET @numberLessons_disc1 = @numberLessons_disc1 - 1;
		END
		ELSE IF @current_discipline = @discipline_2 AND @numberLessons_disc2 > 0
		BEGIN
		    INSERT INTO Schedule ([group], discipline, teacher, [date], [time], spent)
				VALUES (@group, @discipline_2, @teacher, @date, DATEADD(MINUTE,95*@i,@time), IIF(@date < GETDATE(), 1, 0));
		    SET @numberLessons_disc2 = @numberLessons_disc2 - 1;
		END
		SET @i=@i+1;
	END
    SET @date = DATEADD(WEEK, 1, @date);
    SET @week_counter = @week_counter + 1;
	SET @time = N'12:00';
END
		
	


