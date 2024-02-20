/*
Enter custom T-SQL here that would run after SQL Server has started up.
*/

CREATE TABLE tempdb.dbo.TestTable (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Name NVARCHAR(50)
);
GO
