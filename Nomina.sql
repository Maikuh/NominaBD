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
    TelefonoCasa char(10),
    TelefonoMovil char(10),
    CONSTRAINT PK_Direccion PRIMARY KEY (ID_Direccion),
    CONSTRAINT CHK_Codigo_Postal CHECK (Codigo_Postal NOT LIKE '%[^0-9]%')
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
    Codigo_Horario int IDENTITY(1,1) NOT NULL,
    Hora_Inicio datetime NOT NULL,
    Hora_Fin datetime NOT NULL,
    CONSTRAINT PK_Horario PRIMARY KEY (Codigo_Horario)
);

CREATE TABLE Empleado(
    Codigo_Empleado int IDENTITY(1,1) NOT NULL,
    Nombre varchar(40) NOT NULL,
    Apellido varchar(40) NOT NULL,
    Cedula char(11) NOT NULL,
    Fecha_Nacimiento date NOT NULL,
    ID_Cargo int NOT NULL,
    ID_Direccion int NOT NULL UNIQUE,
    Codigo_Horario int NOT NULL,
    CONSTRAINT PK_Empleado PRIMARY KEY (Codigo_Empleado),
    CONSTRAINT FK_Empleado_Cargo FOREIGN KEY (ID_Cargo)
    REFERENCES Cargo(ID_Cargo),
    CONSTRAINT FK_Empleado_Direccion FOREIGN KEY (ID_Direccion)
    REFERENCES Direccion(ID_Direccion),
    CONSTRAINT FK_Empleado_Horario FOREIGN KEY (Codigo_Horario)
    REFERENCES Horario(Codigo_Horario)
);

CREATE TABLE Nomina(
    Codigo_Nomina int IDENTITY(1,1) NOT NULL,
    Codigo_Empleado int NOT NULL,
    Sueldo MONEY NOT NULL,
    CONSTRAINT PK_Nomina PRIMARY KEY (Codigo_Nomina),
    CONSTRAINT FK_Nomina_Empleado FOREIGN KEY (Codigo_Empleado)
    REFERENCES Empleado(Codigo_Empleado)
);

CREATE TABLE Retencion(
    Codigo_Retencion int IDENTITY(1,1) NOT NULL,
    Codigo_Nomina int NOT NULL,
    Nombre varchar(20) NOT NULL,
    Cantidad decimal(11,2) NOT NULL,
    CONSTRAINT PK_Retencion PRIMARY KEY (Codigo_Retencion),
    CONSTRAINT FK_Nomina_Retencion FOREIGN KEY(Codigo_Nomina)
    REFERENCES Nomina(Codigo_Nomina),
    CONSTRAINT CHK_Nombre CHECK(Nombre IN ('AFP', 'SFS', 'ISR', 'Seguro Medico'))
);


insert into Direccion values ('Samana','Pueblo viejo', 'Lopez de vega', '12231', '8098094513', '809-702-3421');
insert into Direccion values ('Santo Domingo','Los Mina', 'Maria Trinidad Sanchez', '54221', '8098094513', '8097023421');
insert into Direccion values ('Santo Domingo','San Luis', 'Francisco del rosario Sanchez', '32123', '8098094513', '8097023421');
insert into Direccion values ('San Juan','Malana', 'Juan Pablo Duarte', '13121', '8098094513', '8097023421');
insert into Direccion values ('San Juan','Malana', 'Maria Trinidad Sanchez', '13121', '8098094513', '8097023421');
insert into Direccion values ('La Romana','Logg', 'Sanchez Ramirez', '16431', '8098094513', '8097023421');
insert into Direccion values ('Samana','Pueblo viejo', 'La Roma', '12231', '8098094513', '8097023421');
insert into Direccion values ('La Romana','Log', 'La Roma', '12231', '8098094513', '8097023421');

insert into Departamento values ('Recursos humanos');
insert into Departamento values ('Finanzas');
insert into Departamento values ('Publicidad');
insert into Departamento values ('Administracion');
insert into Departamento values ('Informatica');
insert into Departamento values ('Venta');
insert into Departamento values ('Direccion');

insert into Cargo values (1, 'Gerente');
insert into Cargo values (2, 'Encargado de finanzas');
insert into Cargo values (3, 'Diseñador Gráfico');
insert into Cargo values (4, 'Administrador');
insert into Cargo values (5, 'Director de proyecto');
insert into Cargo values (6, 'Vendedor');
insert into Cargo values (7, 'CEO');

insert into Horario values ('20180618 08:30:09 AM','20180618 05:30:10 PM');
insert into Horario values ('20180619 09:24:03 AM','20180618 06:15:05 PM');
insert into Horario values ('20180618 10:01:02 AM','20180618 06:50:12 PM');
insert into Horario values ('20180618 07:34:09 AM','20180618 05:15:00 PM');
insert into Horario values ('20180618 08:30:09 AM','20180618 07:10:08 PM');
insert into Horario values ('20180618 08:00:02 AM','20180618 05:30:00 PM');
insert into Horario values ('20180618 09:00:15 AM','20180618 06:10:05 PM');


insert into Empleado values ('Estefania','Peralta','40225432123', '1998-02-12', 2, 3, 4);
insert into Empleado values ('Winston','Cruz','43203223111', '1995-12-21', 7, 2, 1);
insert into Empleado values ('Miguel','Araujo','53203223112', '1998-11-16', 6, 5, 6);
insert into Empleado values ('Erick','Pimentel','40203324692', '1999-02-21', 1, 6, 1);
insert into Empleado values ('Arianna','Diaz','40226715091', '1998-08-02', 4, 2, 7);
insert into Empleado values ('Dayhana','Cruz','40324755291', '1998-06-01', 3, 7, 4);
insert into Empleado values ('Alberkys','Santana','40322355291', '1998-05-26', 3, 8, 7);
insert into Empleado values ('Brian','Correa','4032233291', '1994-01-31', 6, 3, 6);

insert into Nomina values (1, '50000.00');
insert into Nomina values (2, '100000.00');
insert into Nomina values (3, '20000.00');
insert into Nomina values (4, '60000.00');
insert into Nomina values (5, '65000.00');
insert into Nomina values (6, '45000.00');
insert into Nomina values (7, '70000.00');

insert into Retencion values (1, 'AFP', 100.00);
insert into Retencion values (1, 'SFS', 120.00);
insert into Retencion values (1, 'ISR', 130.00);
insert into Retencion values (1, 'Seguro Medico', 1500.30);

insert into Retencion values (2, 'AFP', 200.00);
insert into Retencion values (2, 'SFS', 220.00);
insert into Retencion values (2, 'ISR', 50.00);
insert into Retencion values (2, 'Seguro Medico', 1000.00);

insert into Retencion values (3, 'AFP', 80.00);
insert into Retencion values (3, 'SFS', 30.00);
insert into Retencion values (3, 'ISR', 40.00);
insert into Retencion values (3, 'Seguro Medico', 500.50);

insert into Retencion values (4, 'AFP', 90.00);
insert into Retencion values (4, 'SFS', 100.00);
insert into Retencion values (4, 'ISR', 120.00);
insert into Retencion values (4, 'Seguro Medico', 800.40);

insert into Retencion values (5, 'AFP', 110.00);
insert into Retencion values (5, 'SFS', 120.00);
insert into Retencion values (5, 'ISR', 130.00);
insert into Retencion values (5, 'Seguro Medico', 1800.20);

insert into Retencion values (6, 'AFP', 50.00);
insert into Retencion values (6, 'SFS', 80.00);
insert into Retencion values (6, 'ISR', 110.00);
insert into Retencion values (6, 'Seguro Medico', 500.30);

insert into Retencion values (7, 'AFP', 70.00);
insert into Retencion values (7, 'SFS', 115.00);
insert into Retencion values (7, 'ISR', 100.00);
insert into Retencion values (7, 'Seguro Medico', 650.40);

insert into Retencion values (8, 'AFP', 90.00);
insert into Retencion values (8, 'SFS', 150.00);
insert into Retencion values (8, 'ISR', 180.00);
insert into Retencion values (8, 'Seguro medico', 850.50);

