USE master
GO

DECLARE @kill varchar(8000) = '';
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), spid) + ';'
FROM master..sysprocesses 
WHERE dbid = db_id('Nomina')

EXEC(@kill);

DROP DATABASE IF EXISTS Nomina
GO

CREATE DATABASE Nomina
GO

USE Nomina;