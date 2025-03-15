USE VPD_311_Import
GO

SELECT
		[Группа]		=  group_name,	
		[Дисциплина]	=  discipline_name,
		[Преподаватель] =  last_name + ' ' + first_name + ' ' + middle_name,
		[День]			=  DATENAME(WEEKDAY, [date]),
		[Дата]			=  [date],
		[Время]			=  [time],
		[Статус]		=  IIF(spent = 1, N'Проведено', N'Запланировано')  --Тернарный оператор
FROM	Schedule, Groups, Disciplines, Teachers
WHERE	[group]			=  group_id
AND		discipline		=  discipline_id
AND		teacher			=  teacher_id
--AND  lesson_id > 61

--DELETE FROM Schedule

--PRINT (@lesson_number + 1);