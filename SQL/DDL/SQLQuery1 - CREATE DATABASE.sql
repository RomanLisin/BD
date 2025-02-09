USE master
GO

CREATE DATABASE VPD_311_SQL
ON --Определяем параметры файла базы данных
(
	NAME		 = 'VPD_311_SQL',
	FILENAME	 = 'D:\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\VPD_311_SQL.mdf',
	SIZE		 = 8MB,
	MAXSIZE		 = 500MB,
	FILEGROWTH   = 8MB
)
LOG ON --Определяем параметры файла журнала базы данных
(
	NAME		 = 'VPD_311_SQL_Log',
	FILENAME	 = 'D:\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\VPD_311_SQL.ldf',
	SIZE		 = 8MB,
	MAXSIZE		 = 500MB,
	FILEGROWTH   = 8MB
);
GO