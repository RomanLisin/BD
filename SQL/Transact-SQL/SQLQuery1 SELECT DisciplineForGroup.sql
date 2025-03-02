USE VPD_311_Import
GO

ALTER PROCEDURE sp_SelectDisciplineForGroup
@group_name  AS NVARCHAR(10),
@discpline_name AS NVARCHAR(150)
AS 
BEGIN
	SELECT
			[Группа]		= group_name,
			[Дисциплина]	= discipline_name,
			[Дата]			=[date],
			[Время]			= [time],
			[День]			= DATENAME(WEEKDAY, [date]),
			[Преподаватель] = FORMATMESSAGE(N'%s %s %s',last_name, first_name, middle_name),
			[Статус]		=  IIF(spent=1,N'Проведено',N'Запланировано')
	FROM Schedule, Groups, Disciplines, Teachers
	WHERE [group]			=  group_id
	AND discipline			= discipline_id
	AND teacher				= teacher_id
	AND group_name			= @group_name
	AND discipline_name		LIKE @discpline_name
	ORDER BY [date]
	;
END