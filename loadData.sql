INSERT INTO public.comuna (nombre)
VALUES
    ('Santiago'),
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
SELECT trunc((random()*19) + 1), 'Colegio ' || generate_series(1, 100) as name;

WITH parentezco_list as (
	SELECT '{padre, madre, abuelo, abuela, tio, hermano}'::VARCHAR(50)[] parentezco
), sexo_list as (
	SELECT '{hombre, mujer}'::VARCHAR(50)[] sexo
)
INSERT INTO public.apoderado (id_comuna, nombre, parentezco, sexo, edad)
SELECT trunc((random()*19) + 1), 'Apoderado ' || generate_series(1, 100) as name, parentezco[MOD(cast(trunc(random()*6) as int), 6) + 1], sexo[MOD(cast(trunc(random()*2) as int), 2) + 1], cast(trunc(random()*40 + 20) as int)
FROM parentezco_list, sexo_list;