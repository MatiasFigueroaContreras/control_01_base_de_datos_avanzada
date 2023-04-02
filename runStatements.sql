--Query 1
--Lista de profesores y sueldo, que indica si es jefe de curso o no y con cuantos alumnos trabaja si es que es jefe de curso.
SELECT e.nombre, s.cantidad, pc.jefe, 
       (CASE 
            WHEN pc.jefe = true 
            THEN (SELECT count(*)
                  FROM alumno a, alu_curso al
                  WHERE al.id_curso = pc.id_curso 
				  AND a.id_alumno = al.id_alumno
                  AND pc.id_profesor = p.id_profesor)
            ELSE 0 
       END) AS cantidad_alumnos
FROM empleado e, sueldo s, prof_curso pc, profesor p
WHERE e.id_empleado = p.id_empleado and s.id_empleado = e.id_empleado and pc.id_profesor = p.id_profesor;

--Query 2
--Lista de alumnos con mas inasistencias por mes por curso el año 2019.
SELECT cu.nombre as curso, asi.mes, MAX(asi.cantidad) AS inasistencias, al.nombre
FROM curso cu, alu_curso ac, asistencia asi, alumno al
WHERE asi.anio = 2019
	AND cu.id_curso = ac.id_curso
	AND ac.id_alu_curso = asi.id_alu_curso
	AND al.id_alumno = ac.id_alumno
	AND (asi.cantidad, asi.mes, asi.anio) 
      IN (SELECT MAX(a2.cantidad), a2.mes, a2.anio
		FROM asistencia a2, alu_curso ac2 
		WHERE a2.id_alu_curso = ac2.id_alu_curso 
                  AND ac2.id_curso = cu.id_curso
		GROUP BY a2.mes, a2.anio)
	GROUP BY cu.nombre, asi.mes, al.nombre
	ORDER BY cu.nombre, asi.mes;

--Query 3
--Lista de empleados con su rol, sueldo y comuna de residencia ordenado por comuna y sueldo.
SELECT e.nombre, e.rol, s.cantidad, c.nombre as comuna
FROM empleado e, sueldo s, comuna c, colegio co
WHERE e.id_empleado = s.id_empleado and co.id_comuna = c.id_comuna and e.id_colegio = co.id_colegio
ORDER BY c.nombre desc, s.cantidad;

--Query 4
--Lista de cursos que cuentan con la menor cantidad de alumnos y el año en que se dicta.
SELECT t2.anio, min(t2.cantidad_alumnos), min(t2.nombre_curso)
FROM(SELECT DISTINCT ON (t1.cantidad_alumnos)
		t1.anio, t1.cantidad_alumnos, t1.nombre_curso
		FROM (SELECT cu.nombre as nombre_curso, COUNT(*) as cantidad_alumnos, asi.anio
				FROM alu_curso ac, asistencia asi, curso cu
				WHERE asi.id_alu_curso = ac.id_alu_curso and cu.id_curso = ac.id_curso
				GROUP BY asi.anio, cu.nombre
				ORDER BY cantidad_alumnos asc) as t1
		GROUP by t1.anio, t1.cantidad_alumnos, t1.nombre_curso
		ORDER by t1.cantidad_alumnos) as t2
GROUP BY t2.anio
ORDER BY t2.anio;

--Query 5
--Identificar al alumno que no ha faltado nunca por curso
SELECT al.nombre as nombre,
       cu.nombre as curso
FROM curso cu,
     alumno al,
     alu_curso alcu,
     asistencia asis
WHERE alcu.id_alumno = al.id_alumno
      and alcu.id_curso = cu.id_curso
      and alcu.id_alu_curso = asis.id_alu_curso
GROUP BY al.nombre,
         cu.nombre
HAVING SUM(asis.max_asistencia) = SUM(asis.cantidad);

--Query 8
-- listado alumnos por curso donde el apoderado no es su padre o madre
SELECT a.nombre, cu.nombre as curso
FROM alumno a, apoderado ap, alu_curso ac, curso cu
WHERE a.id_alumno = ac.id_alumno and ap.id_apoderado = a.id_apoderado and ac.id_curso = cu.id_curso and ap.parentezco != 'padre' and ap.parentezco != 'madre';


--Query 9
-- colegio con mayor promedio de asistencia el año 2019, identificando la comuna
SELECT co.nombre as colegio, c.nombre as comuna, AVG(asi.cantidad) as promedio_asistencia
FROM colegio co, comuna c, asistencia asi, alu_curso ac
WHERE co.id_comuna = c.id_comuna and ac.id_colegio = co.id_colegio  and asi.anio = 2019 and asi.id_alu_curso = ac.id_alu_curso
GROUP BY co.nombre, c.nombre
ORDER BY promedio_asistencia desc;


--Query 10
-- Lista de colegios con mayor numero de alumnos por anio
WITH alu_cursos_por_anio as
      ( SELECT DISTINCT asis.id_alu_curso,
                        asis.anio,
                        ac.id_colegio
       FROM asistencia asis,
            alu_curso ac
       WHERE ac.id_alu_curso = asis.id_alu_curso )
SELECT c.nombre,
       ac.anio,
       COUNT(ac.id_alu_curso) as num_alumnos
FROM alu_cursos_por_anio ac,
     colegio c
WHERE ac.id_colegio = c.id_colegio
GROUP BY c.nombre,
         ac.anio
ORDER BY ac.anio,
         num_alumnos DESC;