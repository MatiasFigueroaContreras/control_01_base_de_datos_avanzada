INSERT INTO public.comuna (nombre)
VALUES ('Santiago'), 
       ('San Ramon'), 
       ('Estacion Central'), 
       ('La Cisterna'), 
       ('La Pintana'), 
       ('Providencia'), 
       ('Cerrillos'), 
       ('El Bosque'), 
       ('Maipu'), 
       ('Las Condes'), 
       ('La Florida'), 
       ('San Miguel'), 
       ('Pedro Aguirre Cerda'), 
       ('Cerrillos'), 
       ('Renca'), 
       ('La Granja'), 
       ('Recoleta'), 
       ('La Reina'), 
       ('Lo Espejo'), 
       ('Vitacura');


INSERT INTO public.colegio (id_comuna, nombre)
SELECT trunc((random()*19) + 1),
       'Colegio ' || generate_series(1, 100) as name;

WITH parentezco_list as
    (SELECT '{padre, madre, abuelo, abuela, tio, tia}'::VARCHAR(50)[] parentezco),
     sexo_list as
    (SELECT '{mujer, hombre}'::VARCHAR(50)[] sexo),
     series as
    (SELECT generate_series(1, 100) as n,
            MOD(cast(trunc(random()*6) as int), 6) + 1 as random)

INSERT INTO public.apoderado (id_comuna, nombre, parentezco, sexo, edad)
SELECT trunc((random()*19) + 1),
       'Apoderado ' || series.n as name,
       parentezco[series.random],
       sexo[MOD(series.random, 2) + 1],
       cast(trunc(random()*40 + 20) as int)
FROM parentezco_list,
     sexo_list,
     series;

WITH apoderado_colegio_list as
    (SELECT a.id_apoderado,
            a.id_comuna,
            c.id_colegio,
            ROW_NUMBER() OVER (
                               ORDER BY random()) as row_number
     FROM apoderado a,
          colegio c
     WHERE c.id_comuna = a.id_comuna
     ORDER BY random()
     LIMIT 150),
     sexo_list as
    (SELECT '{mujer, hombre}'::VARCHAR(50)[] sexo)

INSERT INTO public.alumno (id_apoderado, id_comuna, id_colegio, edad, sexo, nombre)
SELECT acl.id_apoderado,
       acl.id_comuna,
       acl.id_colegio,
       cast(trunc(random()*15 + 5) as int),
       sexo[MOD(cast(trunc(random()*2) as int), 2) + 1],
       'Alumno ' || acl.row_number as name
FROM apoderado_colegio_list acl,
     sexo_list;


INSERT INTO public.curso (nombre)
VALUES ('Lenguaje'), 
       ('Matematicas'), 
       ('Ingles'), 
       ('Religion'), 
       ('Quimica'), 
       ('Biologia'), 
       ('Tecnologia'), 
       ('Fisica'), 
       ('Educacion Fisica'), 
       ('Historia'), 
       ('Musica'), 
       ('Artes'),
       ('Filosofia');


WITH rol_list as 
    (SELECT '{profesor, auxiliar, secretario, coordinador}'::VARCHAR(50)[] rol),
    colegio_list as 
    (SELECT c.id_colegio,
            ROW_NUMBER() OVER (
                               ORDER BY random()) as row_number
     FROM colegio c
     ORDER BY random()
     LIMIT 150),
    sexo_list as
    (SELECT '{mujer, hombre}'::VARCHAR(50)[] sexo),
    series as
    (SELECT generate_series(1, 10) as n,
            MOD(cast(trunc(random()*4) as int), 4) + 1 as random)
     
INSERT INTO public.empleado (id_colegio, nombre, rol, sexo)
SELECT cl.id_colegio,
       'Empleado ' || cl.row_number || cl.id_colegio as name,
       rol[series.random],
       sexo[MOD(cast(trunc(random()*2) as int), 2) + 1]
FROM   rol_list,
        colegio_list cl,
        sexo_list,
        series;

INSERT INTO public.sueldo (id_empleado, cantidad)
SELECT e.id_empleado,
       cast(trunc(random()*600000 + 500000) as int)
FROM empleado e;

INSERT INTO public.asistencia (cantidad, ano, id_alumno)
SELECT cast(trunc(random()*100) as int),
       '2019-01-01'::date + cast(trunc(random()*365) as int),
       a.id_alumno
FROM alumno a;

INSERT INTO public.profesor (id_empleado, correo)
SELECT e.id_empleado,
       'profesor' || e.id_empleado || '@mmail.com' as correo
FROM empleado e;

INSERT INTO public.franja_horaria(cantidad_horas)
SELECT 1 + cast(trunc(random()*5) as int);