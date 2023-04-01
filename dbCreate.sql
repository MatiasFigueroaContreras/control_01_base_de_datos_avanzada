-- Crear database
DROP DATABASE IF EXISTS colegiosdb;

CREATE DATABASE colegiosdb
	WITH 
	OWNER = postgres 
	ENCODING = 'UTF8' 
	LC_COLLATE = 'Spanish_Chile.1252' 
	LC_CTYPE = 'Spanish_Chile.1252' 
	TABLESPACE = pg_default 
	CONNECTION LIMIT = -1 
	IS_TEMPLATE = False; 
 
COMMENT ON DATABASE colegiosdb 
	IS 'control 1 base de datos';

--- Escribir el siguiente comando en el SQL Shell, 
---  para utilizar la base de datos creada
--- \c colegiosdb

-- Tablas de la base de datos 
-- se ponen en el query 
-- lo de arriba no  

CREATE TABLE IF NOT EXISTS colegiosdb.public.comuna (
    id_comuna SERIAL NOT NULL,
    nombre varchar(50),
    PRIMARY KEY (id_comuna)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.colegio (
    id_colegio SERIAL NOT NULL,
    id_comuna int,
    nombre varchar(50) NOT NULL,
    PRIMARY KEY (id_colegio),
    CONSTRAINT fk_colegio_comuna FOREIGN KEY (id_comuna) REFERENCES colegiosdb.public.comuna(id_comuna)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.curso (
    id_curso SERIAL NOT NULL,
    nombre varchar(50),
    PRIMARY KEY (id_curso)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.plantilla_curso (
    id_plantilla_curso SERIAL NOT NULL,
    id_curso int,
    PRIMARY KEY (id_plantilla_curso),
    CONSTRAINT fk_plantilla_curso_curso
    	FOREIGN KEY (id_curso) REFERENCES colegiosdb.public.curso(id_curso)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.apoderado (
    id_apoderado SERIAL NOT NULL,
    id_comuna int,
    parentezco varchar(50),
    sexo varchar(50),
    edad int,
    PRIMARY KEY (id_apoderado),
    FOREIGN KEY (id_comuna) REFERENCES colegiosdb.public.comuna(id_comuna)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.alumno (
    id_alumno SERIAL NOT NULL,
    id_apoderado int,
    id_comuna int,
    id_colegio int,
    edad int,
    sexo varchar(50),
    nombre varchar(50),
    PRIMARY KEY (id_alumno),
    FOREIGN KEY (id_apoderado) REFERENCES colegiosdb.public.apoderado(id_apoderado),
    FOREIGN KEY (id_comuna) REFERENCES colegiosdb.public.comuna(id_comuna),
    FOREIGN KEY (id_colegio) REFERENCES colegiosdb.public.colegio(id_colegio)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.asistencia (
    id_asistencia SERIAL NOT NULL,
    cantidad int,
    ano date,
    PRIMARY KEY (id_asistencia)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.alu_curso (
    id_alu_curso SERIAL NOT NULL,
    id_alumno int,
    id_curso int,
    id_asistencia int,
    PRIMARY KEY (id_alu_curso),
    CONSTRAINT fk_alu_curso_alumno FOREIGN KEY (id_alumno) REFERENCES colegiosdb.public.alumno(id_alumno),
    CONSTRAINT fk_alu_curso_curso FOREIGN KEY (id_curso) REFERENCES colegiosdb.public.curso(id_curso),
    CONSTRAINT fk_alu_curso_asistencia FOREIGN KEY (id_asistencia) REFERENCES colegiosdb.public.asistencia(id_asistencia)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.empleado (
    id_empleado SERIAL NOT NULL,
    id_colegio int,
    nombre varchar(50),
    rol varchar(50),
    sexo varchar(50),
    PRIMARY KEY (id_empleado),
    CONSTRAINT fk_empleado_colegio FOREIGN KEY (id_colegio) REFERENCES colegiosdb.public.colegio(id_colegio)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.sueldo (
    id_sueldo SERIAL NOT NULL,
    id_empleado int,
    cantidad int,
    PRIMARY KEY (id_sueldo),
    CONSTRAINT fk_sueldo_empleado FOREIGN KEY (id_empleado) REFERENCES colegiosdb.public.empleado(id_empleado)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.profesor (
    id_profesor SERIAL NOT NULL,
    id_empleado int,
    correo varchar(50),
    PRIMARY KEY (id_profesor),
    CONSTRAINT fk_profesor_empleado FOREIGN KEY (id_empleado) REFERENCES colegiosdb.public.empleado(id_empleado)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.franja_horaria (
    id_franja_horaria SERIAL NOT NULL,
    cantidad_horas int,
    PRIMARY KEY (id_franja_horaria)
);

CREATE TABLE IF NOT EXISTS colegiosdb.public.prof_curso (
    id_prof_curso SERIAL NOT NULL,
    id_profesor int,
    id_curso int,
	id_franja_horaria int,
    jefe BOOLEAN,
    PRIMARY KEY (id_prof_curso),
    CONSTRAINT fk_prof_curso_profesor FOREIGN KEY (id_profesor) REFERENCES colegiosdb.public.profesor(id_profesor),
    CONSTRAINT fk_prof_curso_curso FOREIGN KEY (id_curso) REFERENCES colegiosdb.public.curso(id_curso),
	CONSTRAINT fk_prof_curso_franja_horaria FOREIGN KEY (id_franja_horaria) REFERENCES colegiosdb.public.franja_horaria(id_franja_horaria)
);
