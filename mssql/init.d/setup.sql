USE master;
GO

RAISERROR('NOT EXISTS USER SETUP SCRIPT', 20, -1) WITH LOG

/*
Enter custom T-SQL here that would run after SQL Server has started up.

IF EXISTS (SELECT name FROM sys.databases WHERE name = '$DATABASE_NAME') BEGIN
	RAISERROR('ALREADY EXISTS DATABASE: $DATABASE_NAME', 20, -1) WITH LOG
END
*/
