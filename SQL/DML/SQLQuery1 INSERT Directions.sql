USE VPD_311_HOME
GO

INSERT Directions
		(direction_id,	direction_name)
VALUES	(1,				N'���������� ������������ �����������'), -- N ��� �������������  UNICODE
		(2,				N'������� ���������� � ��������� �����������������'),
		(3,				N'������������ ������� � ������')
;
GO

SELECT * FROM Directions;