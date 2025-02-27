USE VPD_311_Import
GO

SELECT 
			direction_name		AS N'����������� ��������',
			COUNT(group_id)		AS N'���������� �����'
FROM		Groups, Directions
WHERE		direction = direction_id
GROUP BY	direction_name
ORDER BY	N'���������� �����'	DESC
;

SELECT 
		[����������� ��������] = direction_name,
		[���������� ���������] = COUNT(stud_id)
FROM Students, Groups, Directions
WHERE [group] = group_id
AND direction = direction_id
GROUP BY  direction_name
;
SELECT 
		[����������� ��������] = direction_name,
		[���������� �����] = COUNT(group_id)
		
FROM  Groups, Directions
WHERE direction = direction_id
GROUP BY  direction_name

SELECT 
		[����������� ��������] = direction_name,
		[���������� ���������] = COUNT(stud_id)
FROM Students, Groups, Directions
WHERE [group] = group_id
AND direction = direction_id
GROUP BY  direction_name
;
--1.*** ���������� � ����� ������� ���������� ����� � ���������� 
--  ��������� ��� ������� �����������;
SELECT 
		[����������� ��������]	=	direction_name,
		[���������� �����]		=	COUNT(DISTINCT group_id), -- ������� ���-�� ���������� �����
		[���������� ���������]	=	COUNT(stud_id) 
FROM  Directions, Groups, Students
WHERE [group]=group_id
AND	  direction = direction_id
GROUP BY direction_name

--4.*** ���������� ���������� �������������� �� ������� ����������� ��������;
SELECT 
		[����������� ��������]		=	direction_name,
		[���������� ��������������]	=	COUNT(DISTINCT teacher_id) 
FROM  Directions AS Dir, TeachersDisciplinesRelation AS TDR, 
DisciplinesDirectionsRelation AS DDR, Disciplines AS Dis, Teachers AS T
WHERE DDR.direction = Dir.direction_id 
AND DDR.discipline = Dis.discipline_id
AND TDR.discipline = Dis.discipline_id
AND TDR.teacher = T.teacher_id
GROUP BY direction_name

--6.��� ������� ����������� ���������� ����� ���������� �������
SELECT   -- ���������
		[����������� ��������] = direction_name,
		[���������� �������] = SUM(number_of_lessons)
FROM Directions, DisciplinesDirectionsRelation, Disciplines
WHERE direction = direction_id
AND discipline = discipline_id
GROUP BY direction_name

SELECT * FROM Teachers, TeachersDisciplinesRelation
SELECT * FROM Directions, DisciplinesDirectionsRelation, Disciplines

SELECT * FROM DisciplinesDirectionsRelation
SELECT * FROM Disciplines



