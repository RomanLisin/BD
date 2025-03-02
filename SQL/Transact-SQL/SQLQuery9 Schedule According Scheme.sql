USE VPD_311_Import
GO

--9.*Для стационарной группы (PD_212) выставить расписание на базовый семестр по схеме 12-21

DECLARE @DateTable TABLE (DayName NVARCHAR(10));
INSERT INTO @DateTable (DayName) VALUES ('Monday'), ('Wednesday'), ('Friday');

DECLARE @scheme NVARCHAR(50) = N'12-21';
DECLARE @FirstWeekNumber TINYINT = CAST(PARSENAME(REPLACE(@scheme, '-', '.'), 2) AS TINYINT);
DECLARE @SecondWeekNumber TINYINT = CAST(PARSENAME(REPLACE(@scheme, '-', '.'), 1) AS TINYINT);
DECLARE @group INT = (SELECT group_id FROM Groups WHERE group_name = N'PD_212');
DECLARE @discipline_1 SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name = N'Hardware-PC');
DECLARE @discipline_2 SMALLINT = (SELECT discipline_id FROM Disciplines WHERE discipline_name = N'Разработка Windows-приложений на языке C++');
DECLARE @number_of_lessons_1 SMALLINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_1);
DECLARE @number_of_lessons_2 SMALLINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_2);
DECLARE @Teacher SMALLINT = (SELECT teacher_id FROM Teachers WHERE last_name = N'Глазунов');
DECLARE @start_date DATE = N'2024-09-01';
DECLARE @date DATE = @start_date;
DECLARE @time TIME(0) = N'10:00';
DECLARE @current_week_scheme BIT = 0;
DECLARE @day_counter TINYINT = 0;

WHILE (@number_of_lessons_1 > 0 OR @number_of_lessons_2 > 0)
BEGIN
    DECLARE @disc1_lessons_this_week TINYINT = IIF(@current_week_scheme = 0, FLOOR(@FirstWeekNumber / 10), FLOOR(@SecondWeekNumber / 10));
    DECLARE @disc2_lessons_this_week TINYINT = IIF(@current_week_scheme = 0, @SecondWeekNumber % 10, @FirstWeekNumber % 10);
    SET @day_counter = 0;
    DECLARE @change_discipline AS BIT = 0;

    WHILE @day_counter < 7
    BEGIN
        DECLARE @current_day NVARCHAR(10) = DATENAME(WEEKDAY, @date);

        IF EXISTS (SELECT 1 FROM @DateTable WHERE DayName = @current_day)
        BEGIN
            IF @change_discipline = 0 AND @disc1_lessons_this_week > 0 AND @number_of_lessons_1 > 0
            BEGIN
                INSERT INTO Schedule ([group], discipline, teacher, [date], [time], spent)
                VALUES (@group, @discipline_1, @teacher, @date, @time, IIF(@date < GETDATE(), 1, 0));
                SET @number_of_lessons_1 = @number_of_lessons_1 - 1;
				IF @number_of_lessons_1 >0
				BEGIN
					INSERT INTO Schedule ([group], discipline, teacher, [date], [time], spent)
					VALUES (@group, @discipline_1, @teacher, @date,DATEADD(MINUTE,95, @time), IIF(@date < GETDATE(), 1, 0));
					SET @number_of_lessons_1 = @number_of_lessons_1 - 1;
				END 
				ELSE IF @number_of_lessons_2 > 0
				BEGIN
					INSERT INTO Schedule ([group], discipline, teacher, [date], [time], spent)
					VALUES (@group, @discipline_2, @teacher, @date,DATEADD(MINUTE,95, @time), IIF(@date < GETDATE(), 1, 0));
					SET @number_of_lessons_2 = @number_of_lessons_2 - 1;
				END
                SET @disc1_lessons_this_week = @disc1_lessons_this_week - 1;
                IF @disc1_lessons_this_week = 0 OR @number_of_lessons_1 = 0
                    SET @change_discipline = 1;
            END
            ELSE
			BEGIN 
				IF @change_discipline = 1 AND @disc2_lessons_this_week > 0 AND @number_of_lessons_2 > 0
				BEGIN
				    INSERT INTO Schedule ([group], discipline, teacher, [date], [time], spent)
				    VALUES (@group, @discipline_2, @teacher, @date, @time, IIF(@date < GETDATE(), 1, 0));
				    SET @number_of_lessons_2 = @number_of_lessons_2 - 1;
					IF @number_of_lessons_2 >0
					BEGIN
						INSERT INTO Schedule ([group], discipline, teacher, [date], [time], spent)
						VALUES (@group, @discipline_2, @teacher, @date,DATEADD(MINUTE,95, @time), IIF(@date < GETDATE(), 1, 0));
						SET @number_of_lessons_2 = @number_of_lessons_2 - 1;
					END 
					ELSE 
					BEGIN IF @number_of_lessons_1 > 0
					BEGIN
						INSERT INTO Schedule ([group], discipline, teacher, [date], [time], spent)
						VALUES (@group, @discipline_1, @teacher, @date,DATEADD(MINUTE,95, @time), IIF(@date < GETDATE(), 1, 0));
						SET @number_of_lessons_1 = @number_of_lessons_1 - 1;
					END
					END
				    SET @disc2_lessons_this_week = @disc2_lessons_this_week - 1;
					PRINT(@disc2_lessons_this_week);
				    IF @disc2_lessons_this_week = 0 OR @number_of_lessons_2 = 0
				        SET @change_discipline = 0; 
				END
			END
        END
        -- Переходим к следующему дню в любом случае
        SET @date = DATEADD(DAY, 1, @date);
        SET @day_counter = @day_counter + 1;
    END

    -- Переключаем неделю 
    SET @current_week_scheme = IIF(@current_week_scheme = 0, 1, 0);
END

