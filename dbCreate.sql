CREATE DATABASE colegiosdb
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

CREATE TABLE colegiosdb.schemas.sueldo (
    id_sueldo int NOT NULL,
    id_empleado int,
    cantidad int,
    PRIMARY KEY (id_sueldo)
    CONSTRAINT
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE colegiosdb.schemas.empleado (
    id_empleado int NOT NULL,
    id_colegio int,
    nombre varchar(50),
    rol varchar(50),
    sexo varchar(50),
    PRIMARY KEY (id_empleado)
    CONSTRAINT
        FOREING KEY (id_colegio) REFERENCES sueldo(id_colegio)
);

CREATE TABLE colegiosdb.schemas.profesor (
    id_profesor int NOT NULL,
    id_empleado int,
    correo varchar(50),
    PRIMARY KEY (id_profesor)
    CONSTRAINT
        FOREING KEY (id_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE colegiosdb.schemas.colegio (
    id_colegio int NOT NULL,
    id_comuna int,
    nombre varchar(50) NOT NULL,
    PRIMARY KEY (id_colegio)
    CONSTRAINT
        FOREING KEY (id_comuna) REFERENCES comuna(id_comuna)
);

CREATE TABLE colegiosdb.schemas.prof_curso (
    id_prof_curso int NOT NULL,
    id_profesor int,
    id_curso int,
    jefe BOOLEAN,
    PRIMARY KEY (id_prof_curso)
    CONSTRAINT
        FOREING KEY (id_profesor) REFERENCES profesor(id_profesor)
        FOREING KEY (id_curso) REFERENCES curso(id_curso)
);

CREATE TABLE colegiosdb.schemas.franja_horaria (
    id_frangah int NOT NULL,
    cantidad_horas int,
    PRIMARY KEY (id_frangah)
);

CREATE TABLE colegiosdb.schemas.asistencia (
    id_asistencia int NOT NULL,
    cantidad int,
    ano date,
    PRIMARY KEY (id_asistencia)
);

CREATE TABLE colegiosdb.schemas.comuna (
    id_comuna int NOT NULL,
    nombre varchar(50),
    PRIMARY KEY (id_comuna)
);

CREATE TABLE colegiosdb.schemas.curso (
    id_curso int NOT NULL,
    nombre varchar(50),
    PRIMARY KEY (id_curso)
);

CREATE TABLE colegiosdb.schemas.alu_curso (
    id_alu_curso int NOT NULL,
    id_alumno int,
    id_curso int,
    id_asistencia int,
    PRIMARY KEY (id_alu_curso)
    CONSTRAINT
        FOREING KEY (id_alumno) REFERENCES alumno(id_alumno)
        FOREING KEY (id_curso) REFERENCES curso(id_curso)
        FOREING KEY (id_asistencia) REFERENCES asistencia(id_asistencia)
);

CREATE TABLE colegiosdb.schemas.alumno (
    id_alumno int NOT NULL,
    id_apoderado int,
    id_comuna int,
    id_colegio int,
    edad int,
    sexo varchar(50),
    nombre varchar(50),
    PRIMARY KEY (id_alumno)
    CONSTRAINT
        FOREING KEY (id_apoderado) REFERENCES apoderado(id_apoderado)
        FOREING KEY (id_comuna) REFERENCES comuna(id_comuna)
        FOREING KEY (id_colegio) REFERENCES colegio(id_colegio)
);

CREATE TABLE colegiosdb.schemas.plantilla_curso (
    id_plantilla_curso int NOT NULL,
    id_curso int,
    PRIMARY KEY (id_plantilla_curso)
    CONSTRAINT
        FOREING KEY (id_curso) REFERENCES curso(id_curso)
);

CREATE TABLE colegiosdb.schemas.apoderado (
    id_apoderado int NOT NULL,
    id_comuna int,
    parentezco varchar(50),
    sexo varchar(50),
    edad int,
    PRIMARY KEY (id_apoderado)
    CONSTRAINT
        FOREING KEY (id_comuna) REFERENCES comuna(id_comuna)
);