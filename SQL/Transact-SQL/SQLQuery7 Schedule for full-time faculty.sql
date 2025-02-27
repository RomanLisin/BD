USE VPD_311_Import
GO
--7. Написать код, который выставляет расписание для группы стационара. 
--	 На стационаре группы занимаются  3 раза в неделю по 2 пары:
--   Пн., Ср., Пт или Вт., Чт., Сб;
SET DATEFIRST 1;
--SET LANGUAGE English;

DECLARE	@monday_lesson		AS BIT			=	1;
DECLARE	@DateList_1			AS NVARCHAR(50)	=	'Monday,Wednesday,Friday';  -- с пробелами не работает
DECLARE	@DateList_2			AS NVARCHAR(50)	=	'Tuesday,Thursday,Saturday';
DECLARE	@group				AS INT			=	(SELECT group_id FROM Groups WHERE group_name = N'PV_211');
DECLARE	@discipline			AS SMALLINT		=	(SELECT discipline_id FROM Disciplines WHERE discipline_name = N'Hardware-PC');
DECLARE	@discipline_2		AS SMALLINT		=	(SELECT discipline_id FROM Disciplines WHERE discipline_name = N'Разработка%');
DECLARE	@number_of_lessons	AS TINYINT		=	(SELECT discipline_id FROM Disciplines WHERE discipline_id = @discipline);
DECLARE	@Teacher			AS SMALLINT		=	(SELECT teacher_id FROM Teachers WHERE last_name =  N'Глазунов');
DECLARE	@start_date			AS	DATE		=	N'2024-09-01';
DECLARE	@date				AS	DATE		=	@start_date;
DECLARE	@time				AS	TIME(0)		=	N'10:00';

PRINT	(@group);
PRINT	(@discipline);
PRINT	(@number_of_lessons);
PRINT	(@teacher);
PRINT	(@start_date);
PRINT	(@time);
PRINT	('===============================');

DEClARE	@lesson_number		AS	TINYINT		=	0;


WHILE	(@lesson_number < @number_of_lessons)
BEGIN

	IF  DATENAME(WEEKDAY, @date) IN (
    SELECT value FROM STRING_SPLIT(IIF(@monday_lesson=1,@DateList_1,@DateList_2), ',')
	)
	BEGIN
		PRINT(@date);
		PRINT(DATENAME(WEEKDAY, @date));
		PRINT(@lesson_number+1);
		PRINT(@time);

		INSERT Schedule
				([group], discipline, teacher,[date],[time], spent)
		VALUES  (@group, @discipline, @teacher, @date,  @time,IIF(@date < GETDATE(), 1,0));	
		SET @lesson_number = @lesson_number+1;
	
		------------------------------------------------------------------------------------------
		PRINT(@lesson_number+1);
		PRINT(DATEADD(MINUTE, 95,@time));

		INSERT Schedule
				([group], discipline, teacher,[date],[time], spent)
		VALUES  (@group, @discipline, @teacher, @date, DATEADD(MINUTE, 95, @time), IIF(@date < GETDATE(), 1,0));	
		SET @lesson_number = @lesson_number + 1;

	END
	PRINT('---------------------------------');
	SET @date = DATEADD(DAY, 1, @date);
END

--DELETE
--FROM Schedule
--WHERE lesson_id>61;