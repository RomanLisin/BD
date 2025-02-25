USE VPD_311_Import
GO

SELECT 
	last_name		AS N'Фамилия',
	first_name		AS N'Имя',
	middle_name		AS N'Отчество',
	birth_date		AS N'Дата рождения',
	DATEDIFF(DAY, birth_date, GETDATE())/365 AS N'Возраст',
	group_name		AS N'Группа',
	direction_name	AS N'Направление обучения'
FROM Students, Groups, Directions
WHERE [group]  = group_id
AND direction  = direction_id
--AND direction_name LIKE N'Разработка%'
--ORDER BY last_name
--ORDER BY birth_date	DESC -- Descending (По убыванию)
						-- ASC --Ascending ( По возрастанию)
ORDER BY N'Возраст' DESC
;
GO


SELECT 
		last_name	AS N'Фамилия',
		first_name	AS N'Имя',
		middle_name AS N'Отчество',
		birth_date	AS N'Дата рождения',
		DATEDIFF(DAY, birth_date, GETDATE())/365 AS N'Возраст',
		group_name	AS N'Группа',
		direction_name AS N'Направление обучения'
FROM	Students, Groups, Directions
WHERE	[group]		=	group_id
AND		direction   =	direction_id
--AND		direction_name  LIKE N'Разработка%'
ORDER BY  birth_date DESC--N'Возраст';