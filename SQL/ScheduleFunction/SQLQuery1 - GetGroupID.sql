--SQLQuery1 - GetGroupID.sql
USE VPD_311_Import;
GO

CREATE FUNCTION GetGroupID (@group_name NVARCHAR(10)) RETURNS INT
BEGIN
	RETURN (SELECT group_id FROM Groups WHERE group_name = @group_name);
END