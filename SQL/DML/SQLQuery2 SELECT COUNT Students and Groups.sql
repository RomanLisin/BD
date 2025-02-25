USE VPD_311_Import
GO

SELECT 
			direction_name		AS N'Направление обучения',
			COUNT(group_id)		AS N'Количество групп'
FROM		Groups, Directions
WHERE		direction = direction_id
GROUP BY	direction_name
ORDER BY	N'Количество групп'	DESC
;

SELECT 
		[Направление обучения] = direction_name,
		[Количество студентов] = COUNT(stud_id)
FROM Students, Groups, Directions
WHERE [group] = group_id
AND direction = direction_id
GROUP BY  direction_name
;
SELECT 
		[Направление обучения] = direction_name,
		[Количество групп] = COUNT(group_id)
		
FROM  Groups, Directions
WHERE direction = direction_id
GROUP BY  direction_name

SELECT 
		[Направление обучения] = direction_name,
		[Количество студентов] = COUNT(stud_id)
FROM Students, Groups, Directions
WHERE [group] = group_id
AND direction = direction_id
GROUP BY  direction_name
;
--1.*** Подсчитать в одном запросе количество групп и количество 
--  студентов для каждого направления;
SELECT 
		[Направление обучения]	=	direction_name,
		[Количество групп]		=	COUNT(DISTINCT group_id), -- подсчёт кол-ва уникальных групп
		[Количество студентов]	=	COUNT(stud_id) 
FROM  Directions, Groups, Students
WHERE [group]=group_id
AND	  direction = direction_id
GROUP BY direction_name

--4.*** Подсчитать количество преподавателей по каждому направлению обучения;
SELECT 
		[Направление обучения]		=	direction_name,
		[Количество преподавателей]	=	COUNT(DISTINCT teacher_id) 
FROM  Directions AS Dir, TeachersDisciplinesRelation AS TDR, 
DisciplinesDirectionsRelation AS DDR, Disciplines AS Dis, Teachers AS T
WHERE DDR.direction = Dir.direction_id 
AND DDR.discipline = Dis.discipline_id
AND TDR.discipline = Dis.discipline_id
AND TDR.teacher = T.teacher_id
GROUP BY direction_name

--6.Для каждого направления подсчитать общее количество занятий
SELECT   -- Проверить
		[Направление обучения] = direction_name,
		[Количество занятий] = SUM(number_of_lessons)
FROM Directions, DisciplinesDirectionsRelation, Disciplines
WHERE direction = direction_id
AND discipline = discipline_id
GROUP BY direction_name

SELECT * FROM Teachers, TeachersDisciplinesRelation
SELECT * FROM Directions, DisciplinesDirectionsRelation, Disciplines

SELECT * FROM DisciplinesDirectionsRelation
SELECT * FROM Disciplines



