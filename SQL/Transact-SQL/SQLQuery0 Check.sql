--SQLQuery0 Check.sql
USE VPD_311_Import
GO

EXEC sp_SelectSchedule;
--EXEC sp_SelectScheduleForGroup N'VPD_311';
EXEC sp_SelectDisciplineForGroup N'VPD_311', N'Hard%';