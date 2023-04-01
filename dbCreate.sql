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

-- Tablas de la base de datos
-- se ponen en el query
-- lo de arriba no 

CREATE TABLE colegiosdb.schemas.comuna (
    id_comuna int NOT NULL,
    nombre varchar(50),
    PRIMARY KEY (id_comuna)
);

CREATE TABLE colegiosdb.schemas.colegio (
    id_colegio int NOT NULL,
    id_comuna int,
    nombre varchar(50) NOT NULL,
    PRIMARY KEY (id_colegio),
    CONSTRAINT fk_colegio_comuna FOREIGN KEY (id_comuna) REFERENCES colegiosdb.schemas.comuna(id_comuna)
);

CREATE TABLE colegiosdb.schemas.curso (
    id_curso int NOT NULL,
    nombre varchar(50),
    PRIMARY KEY (id_curso)
);

CREATE TABLE colegiosdb.schemas.plantilla_curso (
    id_plantilla_curso int NOT NULL,
    id_curso int,
    PRIMARY KEY (id_plantilla_curso),
    CONSTRAINT fk_plantilla_curso_curso
    	FOREIGN KEY (id_curso) REFERENCES colegiosdb.schemas.curso(id_curso)
);

CREATE TABLE colegiosdb.schemas.apoderado (
    id_apoderado int NOT NULL,
    id_comuna int,
    parentezco varchar(50),
    sexo varchar(50),
    edad int,
    PRIMARY KEY (id_apoderado),
    FOREIGN KEY (id_comuna) REFERENCES colegiosdb.schemas.comuna(id_comuna)
);

CREATE TABLE colegiosdb.schemas.alumno (
    id_alumno int NOT NULL,
    id_apoderado int,
    id_comuna int,
    id_colegio int,
    edad int,
    sexo varchar(50),
    nombre varchar(50),
    PRIMARY KEY (id_alumno),
    FOREIGN KEY (id_apoderado) REFERENCES colegiosdb.schemas.apoderado(id_apoderado),
    FOREIGN KEY (id_comuna) REFERENCES colegiosdb.schemas.comuna(id_comuna),
    FOREIGN KEY (id_colegio) REFERENCES colegiosdb.schemas.colegio(id_colegio)
);

CREATE TABLE colegiosdb.schemas.asistencia (
    id_asistencia int NOT NULL,
    cantidad int,
    ano date,
    PRIMARY KEY (id_asistencia)
);

CREATE TABLE colegiosdb.schemas.alu_curso (
    id_alu_curso int NOT NULL,
    id_alumno int,
    id_curso int,
    id_asistencia int,
    PRIMARY KEY (id_alu_curso),
    CONSTRAINT fk_alu_curso_alumno FOREIGN KEY (id_alumno) REFERENCES colegiosdb.schemas.alumno(id_alumno),
    CONSTRAINT fk_alu_curso_curso FOREIGN KEY (id_curso) REFERENCES colegiosdb.schemas.curso(id_curso),
    CONSTRAINT fk_alu_curso_asistencia FOREIGN KEY (id_asistencia) REFERENCES colegiosdb.schemas.asistencia(id_asistencia)
);

CREATE TABLE colegiosdb.schemas.empleado (
    id_empleado int NOT NULL,
    id_colegio int,
    nombre varchar(50),
    rol varchar(50),
    sexo varchar(50),
    PRIMARY KEY (id_empleado),
    CONSTRAINT fk_empleado_colegio FOREIGN KEY (id_colegio) REFERENCES colegiosdb.schemas.colegio(id_colegio)
);

CREATE TABLE colegiosdb.schemas.sueldo (
    id_sueldo int NOT NULL,
    id_empleado int,
    cantidad int,
    PRIMARY KEY (id_sueldo),
    CONSTRAINT fk_sueldo_empleado FOREIGN KEY (id_empleado) REFERENCES colegiosdb.schemas.empleado(id_empleado)
);

CREATE TABLE colegiosdb.schemas.profesor (
    id_profesor int NOT NULL,
    id_empleado int,
    correo varchar(50),
    PRIMARY KEY (id_profesor),
    CONSTRAINT fk_profesor_empleado FOREIGN KEY (id_empleado) REFERENCES colegiosdb.schemas.empleado(id_empleado)
);

CREATE TABLE colegiosdb.schemas.franja_horaria (
    id_franja_horaria int NOT NULL,
    cantidad_horas int,
    PRIMARY KEY (id_franja_horaria)
);

CREATE TABLE colegiosdb.schemas.prof_curso (
    id_prof_curso int NOT NULL,
    id_profesor int,
    id_curso int,
	id_franja_horaria int,
    jefe BOOLEAN,
    PRIMARY KEY (id_prof_curso),
    CONSTRAINT fk_prof_curso_profesor FOREIGN KEY (id_profesor) REFERENCES colegiosdb.schemas.profesor(id_profesor),
    CONSTRAINT fk_prof_curso_curso FOREIGN KEY (id_curso) REFERENCES colegiosdb.schemas.curso(id_curso),
	CONSTRAINT fk_prof_curso_franja_horaria FOREIGN KEY (id_franja_horaria) REFERENCES colegiosdb.schemas.franja_horaria(id_franja_horaria)
);
