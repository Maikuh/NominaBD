USE master
GO

-- This section is for developing purposes
-- This kills any connection for databse "Nomina"
-- In case they exist, allowing to then drop the DB
DECLARE @kill varchar(8000) = '';
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), spid) + ';'
FROM master..sysprocesses 
WHERE dbid = db_id('Nomina')

EXEC(@kill);
GO

-- Drop then recreate the Database
DROP DATABASE IF EXISTS Nomina
GO

CREATE DATABASE Nomina
GO

-- Create these tables in Nomina DB
USE Nomina;
GO

CREATE TABLE Direccion(
    ID_Direccion int IDENTITY(1,1) NOT NULL,
    Provincia varchar(50) NOT NULL,
    Sector varchar(50) NOT NULL,
    Calle varchar(50) NOT NULL,
    Codigo_Postal char(5) NOT NULL,
    CONSTRAINT PK_Direccion PRIMARY KEY (ID_Direccion),
    CONSTRAINT CHK_Codigo_Postal CHECK (Codigo_Postal NOT LIKE '%[^0-9]%')
);

CREATE TABLE Telefono(
    Numero_Telefono char(10) NOT NULL,
    ID_Direccion int NOT NULL,
    CONSTRAINT PK_Telefono PRIMARY KEY (Numero_Telefono),
    CONSTRAINT FK_Telefono_Direccion FOREIGN KEY (ID_Direccion) 
    REFERENCES Direccion(ID_Direccion),
    CONSTRAINT CHK_Numero CHECK (Numero_Telefono NOT LIKE '%[^0-9]%')
);

CREATE TABLE Departamento(
    Codigo_Departamento int IDENTITY(1,1) NOT NULL,
    Nombre varchar(50) NOT NULL,
    CONSTRAINT PK_Departamento PRIMARY KEY(Codigo_Departamento)
);


CREATE TABLE Cargo(
    ID_Cargo int IDENTITY(1,1) NOT NULL,
    Codigo_Departamento int NOT NULL,
    Nombre varchar(50) NOT NULL,
    CONSTRAINT PK_Cargo PRIMARY KEY (ID_Cargo),
    CONSTRAINT FK_Cargo_Departamento FOREIGN KEY (Codigo_Departamento)
    REFERENCES Departamento(Codigo_Departamento)
);

CREATE TABLE Horario(
    Codigo_Horario int NOT NULL,
    Hora_Inicio time(0) NOT NULL,
    Hora_Fin time(0) NOT NULL,
    CONSTRAINT PK_Horario PRIMARY KEY (Codigo_Horario)
);

CREATE TABLE Empleado(
    Codigo_Empleado int IDENTITY(1,1) NOT NULL,
    Nombre varchar(40) NOT NULL,
    Apellido varchar(40) NOT NULL,
    Cedula char(11) NOT NULL,
    Fecha_Nacimiento date NOT NULL,
    ID_Cargo int NOT NULL,
    ID_Direccion int NOT NULL,
    Codigo_Horario int NOT NULL,
    CONSTRAINT PK_Empleado PRIMARY KEY (Codigo_Empleado),
    CONSTRAINT FK_Empleado_Cargo FOREIGN KEY (ID_Cargo)
    REFERENCES Cargo(ID_Cargo),
    CONSTRAINT FK_Empleado_Direccion FOREIGN KEY (ID_Direccion)
    REFERENCES Direccion(ID_Direccion),
    CONSTRAINT FK_Empleado_Horario FOREIGN KEY (Codigo_Horario)
    REFERENCES Horario(Codigo_Horario)
);

CREATE TABLE Asistencia(
    ID_Asistencia int IDENTITY(1,1) NOT NULL,
    Horas_Cumplidas tinyint NOT NULL,
    Horas_Extras tinyint NOT NULL,
    Codigo_Empleado int NOT NULL,
    Fecha date NOT NULL,
    CONSTRAINT PK_Asistencia PRIMARY KEY (ID_Asistencia),
    CONSTRAINT FK_Codigo_Empleado FOREIGN KEY (Codigo_Empleado)
    REFERENCES Empleado(Codigo_Empleado)
);

CREATE TABLE Suplemento(
    Codigo_Suplemento int IDENTITY(1,1) NOT NULL,
    Nombre varchar(20) NOT NULL,
    Cantidad decimal(11,2) NOT NULL,
    Tipo varchar(20) NOT NULL
    CONSTRAINT PK_Suplemento FOREIGN KEY (Codigo_Suplemento)
);

CREATE TABLE Nomina(
    Codigo_Nomina int IDENTITY(1,1) NOT NULL,
    Codigo_Suplemento int NOT NULL,
    Codigo_Empleado int NOT NULL,
    Sueldo MONEY NOT NULL,
    CONSTRAINT PK_Nomina PRIMARY KEY (Codigo_Nomina),
    CONSTRAINT FK_Nomina_Suplemento FOREIGN KEY (Codigo_Suplemento)
    REFERENCES Suplemento(Codigo_Suplemento),
    CONSTRAINT FK_Nomina_Empleado FOREIGN KEY (Codigo_Empleado)
    REFERENCES Empleado(Codigo_Empleado)
);

CREATE TABLE Comprobante(
    Codigo_Comprobante int NOT NULL,
    Codigo_Empleado int NOT NULL,
    CONSTRAINT FK_Comprobante_Empleado FOREIGN KEY (Codigo_Empleado) REFERENCES Empleado(Codigo_Empleado)
);

CREATE TABLE Suplemento_Nomina
(
    Codigo_Suplemento int NOT NULL,
    Codigo_Nomina int NOT NULL,
    CONSTRAINT FK Suplemento_Nomina PRIMARY KEY
    (Codigo_Suplemento,
     Codigo_Nomina
    ),
    FOREIGN KEY (Codigo_Suplemento) REFERENCES Suplemento (Codigo_Suplemento),
    FOREIGN KEY (Codigo_Nomina) REFERENCES Nomina (Codigo_Nomina),
   
);
