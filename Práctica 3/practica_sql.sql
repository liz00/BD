--Realizado por Estíbaliz Busto y Lucía Latorre

/abolish
create table programadores(dni string primary key, nombre string, dirección string, teléfono string);
insert into programadores values('1','Jacinto','Jazmín 4','91-8888888'); 
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');
create table analistas (dni string primary key, nombre string, dirección string, teléfono string);
insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','Júpiter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plutón 3', NULL);
create table distribución (códigopr string, dniemp string primary key, horas int, primary key (códigopr, dniemp));
insert into distribución(códigopr, dniemp, horas) values('P1','1',10);
insert into distribución(códigopr, dniemp, horas) values('P1','2',40);
insert into distribución(códigopr, dniemp, horas) values('P1','4',5);
insert into distribución(códigopr, dniemp, horas) values('P2','4',10);
insert into distribución(códigopr, dniemp, horas) values('P3','1',10);
insert into distribución(códigopr, dniemp, horas) values('P3','3',40);
insert into distribución(códigopr, dniemp, horas) values('P3','4',5);
insert into distribución(códigopr, dniemp, horas) values('P3','5',30);
insert into distribución(códigopr, dniemp, horas) values('P4','4',20);
insert into distribución(códigopr, dniemp, horas) values('P4','5',10);
create table proyectos (código string primary key, descripción string, dnidir string);
insert into proyectos(código, descripción, dnidir) values('P1','Nómina','4');
insert into proyectos(código, descripción, dnidir) values('P2','Contabilidad','4');
insert into proyectos(código, descripción, dnidir) values('P3','Producción','5');
insert into proyectos(código, descripción, dnidir) values('P4','Clientes','5');
insert into proyectos(código, descripción, dnidir) values('P5','Ventas','6');

------------------------Practica3---SQL-----------------------------------------

--1. DNI de todos los empleados. 
CREATE VIEW vista1 AS SELECT dni FROM programadores UNION SELECT dni FROM analistas;

--2. DNI de los empleados que son a la vez programadores y analistas. 
CREATE VIEW vista2 AS SELECT dni FROM programadores INTERSECT SELECT dni FROM analistas;

--3. DNI de los empleados sin trabajo (ni están asignados a proyectos ni son directores de ellos)
CREATE VIEW vista3 AS (SELECT dni FROM programadores UNION SELECT dni FROM analistas) EXCEPT (SELECT dniemp FROM distribución UNION SELECT dnidir FROM proyectos);

--4. Código de los proyectos sin analistas asignados.  
CREATE VIEW proy_con_analistas AS (SELECT códigopr FROM distribución, analistas WHERE dniemp=dni);
CREATE VIEW vista4 AS SELECT código FROM proyectos EXCEPT SELECT * FROM proy_con_analistas;

--5. DNI de los analistas que dirijan proyectos pero que no sean programadores.
CREATE VIEW analistas_no_programadores AS (SELECT dni FROM analistas EXCEPT SELECT dni FROM programadores);
CREATE VIEW vista5(dni) AS SELECT dnidir FROM proyectos, analistas_no_programadores WHERE dnidir=dni; 

--6. Descripción de los proyectos con los nombres de los programadores y horas asignados a ellos.
CREATE VIEW horas_progra AS SELECT códigopr, dniemp, horas, nombre FROM distribución, programadores WHERE dniemp=dni;
CREATE VIEW vista6 AS SELECT descripción, nombre, horas FROM horas_progra, proyectos WHERE códigopr=código;

--7. Listado de teléfonos compartidos por empleados (sólo hay que indicar el número de teléfono).
CREATE VIEW an_y_pr AS SELECT * FROM programadores INTERSECT SELECT * FROM analistas;
CREATE VIEW tel_anypr AS SELECT teléfono FROM an_y_pr;
CREATE VIEW producto AS SELECT programadores.teléfono FROM programadores, analistas WHERE programadores.teléfono= analistas.teléfono;
CREATE VIEW vista7(teléfono) AS SELECT * FROM producto EXCEPT SELECT * FROM tel_anypr;

--8. Usando la reunión natural, determinar el DNI de los empleados que son a la vez programadores y analistas.
CREATE VIEW vista8 AS SELECT dni FROM programadores NATURAL JOIN analistas;
 
--9. Determinar el número de horas totales que trabaja cada empleado.
CREATE VIEW vista9(dni, horas) AS SELECT dniemp, SUM(horas) FROM distribución GROUP BY dniemp;

--10. Proporcionar un listado en el que aparezca el DNI de cada uno de los empleados (no debe faltar ninguno), su nombre y el código de proyecto al que está asignado. Esquema: vista10(dni,nombre,proyecto). 
CREATE VIEW empleados AS SELECT dni AS dniemp, nombre FROM programadores UNION SELECT dni AS dniemp, nombre FROM analistas;
CREATE VIEW vista10(dni, nombre, proyecto) AS SELECT dniemp, nombre, códigopr FROM empleados NATURAL LEFT OUTER JOIN distribución;

--11. Determinar el DNI y nombre de los empleados que no tienen teléfono usando el operador infijo is y la constante null (Expresión is null).
CREATE VIEW emp AS SELECT * FROM programadores UNION SELECT * FROM analistas;
CREATE VIEW vista11 AS SELECT dni, nombre FROM emp WHERE teléfono IS NULL;

--12. Determinar los empleados cuyo total de horas dividido entre el número de proyectos en que trabaja es menor que la media del total de horas por proyecto dividido entre su número de empleados.
CREATE VIEW horasxemp(dni, horas_emp) AS SELECT dniemp, AVG(horas) AS AVG FROM distribución GROUP BY dniemp 
CREATE VIEW horasxproy(h) AS SELECT AVG(horas) AS AVG FROM distribución GROUP BY códigopr
CREATE VIEW media_horas(horas) AS SELECT AVG(h) AS AVG FROM horasxproy
CREATE VIEW vista12 AS SELECT dni FROM horasxemp, media_horas WHERE horas_emp < horas

--13. Usando la división, determinar el DNI de los empleados que trabajan en al menos los mismos proyectos que Evaristo.
CREATE VIEW emp AS SELECT * FROM programadores UNION SELECT * FROM analistas;
CREATE VIEW dni_Evaristo AS SELECT dni FROM emp WHERE nombre = 'Evaristo';
CREATE VIEW proy_Ev AS SELECT códigopr FROM distribución, dni_Evaristo WHERE dniemp = dni;
CREATE VIEW dist_sinHoras AS SELECT códigopr, dniemp FROM distribución;
CREATE VIEW vista13(dni) AS SELECT dniemp FROM dist_sinHoras DIVISION proy_Ev;

--14. Resolver el apartado anterior sin usar la operación de división.
CREATE VIEW emp AS SELECT * FROM programadores UNION SELECT * FROM analistas;
CREATE VIEW dni_Evaristo AS SELECT dni FROM emp WHERE nombre = 'Evaristo';
CREATE VIEW proy_Ev AS SELECT códigopr FROM distribución, dni_Evaristo WHERE dniemp = dni;
CREATE VIEW dist_sinProy AS SELECT dniemp FROM distribución;
CREATE VIEW aux AS SELECT * FROM dist_sinProy, proy_Ev EXCEPT SELECT dniemp, códigopr FROM distribución;
CREATE VIEW vista14(dni) AS SELECT dniemp FROM distribución EXCEPT SELECT dniemp FROM aux;

--15. Para cada proyecto y empleado, listar el número de horas ampliado en un 20% de cada uno de los empleados que no trabajen con Evaristo (i.e., no estén asignados a ningún proyecto en el que esté asignado Evaristo).
CREATE VIEW emp AS SELECT * FROM programadores UNION SELECT * FROM analistas;
CREATE VIEW dni_Evaristo AS SELECT dni FROM emp WHERE nombre = 'Evaristo';
CREATE VIEW proy_Ev AS SELECT códigopr FROM distribución, dni_Evaristo WHERE dniemp = dni;
CREATE VIEW trab_conEv AS SELECT dniemp FROM distribución NATURAL JOIN proy_Ev;
CREATE VIEW noTrab_conEv AS SELECT dniemp FROM distribución EXCEPT select * FROM trab_conEv;
CREATE VIEW vista15(códigoPr, dni, horas) AS SELECT códigopr, dniemp, horas*1.2 FROM distribución NATURAL JOIN noTrab_conEv;

--16. Algunos proyectos están dirigidos por empleados asignados a otros proyectos con otros directores, por lo que existe una dependencia entre empleados. Determinar los nombres de los empleados que dependen de Evaristo (los asignados a los proyectos que dirige y los que dependen a su vez de estos). 
CREATE VIEW emp AS SELECT * FROM programadores UNION SELECT * FROM analistas;
CREATE VIEW dni_Evaristo AS SELECT dni FROM emp WHERE nombre = 'Evaristo';
CREATE VIEW dirige AS SELECT dniemp, dnidir FROM distribución, proyectos WHERE códigopr = código;
CREATE VIEW solo_dirigeEv AS SELECT * FROM dirige, dni_Evaristo WHERE dnidir = dni;
CREATE VIEW depEv(dni) AS SELECT dnidir FROM solo_dirigeEv UNION (SELECT dniemp FROM solo_dirigeEv UNION SELECT dniemp FROM depEv, dirige WHERE dni = dnidir);
CREATE VIEW vista16(nombre) AS SELECT nombre FROM (SELECT * FROM depEv EXCEPT SELECT * FROM dni_Evaristo), emp WHERE depEv.dni = emp.dni;


select * from vista1;
select * from vista2;
select * from vista3;
select * from vista4;
select * from vista5;
select * from vista6;
select * from vista7;
select * from vista8;
select * from vista9;
select * from vista10;
select * from vista11;
select * from vista12;
select * from vista13;
select * from vista14;
select * from vista15;
select * from vista16;