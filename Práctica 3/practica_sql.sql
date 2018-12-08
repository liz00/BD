--Realizado por Est�baliz Busto y Luc�a Latorre

/abolish
create table programadores(dni string primary key, nombre string, direcci�n string, tel�fono string);
insert into programadores values('1','Jacinto','Jazm�n 4','91-8888888'); 
insert into programadores values('2','Herminia','Rosa 4','91-7777777');
insert into programadores values('3','Calixto','Clavel 3','91-1231231');
insert into programadores values('4','Teodora','Petunia 3','91-6666666');
create table analistas (dni string primary key, nombre string, direcci�n string, tel�fono string);
insert into analistas values('4','Teodora','Petunia 3','91-6666666');
insert into analistas values('5','Evaristo','Luna 1','91-1111111');
insert into analistas values('6','Luciana','J�piter 2','91-8888888');
insert into analistas values('7','Nicodemo','Plut�n 3', NULL);
create table distribuci�n (c�digopr string, dniemp string primary key, horas int, primary key (c�digopr, dniemp));
insert into distribuci�n(c�digopr, dniemp, horas) values('P1','1',10);
insert into distribuci�n(c�digopr, dniemp, horas) values('P1','2',40);
insert into distribuci�n(c�digopr, dniemp, horas) values('P1','4',5);
insert into distribuci�n(c�digopr, dniemp, horas) values('P2','4',10);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','1',10);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','3',40);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','4',5);
insert into distribuci�n(c�digopr, dniemp, horas) values('P3','5',30);
insert into distribuci�n(c�digopr, dniemp, horas) values('P4','4',20);
insert into distribuci�n(c�digopr, dniemp, horas) values('P4','5',10);
create table proyectos (c�digo string primary key, descripci�n string, dnidir string);
insert into proyectos(c�digo, descripci�n, dnidir) values('P1','N�mina','4');
insert into proyectos(c�digo, descripci�n, dnidir) values('P2','Contabilidad','4');
insert into proyectos(c�digo, descripci�n, dnidir) values('P3','Producci�n','5');
insert into proyectos(c�digo, descripci�n, dnidir) values('P4','Clientes','5');
insert into proyectos(c�digo, descripci�n, dnidir) values('P5','Ventas','6');

------------------------Practica3---SQL-----------------------------------------

--1. DNI de todos los empleados. 
CREATE VIEW vista1 AS SELECT dni FROM programadores UNION SELECT dni FROM analistas;

--2. DNI de los empleados que son a la vez programadores y analistas. 
CREATE VIEW vista2 AS SELECT dni FROM programadores INTERSECT SELECT dni FROM analistas;

--3. DNI de los empleados sin trabajo (ni est�n asignados a proyectos ni son directores de ellos)
CREATE VIEW vista3 AS (SELECT dni FROM programadores UNION SELECT dni FROM analistas) EXCEPT (SELECT dniemp FROM distribuci�n UNION SELECT dnidir FROM proyectos);

--4. C�digo de los proyectos sin analistas asignados.  
CREATE VIEW proy_con_analistas AS (SELECT c�digopr FROM distribuci�n, analistas WHERE dniemp=dni);
CREATE VIEW vista4 AS SELECT c�digo FROM proyectos EXCEPT SELECT * FROM proy_con_analistas;

--5. DNI de los analistas que dirijan proyectos pero que no sean programadores.
CREATE VIEW analistas_no_programadores AS (SELECT dni FROM analistas EXCEPT SELECT dni FROM programadores);
CREATE VIEW vista5(dni) AS SELECT dnidir FROM proyectos, analistas_no_programadores WHERE dnidir=dni; 

--6. Descripci�n de los proyectos con los nombres de los programadores y horas asignados a ellos.
CREATE VIEW horas_progra AS SELECT c�digopr, dniemp, horas, nombre FROM distribuci�n, programadores WHERE dniemp=dni;
CREATE VIEW vista6 AS SELECT descripci�n, nombre, horas FROM horas_progra, proyectos WHERE c�digopr=c�digo;

--7. Listado de tel�fonos compartidos por empleados (s�lo hay que indicar el n�mero de tel�fono).
CREATE VIEW an_y_pr AS SELECT * FROM programadores INTERSECT SELECT * FROM analistas;
CREATE VIEW tel_anypr AS SELECT tel�fono FROM an_y_pr;
CREATE VIEW producto AS SELECT programadores.tel�fono FROM programadores, analistas WHERE programadores.tel�fono= analistas.tel�fono;
CREATE VIEW vista7(tel�fono) AS SELECT * FROM producto EXCEPT SELECT * FROM tel_anypr;

--8. Usando la reuni�n natural, determinar el DNI de los empleados que son a la vez programadores y analistas.
CREATE VIEW vista8 AS SELECT dni FROM programadores NATURAL JOIN analistas;
 
--9. Determinar el n�mero de horas totales que trabaja cada empleado.
CREATE VIEW vista9(dni, horas) AS SELECT dniemp, SUM(horas) FROM distribuci�n GROUP BY dniemp;

--10. Proporcionar un listado en el que aparezca el DNI de cada uno de los empleados (no debe faltar ninguno), su nombre y el c�digo de proyecto al que est� asignado. Esquema: vista10(dni,nombre,proyecto). 
CREATE VIEW empleados AS SELECT dni AS dniemp, nombre FROM programadores UNION SELECT dni AS dniemp, nombre FROM analistas;
CREATE VIEW vista10(dni, nombre, proyecto) AS SELECT dniemp, nombre, c�digopr FROM empleados NATURAL LEFT OUTER JOIN distribuci�n;

--11. Determinar el DNI y nombre de los empleados que no tienen tel�fono usando el operador infijo is y la constante null (Expresi�n is null).
CREATE VIEW emp AS SELECT * FROM programadores UNION SELECT * FROM analistas;
CREATE VIEW vista11 AS SELECT dni, nombre FROM emp WHERE tel�fono IS NULL;

--12. Determinar los empleados cuyo total de horas dividido entre el n�mero de proyectos en que trabaja es menor que la media del total de horas por proyecto dividido entre su n�mero de empleados.
CREATE VIEW horasxemp(dni, horas_emp) AS SELECT dniemp, AVG(horas) AS AVG FROM distribuci�n GROUP BY dniemp 
CREATE VIEW horasxproy(h) AS SELECT AVG(horas) AS AVG FROM distribuci�n GROUP BY c�digopr
CREATE VIEW media_horas(horas) AS SELECT AVG(h) AS AVG FROM horasxproy
CREATE VIEW vista12 AS SELECT dni FROM horasxemp, media_horas WHERE horas_emp < horas

--13. Usando la divisi�n, determinar el DNI de los empleados que trabajan en al menos los mismos proyectos que Evaristo.
CREATE VIEW emp AS SELECT * FROM programadores UNION SELECT * FROM analistas;
CREATE VIEW dni_Evaristo AS SELECT dni FROM emp WHERE nombre = 'Evaristo';
CREATE VIEW proy_Ev AS SELECT c�digopr FROM distribuci�n, dni_Evaristo WHERE dniemp = dni;
CREATE VIEW dist_sinHoras AS SELECT c�digopr, dniemp FROM distribuci�n;
CREATE VIEW vista13(dni) AS SELECT dniemp FROM dist_sinHoras DIVISION proy_Ev;

--14. Resolver el apartado anterior sin usar la operaci�n de divisi�n.
CREATE VIEW emp AS SELECT * FROM programadores UNION SELECT * FROM analistas;
CREATE VIEW dni_Evaristo AS SELECT dni FROM emp WHERE nombre = 'Evaristo';
CREATE VIEW proy_Ev AS SELECT c�digopr FROM distribuci�n, dni_Evaristo WHERE dniemp = dni;
CREATE VIEW dist_sinProy AS SELECT dniemp FROM distribuci�n;
CREATE VIEW aux AS SELECT * FROM dist_sinProy, proy_Ev EXCEPT SELECT dniemp, c�digopr FROM distribuci�n;
CREATE VIEW vista14(dni) AS SELECT dniemp FROM distribuci�n EXCEPT SELECT dniemp FROM aux;

--15. Para cada proyecto y empleado, listar el n�mero de horas ampliado en un 20% de cada uno de los empleados que no trabajen con Evaristo (i.e., no est�n asignados a ning�n proyecto en el que est� asignado Evaristo).
CREATE VIEW emp AS SELECT * FROM programadores UNION SELECT * FROM analistas;
CREATE VIEW dni_Evaristo AS SELECT dni FROM emp WHERE nombre = 'Evaristo';
CREATE VIEW proy_Ev AS SELECT c�digopr FROM distribuci�n, dni_Evaristo WHERE dniemp = dni;
CREATE VIEW trab_conEv AS SELECT dniemp FROM distribuci�n NATURAL JOIN proy_Ev;
CREATE VIEW noTrab_conEv AS SELECT dniemp FROM distribuci�n EXCEPT select * FROM trab_conEv;
CREATE VIEW vista15(c�digoPr, dni, horas) AS SELECT c�digopr, dniemp, horas*1.2 FROM distribuci�n NATURAL JOIN noTrab_conEv;

--16. Algunos proyectos est�n dirigidos por empleados asignados a otros proyectos con otros directores, por lo que existe una dependencia entre empleados. Determinar los nombres de los empleados que dependen de Evaristo (los asignados a los proyectos que dirige y los que dependen a su vez de estos). 
CREATE VIEW emp AS SELECT * FROM programadores UNION SELECT * FROM analistas;
CREATE VIEW dni_Evaristo AS SELECT dni FROM emp WHERE nombre = 'Evaristo';
CREATE VIEW dirige AS SELECT dniemp, dnidir FROM distribuci�n, proyectos WHERE c�digopr = c�digo;
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