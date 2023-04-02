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