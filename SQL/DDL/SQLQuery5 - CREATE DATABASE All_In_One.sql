USE master;
GO

CREATE DATABASE VPD_311_HOME
ON --Определяем параметры файла базы данных
(
	NAME		= 'VPD_311_HOME',
	FILENAME	= 'D:\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\VPD_311_HOME.mdf',
	SIZE		= 8MB,
	MAXSIZE		= 500MB,
	FILEGROWTH	= 8MB
)
LOG ON --Определяем параметры файла журнала базы данных
(
	NAME		= 'VPD_311_HOME_Log',
	FILENAME	= 'D:\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\VPD_311_HOME.ldf',
	SIZE		= 8MB,
	MAXSIZE		= 500MB,
	FILEGROWTH	= 8MB
)
GO

USE VPD_311_HOME
GO

CREATE TABLE Directions
(
	direction_id		TINYINT			PRIMARY KEY,
	direction_name		NVARCHAR(150)	NOT NULL
);
CREATE TABLE Disciplines
(
	discipline_id		SMALLINT		PRIMARY KEY,
	discipline_name		NVARCHAR(150)	NOT NULL,
	number_of_lessons	TINYINT			NOT NULL
);
CREATE TABLE Teachers
(
	teacher_id			INT				PRIMARY KEY,
	last_name			NVARCHAR(50)	NOT NULL,
	first_name			NVARCHAR(50)	NOT NULL,
	middle_name			NVARCHAR(50)		NULL,
	birth_date			DATE			NOT NULL,
	work_since			DATE			NOT NULL
);
GO

CREATE TABLE RequiredDisciplines
(
	PRIMARY KEY(discipline, required_discipline),
	discipline		SMALLINT	CONSTRAINT FK_RD_Discipline_2_Discipline	FOREIGN KEY REFERENCES Disciplines(discipline_id),
	required_discipline	SMALLINT	CONSTRAINT FK_RD_Required_2_Discpline	FOREIGN KEY REFERENCES Disciplines(discipline_id)
);
CREATE TABLE TeachersDisciplinesRelation
(
	PRIMARY KEY (teacher, discipline),
	teacher				INT			CONSTRAINT	FK_TDR_Teachers				FOREIGN KEY REFERENCES Teachers(teacher_id),
	discipline			SMALLINT	CONSTRAINT	FK_TDR_Disciplines			FOREIGN KEY REFERENCES Disciplines(discipline_id)
);
CREATE TABLE DisciplinesDirectionsRelation
(
	PRIMARY KEY (discipline, direction),
	discipline			SMALLINT	CONSTRAINT	FK_DDR_Disciplines			FOREIGN KEY REFERENCES Disciplines(discipline_id),
	direction			TINYINT		CONSTRAINT	FK_DDR_Directions			FOREIGN KEY REFERENCES Directions(direction_id)
);
GO

CREATE TABLE Groups
(
	group_id			INT				PRIMARY KEY,
	group_name			NVARCHAR(24)	NOT NULL,
	direction			TINYINT		CONSTRAINT	FK_Groups_Directions		FOREIGN KEY	REFERENCES	Directions(direction_id)
);
GO

CREATE TABLE Students
(
	student_id			INT				PRIMARY KEY,
	last_name			NVARCHAR(50)	NOT NULL,
	first_name			NVARCHAR(50)	NOT NULL,
	middle_name			NVARCHAR(50)		NULL,
	birth_date			DATE			NOT NULL,
	[group]				INT		NULL CONSTRAINT	FK_Studenst_Groups			FOREIGN KEY	REFERENCES	Groups(group_id)
);
GO

CREATE TABLE Schedule
(
	lesson_id			BIGINT			PRIMARY KEY,
	date				DATE			NOT NULL,
	time				TIME(7)			NOT NULL,
	[group]				INT				NOT NULL	CONSTRAINT	FK_Schedule_Groups			FOREIGN KEY REFERENCES	Groups(group_id),
	discipline			SMALLINT		NOT NULL	CONSTRAINT	FK_Schedule_Disciplines		FOREIGN KEY REFERENCES	Disciplines(discipline_id),
	teacher				INT				NOT NULL	CONSTRAINT	FK_Schedule_Teachers		FOREIGN KEY REFERENCES	Teachers(teacher_id),
	[subject]			NVARCHAR(256)		NULL,
	spent				BIT				NOT NULL
);
GO

CREATE TABLE Grades
(
	PRIMARY KEY	(student,lesson),
	student				INT			CONSTRAINT	FK_Grades_Students			FOREIGN KEY	REFERENCES	Students(student_id),
	lesson				BIGINT		CONSTRAINT	FK_Grades_Schedule			FOREIGN KEY	REFERENCES	Schedule(lesson_id),
	present				BIT			NOT NULL,
	grade_1				TINYINT		CONSTRAINT	CK_Grades_1					CHECK(grade_1 > 0 AND grade_1 <= 12),
	grade_2				TINYINT		CONSTRAINT	CK_Grades_2					CHECK(grade_2 > 0 AND grade_2 <= 12)
);

CREATE TABLE Exams
(
	PRIMARY KEY	(student,discipline),
	student				INT			CONSTRAINT	FK_Exams_Students			FOREIGN KEY	REFERENCES	Students(student_id),
	discipline			SMALLINT	CONSTRAINT	FK_Exams_Disciplines		FOREIGN KEY REFERENCES	Disciplines(discipline_id),
	grade				TINYINT		CONSTRAINT	CK_Exams_Grade				CHECK(grade > 0 AND grade <=12)
);
GO