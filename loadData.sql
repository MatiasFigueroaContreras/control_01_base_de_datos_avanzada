-- Inserta comunas conocidas
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


-- Inserta colegios en comunas random
INSERT INTO public.colegio (id_comuna, nombre)
SELECT trunc((random()*19) + 1),
       'Colegio ' || generate_series(1, 100) as name;


-- Inserta 100 apoderados con parentenzcos random establecidos y su sexo asociado,
--  ademas de una edad entre 20 y 60, con una comuna random.
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


-- Inserta 150 alumnos estableciendo relacion con un apoderado random,
--  y agregando la comuna y el colegio al que pertenece el apoderado
--  para que los datos tengan sentido, ademas de asignar un sexo y edad 
--  random, con un nombre del estilo Alumno X, con X entre  1-150.
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


-- Inserta cursos conocidos
INSERT INTO public.curso (nombre)
VALUES ('1ero Basico'), 
       ('2do Basico'), 
       ('3ero Basico'), 
       ('4to Bascio'), 
       ('5to Basico'), 
       ('6to Basico'), 
       ('7to Basico'), 
       ('8vo Basico'),
       ('1ero Medio'), 
       ('2do Medio'), 
       ('3ero Medio'), 
       ('4to Medio');



--
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
FROM rol_list,
     colegio_list cl,
     sexo_list,
     series;


--
INSERT INTO public.sueldo (id_empleado, cantidad)
SELECT e.id_empleado,
       cast(trunc(random()*600000 + 500000) as int)
FROM empleado e;


-- Inserta cursos de manera aleatoria por cada alumno.
INSERT INTO public.alu_curso (id_alumno, id_curso)
SELECT id_alumno,
                MOD(cast(trunc(random()*12) as int), 12) + 1
FROM alumno;

-- Inserta nuevos cursos a cada estudiante teniendo en cuenta que paso
--  de curso y teniendo como limite el curso mayor.
WITH n_alumnos as (SELECT COUNT(*) as count FROM alumno),
     alumnos_random as 
        (SELECT DISTINCT cast(trunc(random()*n_alumnos.count + 1) as int) as id_alumno
         FROM generate_series(1, 200), n_alumnos)
INSERT INTO public.alu_curso (id_alumno, id_curso)
SELECT ar.id_alumno, MAX(al.id_curso) + 1 as id_curso
FROM alu_curso al, alumnos_random ar
WHERE al.id_alumno = ar.id_alumno
GROUP BY ar.id_alumno
HAVING MAX(al.id_curso) + 1 <= 12;


-- Inserta a cada curso que tiene un alumno un anio random con asistencia 
--  random entre los meses 3-12 de ese anio, ademas se ingresa la asistencia 
--  maxima que podria tener el alumno, segun los dias de estudio (sin fin de semana)
--   
-- Fechas con anio (2019-2022), mes (3-12) y dias maximo de asistencia por mes (sin contar los fines de semana)
WITH fechas as
        (SELECT extract('YEAR'
                        FROM dates) AS anio,
                extract('MONTH'
                        FROM dates) AS mes,
                COUNT(extract('ISODOW'
                              FROM dates)) AS max_dias
         FROM generate_series(timestamp '2019-03-01', timestamp '2023-01-01' - interval '1 day' , interval '1 day') dates
         WHERE extract('ISODOW'
                       FROM dates) < 6
                 AND extract('MONTH'
                             FROM dates) >= 3
         GROUP BY anio,
                  mes
         ORDER BY anio ASC, mes ASC),
-- Se asigna un anio random a cada curso del alumno
     alu_curso_anio_random as
        (SELECT DISTINCT id_alu_curso,
                cast(trunc(random()*3 + 2019) as int) as anio_random
         FROM alu_curso)
INSERT INTO public.asistencia (cantidad, mes, anio, max_asistencia, id_alu_curso)
SELECT cast(trunc(random()*(f.max_dias - 1) + 1) as int) as cantidad,
       f.mes as mes,
       f.anio as anio,
       f.max_dias as max_asistencia,
       al.id_alu_curso
FROM fechas f,
     alu_curso_anio_random as al
WHERE f.anio = al.anio_random
ORDER BY f.anio ASC, 
         al.id_alu_curso ASC,
         f.mes ASC;


--
INSERT INTO public.profesor (id_empleado, correo)
SELECT e.id_empleado,
       'profesor' || e.id_empleado || '@mmail.com' as correo
FROM empleado e
WHERE e.rol = 'profesor';


-- 
INSERT INTO public.franja_horaria(cantidad_horas)
SELECT generate_series(2, 6) as n;


--
--un curso puede tener maximo 2 profesores y un profesor puede trabajar en 1 colegio.
INSERT INTO public.prof_curso(id_profesor, id_curso, id_franja_horaria, jefe) 
SELECT p.id_profesor,
       MOD(cast(trunc(random()*12) as int), 12) + 1,
       f.id_franja_horaria,
       CASE
           WHEN MOD(cast(trunc(random()*2) as int), 2) + 1 = 1 THEN true
           ELSE false
       END
FROM profesor p,
     franja_horaria f
WHERE
                (SELECT COUNT(*)
                 FROM prof_curso pc
                 WHERE pc.id_profesor = p.id_profesor) < 2
        AND
                (SELECT COUNT(*)
                 FROM prof_curso pc
                 WHERE pc.id_franja_horaria = f.id_franja_horaria) < 1;



--
INSERT INTO public.plantilla_curso(id_curso)
SELECT c.id_curso
FROM curso c;


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
     n_alumnos as
        (SELECT count(*) FROM alumno)
INSERT INTO public.alumno (id_apoderado, id_comuna, id_colegio, edad, sexo, nombre)
SELECT acl.id_apoderado,
       acl.id_comuna,
       acl.id_colegio,
       cast(trunc(random()*15 + 5) as int),
       sexo[MOD(cast(trunc(random()*2) as int), 2) + 1],
       'Alumno ' || acl.row_number + n_alumnos as name
FROM apoderado_colegio_list acl, 
     n_alumnos,
     sexo_list;


-- Insertar alumnos que asistieron todos los dias para probar la QUERY 5
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
         LIMIT 50),
     sexo_list as
        (SELECT '{mujer, hombre}'::VARCHAR(50)[] sexo)
INSERT INTO public.alumno (id_apoderado, id_comuna, id_colegio, edad, sexo, nombre)
SELECT acl.id_apoderado,
       acl.id_comuna,
       acl.id_colegio,
       cast(trunc(random()*15 + 5) as int),
       sexo[MOD(cast(trunc(random()*2) as int), 2) + 1],
       'Alumno Asiste ' || acl.row_number as name
FROM apoderado_colegio_list acl,
     sexo_list;
-- Asignarle cursos a esos alumnos
WITH n_alumnos as
        (SELECT count(*) as count
         FROM alumno)
INSERT INTO public.alu_curso (id_alumno, id_curso)
SELECT a.id_alumno,
       MOD(cast(trunc(random()*12) as int), 12) + 1
FROM alumno a,
     n_alumnos
WHERE a.id_alumno > n_alumnos.count - 50;
-- Asignarle la asistencia completa a esos alumnos
WITH n_alumnos as
        (SELECT count(*) as count
         FROM alumno),
     fechas as
        (SELECT extract('YEAR'
                        FROM dates) AS anio,
                extract('MONTH'
                        FROM dates) AS mes,
                COUNT(extract('ISODOW'
                              FROM dates)) AS max_dias
         FROM generate_series(timestamp '2019-03-01', timestamp '2023-01-01' - interval '1 day' , interval '1 day') dates
         WHERE extract('ISODOW'
                       FROM dates) < 6
                 AND extract('MONTH'
                             FROM dates) >= 3
         GROUP BY anio,
                  mes
         ORDER BY anio ASC, mes ASC),
     alu_curso_anio_random as
        (SELECT DISTINCT id_alu_curso,
                         cast(trunc(random()*3 + 2019) as int) as anio_random
         FROM alu_curso al,
              n_alumnos
         WHERE al.id_alumno > n_alumnos.count - 50)
INSERT INTO public.asistencia (cantidad, mes, anio, max_asistencia, id_alu_curso)
SELECT f.max_dias as cantidad,
       f.mes as mes,
       f.anio as anio,
       f.max_dias as max_asistencia,
       al.id_alu_curso
FROM fechas f,
     alu_curso_anio_random as al
WHERE f.anio = al.anio_random
ORDER BY f.anio ASC,
         al.id_alu_curso ASC,
         f.mes ASC;