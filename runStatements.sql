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
-- 22 ya que se descuentan los fines de semana.
SELECT a.nombre, 22-asi.cantidad as inasistencias, asi.mes, asi.anio
FROM alumno a, asistencia asi, alu_curso ac
WHERE a.id_alumno = ac.id_alumno and ac.id_asistencia = asi.id_asistencia and asi.anio = 2019;

--Query 3
--Lista de empleados con su rol, sueldo y comuna de residencia ordenado por comuna y sueldo.
SELECT e.nombre, e.rol, s.cantidad, c.nombre as comuna
FROM empleado e, sueldo s, comuna c, colegio co
WHERE e.id_empleado = s.id_empleado and co.id_comuna = c.id_comuna and e.id_colegio = co.id_colegio
ORDER BY c.nombre desc, s.cantidad;

--Query 4
--Lista de cursos que cuentan con la menor cantidad de alumnos y el año en que se dicta.
SELECT cu.nombre as nombre_curso, COUNT(*) as cantidad_alumnos, asi.anio
FROM alu_curso ac, asistencia asi, curso cu
WHERE asi.id_asistencia = ac.id_asistencia and cu.id_curso = ac.id_curso
GROUP BY cu.nombre, asi.anio
ORDER BY cantidad_alumnos asc;