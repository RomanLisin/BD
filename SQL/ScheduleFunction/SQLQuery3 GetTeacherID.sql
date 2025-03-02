--SQLQuery3 GetTeacherID.sql
USE VPD_311_Import
GO

ALTER FUNCTION GetTeacherID(@teacher_last_name NVARCHAR(50)) RETURNS SMALLINT
BEGIN
	RETURN(SELECT teacher_id FROM Teachers WHERE last_name = @teacher_last_name);
END