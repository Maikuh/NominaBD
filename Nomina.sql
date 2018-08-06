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
	Fecha Date NOT NULL,
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

--Data Inserts

insert into Direccion values ('Samana','Pueblo viejo', 'Lopez de vega', '12231', '8098094513', '8097023421'),
('Santo Domingo','Los Mina', 'Maria Trinidad Sanchez', '54221', '8098094513', '8097023421'),
('Santo Domingo','San Luis', 'Francisco del rosario Sanchez', '32123', '8098094513', '8097023421'),
('San Juan','Malana', 'Juan Pablo Duarte', '13121', '8098094513', '8097023421'),
('San Juan','Malana', 'Maria Trinidad Sanchez', '13121', '8098094513', '8097023421'),
('La Romana','Logg', 'Sanchez Ramirez', '16431', '8098094513', '8097023421'),
('Samana','Pueblo viejo', 'La Roma', '12231', '8098094513', '8097023421'),
('La Romana','Log', 'La Roma', '12231', '8098094513', '8097023421');

insert into Departamento values ('Recursos humanos'),
('Finanzas'),
('Publicidad'),
('Administracion'),
('Informatica'),
('Venta'),
('Direccion');

insert into Cargo values (1, 'Gerente'),
(2, 'Encargado de finanzas'),
(3, 'Diseï¿½ador Grï¿½fico'),
(4, 'Administrador'),
(5, 'Director de proyecto'),
(6, 'Vendedor'),
(7, 'CEO');

insert into Horario values ('20180618 08:30:09 AM','20180618 05:30:10 PM'),
('20180619 09:24:03 AM','20180618 06:15:05 PM'),
('20180618 10:01:02 AM','20180618 06:50:12 PM'),
('20180618 07:34:09 AM','20180618 05:15:00 PM'),
('20180618 08:30:09 AM','20180618 07:10:08 PM'),
('20180618 08:00:02 AM','20180618 05:30:00 PM'),
('20180618 09:00:15 AM','20180618 06:10:05 PM');


insert into Empleado values ('Estefania','Peralta','40225432123', '1998-02-12', 2, 3, 4),
('Winston','Cruz','43203223111', '1995-12-21', 7, 2, 1),
('Miguel','Araujo','53203223112', '1998-11-16', 6, 5, 6),
('Erick','Pimentel','40203324692', '1999-02-21', 1, 6, 1),
('Arianna','Diaz','40226715091', '1998-08-02', 4, 1, 7),
('Dayhana','Cruz','40324755291', '1998-06-01', 3, 7, 4),
('Alberkys','Santana','40322355291', '1998-05-26', 3, 8, 7),
('Brian','Correa','4032233291', '1994-01-31', 6, 4, 6);

insert into Nomina values (1, '50000.00', '2018-07-31'), 
(2, '100000.00', '2018-07-31'),
(3, '20000.00', '2018-07-31'),
(4, '60000.00', '2018-07-31'),
(5, '65000.00', '2018-07-31'),
(6, '45000.00', '2018-07-31'),
(7, '70000.00', '2018-07-31');

INSERT INTO Nomina VALUES (1, '50000.00', '2018-08-31'),
(2, '98000.00', '2018-08-31'),
(3, '22000.00', '2018-08-31'),
(4, '60000.00', '2018-08-31'),
(5, '63000.00', '2018-08-31'),
(6, '47000.00', '2018-08-31'),
(7, '68000.00', '2018-08-31');

insert into Retencion values (1, 'AFP', 100.00),
(1, 'SFS', 120.00),
(1, 'ISR', 130.00),
(1, 'Seguro Medico', 1500.30);

insert into Retencion values (2, 'AFP', 200.00),
(2, 'SFS', 220.00),
(2, 'ISR', 50.00),
(2, 'Seguro Medico', 1000.00);

insert into Retencion values (3, 'AFP', 80.00),
(3, 'SFS', 30.00),
(3, 'ISR', 40.00),
(3, 'Seguro Medico', 500.50);

insert into Retencion values (4, 'AFP', 90.00),
(4, 'SFS', 100.00),
(4, 'ISR', 120.00),
(4, 'Seguro Medico', 800.40);

insert into Retencion values (5, 'AFP', 110.00),
(5, 'SFS', 120.00),
(5, 'ISR', 130.00),
(5, 'Seguro Medico', 1800.20);

insert into Retencion values (6, 'AFP', 50.00),
(6, 'SFS', 80.00),
(6, 'ISR', 110.00),
(6, 'Seguro Medico', 500.30);

insert into Retencion values (7, 'AFP', 70.00),
(7, 'SFS', 115.00),
(7, 'ISR', 100.00),
(7, 'Seguro Medico', 650.40);

insert into Retencion values (8, 'AFP', 100.00),
(8, 'SFS', 120.00), 
(8, 'ISR', 130.00), 
(8, 'Seguro Medico', 1500.30);

insert into Retencion values (9, 'AFP', 200.00),
(9, 'SFS', 220.00), 
(9, 'ISR', 50.00), 
(9, 'Seguro Medico', 1000.00);

insert into Retencion values (10, 'AFP', 80.00),
(10, 'SFS', 30.00), 
(10, 'ISR', 40.00), 
(10, 'Seguro Medico', 500.50);

insert into Retencion values (11, 'AFP', 90.00),
(11, 'SFS', 100.00), 
(11, 'ISR', 120.00), 
(11, 'Seguro Medico', 800.40);

insert into Retencion values (12, 'AFP', 110.00),
(12, 'SFS', 120.00), 
(12, 'ISR', 130.00), 
(12, 'Seguro Medico', 1800.20);

insert into Retencion values (13, 'AFP', 50.00), 
(13, 'SFS', 80.00), 
(13, 'ISR', 110.00), 
(13, 'Seguro Medico', 500.30);

insert into Retencion values (14, 'AFP', 70.00),
(14, 'SFS', 115.00),
(14, 'ISR', 100.00),
(14, 'Seguro Medico', 650.40);

--Views

Create View Horario_por_Departamento 
as 
select D.Nombre, Hora_Inicio, Hora_Fin 
from Horario H, Departamento D, Empleado E 
where H.Codigo_Horario = E.Codigo_Horario and D.Codigo_Departamento = E.ID_Cargo 

Select * from Horario_por_Departamento

Create View Direccion_De_Empleado
as
select Nombre, Provincia, Sector, Calle
from Empleado, Direccion

Create View Sueldo_Por_Cargo
as
select Sueldo, C.Nombre
from Nomina N, Cargo C, Empleado E
where N.Codigo_Nomina = E.ID_Cargo and N.Codigo_Empleado = C.ID_Cargo

Select * from Sueldo_Por_Cargo
--Triggers


Create Trigger Actualizar_Sueldo_Empleado
on Nomina.Sueldo for update
as 


Create Trigger Seguridad_Datos
On Database
For Drop_Table, Alter_Table
as 
Print 'Desactive el trigger de seguridad para eliminar o modificar las tablas de la base de datos'
Rollback;


Create Trigger Notificacion_Modificacion_Nomina
on Empleado
AFTER INSERT, UPDATE, DELETE
AS
EXEC sp_send_dbmail 
@profile_name='Notificación', 
@recipients='arliiin23@gmail.com', 
@subject='Modificación de Nómina', 
@body='Se ha realizado cambios en la nómina, el sueldo del empleado (name) del departamento (name) ha sido modificado.'
GO

--Stored Procedure

Create Procedure dbo.Ingresar_Direccion_Empleado

@Provincia varchar(50), 
@Sector varchar(50),
@Calle varchar(50),
@Codigo_Postal char(5),
@TelefonoCasa char(10),
@TelefonoMovil char(10)

As

SET NOCOUNT ON

INSERT INTO [dbo].[Direccion]
           ([Provincia]
           ,[Sector]
           ,[Calle]
           ,[Codigo_Postal]
           ,[TelefonoCasa]
           ,[TelefonoMovil])
     VALUES
           (@Provincia
           ,@Sector
           ,@Calle
           ,@Codigo_Postal
           ,@TelefonoCasa
           ,@TelefonoMovil)
GO

Create procedure dbo.Ingresar_Departamento

@Codigo_Departamento int,
@Nombre_Departamento varchar(50)

as

set nocount on

insert into [dbo].[Departamento]
([Codigo_Departamento],
[Nombre])

values
(@Codigo_Departamento,
@Nombre_Departamento)

Go

Create procedure dbo.Ingresar_Nomina_Empleado
@Codigo_Empleado int,
@Sueldo money,
@Fecha date

as

set nocount on

insert into [dbo].[Nomina] 
([Codigo_Empleado],
[Sueldo],
[Fecha]
)

values 
(@Codigo_Empleado,
@Sueldo, 
@Fecha
)

Go


--Function

Create Function Sueldo_Final (@Sueldo int, @Cantidad int)
Returns int
as
Begin
	Declare @Sueldo_Final int
	Set @Sueldo_Final = @Sueldo - @Cantidad
	Return (select @Sueldo_Final)
End

Create Function Sueldo_Anual (@Sueldo int)
Returns int
as
Begin
     Declare @Sueldo_Anual int
	 Set @Sueldo_Anual = @Sueldo * 12
	 Return (Select @Sueldo_Anual)
End


Create Function Sueldo_Quincenal (@Sueldo int)
Returns int
as
Begin
   Declare @Sueldo_Quincenal int
   Set @Sueldo_Quincenal = @Sueldo/2 
   Return (Select @Sueldo_Quincenal)
End

