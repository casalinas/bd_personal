tipos de datos sql

char: cadena de caracteres de longitud fija (rellena con 
espacios en blanco si se ponen menos caracteres),
por defecto es 1 byte

variablechar2: cadena de caracteres de longitud variableiable, 
tamaño maximo de n bytes, obligatorio asignar un tamaño

number: numerico, no es obligatorio especificar tamaño

date: tipo fecha, desde -4712 hasta el 9999

long: para albergar caracteres de longitud variableiable,
hasta 2gb, se recomienda no usar

clob: alberga caracteres multi-byte o single-byte
se usa para textos grandes. (aun se usa)

nclob: igual que clob pero con caracteres unicode,
almacena cadenas de caracteres de tipo nacional de
distintos lenguajes

raw: datos binarios, mismos limites que variablechar2

blob: objeto binario hasta 4gb

bfile: contiene punteros a ficheros externos de bd,
se guardan afuera de la bd

rowid: representa el id unico de una fila

timestamp: fecha que almacena fracciones de segundo,
hay variableiaciones como with timezone o with 
localtimezone

interval year to month: almacena tiempo como intervalo
de años y meses

interval day to second: almacena intervalo de dias
horas minutos y segundos (mas especifico que el 
anterior)

comando select

este permite realizar consultas (query) y extraer
datos de la base de datos

se pueden hacer tres operaciones basicas con este
comando, segun el modelo relacional

proyección: recuperar columnas de una tabla

seleccion: recuperar filas de una tabla

joins: recuperar informacion de manera conjunta
de variableias tablas.

proyeccion, seleccionar algunas columnas

seleccion, seleccionar algunas filas.

SELECT DATOS FROM TABLA

-----------------------------------------------------

primeros pasos select.

es necesario poner ; al final de las sentencias para poder
ejecutarlas ordenadamente cuando existan variableias en una hoja
de trabajo.

Bases de datos oracle, probando las funcionalidades.

LENGTH: muestra la cantidad de caracteres de los valores en una tabla

SUBSTR: devuelve caracteres de una cadena, ej:
select substr(first_name,3,3); (del nombre carlos devolverá ‘los’, el primer 3 significa la posición desde donde comienza, y el segundo número significa cuantos caracteres recogerá desde ahí) 

INSTR: Nos marca la posición numérica en donde se encuentra un carácter que asignamos para buscar, además se puede especificar desde qué posición de la cadena queremos buscar, ejemplo: para el nombre Catalina de la tabla pnombre_emp
INSTR(lower(pnombre_emp),'a',3) from empleado; = 4 (usamos lower para que todos los caracteres sean minúscula, buscamos el carácter ‘a’  desde la tercera posición de la cadena, entonces marcara el primero que encuentre desde ahí, por eso el resultado es 4)


distinc: este afecta a toda la fila (todas las columnas) y se pone despues del "select", genera resultados sin repetir valores.

Ejemplo DISTINCT: select distinct job_id, department_id from employees;
(esto evitaria repetir los id en los resultados)

WHERE: pone una condicion en la base de datos para poder filtrar las búsquedas, se usa despues de nombrar la tabla en donde se hace la busqueda.

EJEMPLO WHERE: select * from employees where department_id = 50; 
(esto mostraria todas las tablas de empleados que tengan el department_id 50)

EJEMPLO WHERE CON FECHAS: SELECT * FROM EMPLOYEES WHERE hire_date='21-06-2007';
(en este caso se pueden poner fechas entre '' y oracle las reconocerá)
where puede usar operadores aritmeticos (>, =, <, <>)

BETWEEN: Nos sirve para ver resultados entre los parametros que asignamos, se pone después del where.

EJEMPLO BETWEEN: SELECT * FROM EMPLOYEES 
WHERE SALARY BETWEEN 5000 AND 6000;
(muestra todos los empleados con salarios entre 5000 y 6000)

IN: Esta funcion permite poner variableias cualidades que queremos que se cumplan, por ejemplo empleados del departamento 50 y 60, el in se pone despues del where y la condicion va entre ()

EJEMPLO IN: SELECT * FROM EMPLOYEES WHERE department_id IN (50,60);
(muestra empleados del departamento 50 y 60)
SELECT * FROM EMPLOYEES WHERE job_id IN ('SH_CLERK','ST_CLERK','ST_MAN');
(muestra empleados que trabajan en el job que cumpla
los nombres mencionados)

LIKE: Funciona solo con los caracteres, sirve para buscar nombres que coincidan en la bd, podemos buscar por palabras que comienzen y terminen de una manera, que despues de n caracteres contenga la letra que buscamos etc

EJEMPLOS LIKE: 
SELECT * FROM EMPLOYEES WHERE
first_name LIKE 'J%';
(Busca todos los nombres que comienzen con J)
SELECT * FROM EMPLOYEES WHERE
first_name LIKE 'S%n';
(Busca los nombres que Comienzen con S y terminen en n, sin importar los caracteres de en medio)

SELECT * FROM COUNTRIES WHERE
country_name LIKE '_r%';
(selecciona los paises con una r en el segundo caracter de su nombre)

NULOS: Es un espacio vacio, sin ningún valor asignado

EJEMPLO NULL: Select * from employees
WHERE commission_pct IS NULL;
(busca valores nulos)
Select * from employees
WHERE commission_pct IS NOT NULL;
(busca valores que no son nulos)

(Mostrara empleados sin comission_pct. no se pueden usar operadores aritmeticos porque no se pueden comparar valores nulos o inexistentes)

AND OR: SE PONEN DESPUES DEL WHERE Y SON CONDICIONES QUE PONEMOS PARA QUE SE CUMPLAN Y FILTREN LA BUSQUEDA 

COMO USAR AND OR:
C1 AND C2 TRUE TRUE --> TRUE
C1 AND C2 TRUE FALSE --> FALSE
C1 AND C1 FALSE FALSE --> FALSE

C1 OR C2 TRUE TRUE --> TRUE
C1 OR C2 TRUE FALSE --> TRUE
C1 OR C2 FALSE FALSE --> FALSE  

EJEMPLO DE AND OR: 
SELECT first_name, hire_date, job_id, salary FROM EMPLOYEES
WHERE job_id = 'IT_PROG' AND salary < 6000;
(ELEGIMOS LOS EMPLEADOS QUE TENGA EL TRABAJO IT_PROG Y UN SALARIO MENOR A 6000)

ORDER BY: Sirve para ordenar como queremos ver los resultados, por defecto los resultados van ascendiendo, si se quiere descendente se debe especificar

EJEMPLO ORDER BY: SELECT first_name, last_name, salary FROM EMPLOYEES
WHERE first_name ='David'
ORDER BY first_name, salary;
(se ordena primero por nombre, y cuando se repite el nombre se ordena por el salario)

CLÁUSULA FETCH: puede limitar la cantidad de filas, se pone al final de las clausulas select

EJEMPLO FETCH: SELECT FIRST_NAME, SALARY FROM EMPLOYEES FETCH FIRST 10 ROWS ONLY
(muestra las primeras 10 filas)

select first_name,salary from employees
order by salary desc fetch first 7 rows with ties;

select first_name,salary from employees
order by salary desc offset 5 rows fetch first 7 rows with ties;

-- calcula primer 20% de filas
select * from employees fetch first 20 percent rows only;
—---------------------------------------------------------------------

ejemplos trabajados

select distinct city, state_province from locations;

select distinct job_id, department_id from employees;

select * from employees 
where department_id = 50;

/*  = > | < > | =|  <=| <>
*/
select first_name,salary from employees
WHERE salary > 5000;

SELECT first_name FROM EMPLOYEES
WHERE department_id <> 50;

SELECT first_name  FROM EMPLOYEES WHERE first_name<>'John';

SELECT * FROM EMPLOYEES; --1 DE ENERO 4712 AC

SELECT * FROM EMPLOYEES WHERE hire_date>'21-06-2007';

-- PRACTICAS CON WHERE

SELECT * FROM EMPLOYEES
WHERE department_id = 100;

SELECT city, street_address, country_id FROM LOCATIONS
WHERE country_id ='US';

SELECT * FROM countries
WHERE region_id = 3;

SELECT * FROM EMPLOYEES
WHERE manager_id <> 114;

SELECT * FROM EMPLOYEES
WHERE hire_date >= '1-1-2006';

SELECT * FROM EMPLOYEES
WHERE job_id = 'ST_CLERK';

SELECT * FROM EMPLOYEES 
WHERE last_name = 'Smith';

-- BETWEEN V1 AND V2

SELECT * FROM EMPLOYEES 
WHERE SALARY BETWEEN 5000 AND 6000;

SELECT * FROM EMPLOYEES 
WHERE hire_date BETWEEN '01-01-2007' AND '01-01-2009';

SELECT * FROM EMPLOYEES 
WHERE first_name BETWEEN 'Douglas' AND 'Steven';

-- IN (V1,V2,V3) 'SI EL VALOR ESTA DENTRO DE LA LISTA SE MUESTRA'

SELECT * FROM EMPLOYEES WHERE department_id IN (50,60);

SELECT * FROM EMPLOYEES WHERE job_id IN ('SH_CLERK','ST_CLERK','ST_MAN');

-- PRACTICAS BETWEEN IN

SELECT * FROM EMPLOYEES
WHERE department_id IN (40,60);

SELECT * FROM EMPLOYEES
WHERE hire_date BETWEEN '01-01-2002' AND '31-12-2004';

SELECT * FROM EMPLOYEES
WHERE last_name BETWEEN 'D' AND 'G';

SELECT * FROM EMPLOYEES
WHERE department_id IN (30,60,90);

SELECT * FROM EMPLOYEES
WHERE job_id IN ('IT_PROG','PU_CLERK');

SELECT * FROM LOCATIONS 
WHERE country_id IN ('UK','JP');

-- LIKE funciona solo con 'PATRON O CADENA DE CARACTERES'
-- %
-- _ 

SELECT * FROM EMPLOYEES
WHERE first_name LIKE 'J%';

SELECT * FROM EMPLOYEES WHERE
first_name LIKE '_e%';

SELECT * FROM EMPLOYEES WHERE
first_name LIKE '%te%';

-- PRACTICAS CON LIKE
/*
 Indicar los datos de los empleados cuyo FIRST_NAME empieza por ‘J’
 Averiguar los empleados que comienzan por ‘S’ y terminan en ‘n’
 Indicar los países que tienen una “r” en la segunda letra (Tabla COUNTRIES)
*/

SELECT * FROM EMPLOYEES WHERE
first_name LIKE 'J%';

SELECT * FROM EMPLOYEES WHERE
first_name LIKE 'S%n';

SELECT * FROM COUNTRIES WHERE
country_name LIKE '_r%';


-- Nulos
Select * from employees
WHERE commission_pct IS NULL;

Select * from employees
WHERE commission_pct IS NOT NULL;

-- Practicas NULL

/*
1 Listar las ciudades de la tabla LOCATIONS que no tienen STATE_PROVINCE
2 Averiguar el nombre, salario y comisión de aquellos empleados que tienen
  comisión. 
3 También debemos visualizar una columna calculada denominada
“Sueldo Total”, que sea el sueldo más la comisión
*/

Select * from LOCATIONS
WHERE state_province IS NULL ;

Select first_name, salary, commission_pct, (salary * commission_pct) + salary as "salario total" from employees
WHERE commission_pct IS NOT NULL;

/* CONDICIONES COMPLEJAS CON OPERADORES
AND C1 AND C2 --> TRUE SI 2 SE CUMPLEN
OR C1 OR C2 --> TRUE SI 1 SE CUMPLE
NOT C1 --> TRUE (NEGACION DEL RESULTADO)
*/

SELECT * FROM EMPLOYEES 
WHERE salary > 5000 AND department_id = 50;

SELECT * FROM EMPLOYEES 
WHERE salary > 5000 OR department_id = 50;

SELECT * FROM EMPLOYEES 
WHERE salary > 5000 AND department_id = 50;

SELECT * FROM EMPLOYEES 
WHERE department_id NOT IN (50,60);

/*
C1 AND C2 TRUE TRUE --> TRUE
C1 AND C2 TRUE FALSE --> FALSE
C1 AND C1 FALSE FALSE --> FALSE

C1 OR C2 TRUE TRUE --> TRUE
C1 OR C2 TRUE FALSE --> TRUE
C1 OR C2 FALSE FALSE --> FALSE
*/

/*
1 Obtener el nombre y la fecha de la entrada y el tipo de trabajo de los
 empleados que sean IT_PROG y que ganen menos de 6000 dólares
2 Seleccionar los empleados que trabajen en el departamento 50 o 80,
cuyo nombre comience por S y que ganen más de 3000 dólares.
3 ¿Qué empleados de job_id IT_PROG tienen un prefijo 5 en el teléfono
y entraron en la empresa en el año 2007?
*/
-- PRACTICAS AND OR

SELECT first_name, hire_date, job_id, salary FROM EMPLOYEES
WHERE job_id = 'IT_PROG' AND salary < 6000;

SELECT * FROM EMPLOYEES
WHERE first_name LIKE 'S%' AND (department_id =50 OR department_id = 80)
AND salary > 3000;

SELECT * FROM EMPLOYEES
WHERE job_id = 'IT_PROG' AND phone_number LIKE '5%' AND hire_date BETWEEN
'01-01-2007' AND '31-12-2007';

-- ORDER BY

SELECT * FROM EMPLOYEES 
ORDER BY salary DESC;

SELECT * FROM EMPLOYEES 
ORDER BY salary;

SELECT * FROM EMPLOYEES
ORDER BY first_name, last_name;

SELECT first_name, last_name, salary FROM EMPLOYEES
WHERE first_name ='David'
ORDER BY first_name, salary;

-- SE PUEDE MENCIONAR LA COLUMNA A ORDENAR POR SU NOMBRE O POR SU POSICIÓN
-- O POR SU ALIAS
SELECT first_name, salary*12 FROM EMPLOYEES
ORDER BY SALARY*12;

SELECT first_name, salary*12 FROM EMPLOYEES
ORDER BY 2;

SELECT first_name, salary*12 AS SALARIO FROM EMPLOYEES
ORDER BY SALARIO DESC;

--FETCH

SELECT first_name, salary FROM EMPLOYEES FETCH FIRST 10 ROWS ONLY;

-- como alterar tablas
alter table empleados add smin number default 0 not null; -- añadimos un campo
alter table empleados drop column smin; -- eliminamos campo (no se puede eliminar si es el unico de tabla)
select * from empleados;
rollback; -- volvemos atrás los cambios
-- actualizamos datos de campo creado usando una subconsulta
update empleados set smin =(select min(salary) from employees); 
update empleados set smax =(select ROUND(avg(salary),0) from employees); 

---------------------------------------------------------------------------

caracteristicas sql


se pueden usar en cualquier parte de sql, despues de ellas se pone en paréntesis cuál será la columna afectada por la función

UPPER: convierte todos los caracteres a mayusculas
ejemplo upper:
LOWER: hace a todos los caracteres minusculas 

INITCAP: pone en mayusculas la primera letra de cada palabra

LENGTH: MUESTRA EL LARGO DE UNA CADENA Y SE PUEDE USAR PARA FILTRAR

SUBSTR: EXTRAE los caracteres solicitados de una cadena

EJEMPLO SUBSTR:  SELECT first_name,SUBSTR(first_name,1,4) FROM EMPLOYEES;

SELECT first_name,SUBSTR(first_name,3) FROM EMPLOYEES;

SELECT first_name,SUBSTR(first_name, length(first_name),1) FROM EMPLOYEES
PRACTICAS HECHAS EN SQL DEVELOPER

select distinct city, state_province from locations;

select distinct job_id, department_id from employees;

select * from employees 
where department_id = 50;

/*
=
>
<
>=
<=
<>
*/

select first_name,salary from employees
WHERE salary > 5000;

SELECT first_name FROM EMPLOYEES
WHERE department_id <> 50;

SELECT first_name  FROM EMPLOYEES WHERE first_name<>'John';

SELECT * FROM EMPLOYEES; --1 DE ENERO 4712 AC

SELECT * FROM EMPLOYEES WHERE hire_date>'21-06-2007';

-- PRACTICAS CON WHERE

SELECT * FROM EMPLOYEES
WHERE department_id = 100;

SELECT city, street_address, country_id FROM LOCATIONS
WHERE country_id ='US';

SELECT * FROM countries
WHERE region_id = 3;

SELECT * FROM EMPLOYEES
WHERE manager_id <> 114;

SELECT * FROM EMPLOYEES
WHERE hire_date >= '1-1-2006';

SELECT * FROM EMPLOYEES
WHERE job_id = 'ST_CLERK';

SELECT * FROM EMPLOYEES 
WHERE last_name = 'Smith';

-- BETWEEN V1 AND V2

SELECT * FROM EMPLOYEES 
WHERE SALARY BETWEEN 5000 AND 6000;

SELECT * FROM EMPLOYEES 
WHERE hire_date BETWEEN '01-01-2007' AND '01-01-2009';

SELECT * FROM EMPLOYEES 
WHERE first_name BETWEEN 'Douglas' AND 'Steven';

-- IN (V1,V2,V3) 'SI EL VALOR ESTA DENTRO DE LA LISTA SE MUESTRA'

SELECT * FROM EMPLOYEES WHERE department_id IN (50,60);

SELECT * FROM EMPLOYEES WHERE job_id IN ('SH_CLERK','ST_CLERK','ST_MAN');

-- PRACTICAS BETWEEN IN

SELECT * FROM EMPLOYEES
WHERE department_id IN (40,60);

SELECT * FROM EMPLOYEES
WHERE hire_date BETWEEN '01-01-2002' AND '31-12-2004';

SELECT * FROM EMPLOYEES
WHERE last_name BETWEEN 'D' AND 'G';

SELECT * FROM EMPLOYEES
WHERE department_id IN (30,60,90);

SELECT * FROM EMPLOYEES
WHERE job_id IN ('IT_PROG','PU_CLERK');

SELECT * FROM LOCATIONS 
WHERE country_id IN ('UK','JP');

-- LIKE funciona solo con 'PATRON O CADENA DE CARACTERES'
-- %
-- _ 

SELECT * FROM EMPLOYEES
WHERE first_name LIKE 'J%';

SELECT * FROM EMPLOYEES WHERE
first_name LIKE '_e%';

SELECT * FROM EMPLOYEES WHERE
first_name LIKE '%te%';

-- PRACTICAS CON LIKE
/*
 Indicar los datos de los empleados cuyo FIRST_NAME empieza por ‘J’
 Averiguar los empleados que comienzan por ‘S’ y terminan en ‘n’
 Indicar los países que tienen una “r” en la segunda letra (Tabla COUNTRIES)
*/

SELECT * FROM EMPLOYEES WHERE
first_name LIKE 'J%';

SELECT * FROM EMPLOYEES WHERE
first_name LIKE 'S%n';

SELECT * FROM COUNTRIES WHERE
country_name LIKE '_r%';


-- Nulos
Select * from employees
WHERE commission_pct IS NULL;

Select * from employees
WHERE commission_pct IS NOT NULL;

-- Practicas NULL

/*
1 Listar las ciudades de la tabla LOCATIONS que no tienen STATE_PROVINCE
2 Averiguar el nombre, salario y comisión de aquellos empleados que tienen
  comisión. 
3 También debemos visualizar una columna calculada denominada
“Sueldo Total”, que sea el sueldo más la comisión
*/

Select * from LOCATIONS
WHERE state_province IS NULL ;

Select first_name, salary, commission_pct, (salary * commission_pct) + salary as "salario total" from employees
WHERE commission_pct IS NOT NULL;

/* CONDICIONES COMPLEJAS CON OPERADORES
AND C1 AND C2 --> TRUE SI 2 SE CUMPLEN
OR C1 OR C2 --> TRUE SI 1 SE CUMPLE
NOT C1 --> TRUE (NEGACION DEL RESULTADO)
*/

SELECT * FROM EMPLOYEES 
WHERE salary > 5000 AND department_id = 50;

SELECT * FROM EMPLOYEES 
WHERE salary > 5000 OR department_id = 50;

SELECT * FROM EMPLOYEES 
WHERE salary > 5000 AND department_id = 50;

SELECT * FROM EMPLOYEES 
WHERE department_id NOT IN (50,60);

/*
C1 AND C2 TRUE TRUE --> TRUE
C1 AND C2 TRUE FALSE --> FALSE
C1 AND C1 FALSE FALSE --> FALSE

C1 OR C2 TRUE TRUE --> TRUE
C1 OR C2 TRUE FALSE --> TRUE
C1 OR C2 FALSE FALSE --> FALSE
*/

/*
1 Obtener el nombre y la fecha de la entrada y el tipo de trabajo de los
 empleados que sean IT_PROG y que ganen menos de 6000 dólares
2 Seleccionar los empleados que trabajen en el departamento 50 o 80,
cuyo nombre comience por S y que ganen más de 3000 dólares.
3 ¿Qué empleados de job_id IT_PROG tienen un prefijo 5 en el teléfono
y entraron en la empresa en el año 2007?
*/
-- PRACTICAS AND OR

SELECT first_name, hire_date, job_id, salary FROM EMPLOYEES
WHERE job_id = 'IT_PROG' AND salary < 6000;

SELECT * FROM EMPLOYEES
WHERE first_name LIKE 'S%' AND (department_id =50 OR department_id = 80)
AND salary > 3000;

SELECT * FROM EMPLOYEES
WHERE job_id = 'IT_PROG' AND phone_number LIKE '5%' AND hire_date BETWEEN
'01-01-2007' AND '31-12-2007';

-- ORDER BY

SELECT * FROM EMPLOYEES 
ORDER BY salary DESC;

SELECT * FROM EMPLOYEES 
ORDER BY salary;

SELECT * FROM EMPLOYEES
ORDER BY first_name, last_name;

SELECT first_name, last_name, salary FROM EMPLOYEES
WHERE first_name ='David'
ORDER BY first_name, salary;

-- SE PUEDE MENCIONAR LA COLUMNA A ORDENAR POR SU NOMBRE O POR SU POSICIÓN
-- O POR SU ALIAS
SELECT first_name, salary*12 FROM EMPLOYEES
ORDER BY SALARY*12;

SELECT first_name, salary*12 FROM EMPLOYEES
ORDER BY 2;

SELECT first_name, salary*12 AS SALARIO FROM EMPLOYEES
ORDER BY SALARIO DESC;

--FETCH

SELECT first_name, salary FROM EMPLOYEES FETCH FIRST 10 ROWS ONLY;


/*
En la tabla LOCATIONS, averiguar las ciudades que son de Canada o
Estados unidos (Country_id=CA o US) y que la longitud del nombre de la
calle sea superior a 15.

• Muestra la longitud del nombre y el salario anual (por 14) para los
empleados cuyo apellido contenga el carácter 'b' después de la 3ª
posición.

• Averiguar los empleados que ganan entre 4000 y 7000 euros y que
tienen alguna 'a' en el nombre. (Debemos usar INSTR y da igual que sea
mayúscula que minúsculas) y que tengan comisión.

• Visualizar las iniciales de nombre y apellidos separados por puntos. Por
ejemplo; ellen abel = E.A
• Mostrar empleados donde el nombre o apellido comienza con S.. • Visualizar el nombre del empleado, su salario, y con asteriscos, el número miles de dólares que gana. Se asocia ejemplo. (PISTA: se puede usar RPAD. Ordenado por salario 

*/
	SOLUCIONES

-- 1 ejercicio
 select city,country_id, street_address from locations
 where country_id IN('CA','US') AND LENGTH(street_address) > 15;
-- 2 ejercicio
    SELECT first_name||' '||last_name AS NOMBRE,LENGTH(first_name||' '||last_name) AS LARGO,
    salary*14 SALARIO
    FROM EMPLOYEES
    WHERE INSTR(last_name,'b') > 3;
    
-- 3 EJERCICIO 
select * from employees
WHERE (salary BETWEEN 4000 AND 7000) AND INSTR(LOWER(first_name),'a')<> 0
AND commission_pct IS NOT NULL;
-- 4 EJERCICIO
SELECT first_name, last_name, SUBSTR(first_name,1,1)||'.'||SUBSTR(last_name,1,1)||'.'
AS INICIALES FROM EMPLOYEES;
-- 5 
SELECT first_name, last_name FROM EMPLOYEES
WHERE FIRST_NAME LIKE('S%') OR  last_name LIKE('S%');
-- 6
SELECT first_name, salary, RPAD('*',salary/1000,'*') AS RANKING FROM EMPLOYEES
ORDER BY salary DESC;

-- PRACTICAS NUMERICAS
/*
• Visualizar el nombre y salario de los empleados de los que el número de
empleado es impar (PISTA: MOD)
• Prueba con los siguientes valores aplicando las funciones TRUNC y
ROUND, con 1 y 2 decimales.
*/
SOLUCIONES
—---------------------
SELECT employee_id,first_name, salary FROM EMPLOYEES
WHERE MOD(employee_id, 2) <> 0;

SELECT ROUND(25.67,0) FROM DUAL;
SELECT ROUND(25.67,1) FROM DUAL;
SELECT ROUND(25.34,1) FROM DUAL;
SELECT ROUND(25.34,2) FROM DUAL;
SELECT ROUND(25.67,-1) FROM DUAL;


SELECT TRUNC(25.67,0) FROM DUAL;
SELECT TRUNC(25.67,1) FROM DUAL;
SELECT TRUNC(25.34,1) FROM DUAL;
SELECT TRUNC(25.34,2) FROM DUAL;
SELECT TRUNC(25.67,-1) FROM DUAL;

—-----------------------------------------------
20/01/2022
--to_char(date,'formato')

/*
AM PM MERIDIAN
HH FORMATO 12 HORAS
HH24 FORMATO 24 HORAS
MI MINUTO
SS SEGUNDOS
*/

SELECT SYSDATE, TO_CHAR(SYSDATE,'HH') FROM DUAL;
SELECT SYSDATE, TO_CHAR(SYSDATE,'HH24') FROM DUAL;
SELECT SYSDATE, TO_CHAR(SYSDATE,'MI') FROM DUAL;
SELECT SYSDATE, TO_CHAR(SYSDATE,'SS') FROM DUAL;

SELECT SYSDATE, TO_CHAR(SYSDATE,'"SON LAS" HH24:MI "DEL DIA" DAY "en el año" yyyy') FROM DUAL;

1. Funciones de conversion. TO_CHAR
• Indicar los empleados que entraron en Mayo en la empresa. Debemos
buscar por la abreviatura del mes
• Indicar los empleados que entraron en el año 2007 usando la función
to_char
• ¿Qué día de la semana (en letra) era el día que naciste?
• Averiguar los empleados que entraron en el mes de Junio. Debemos
preguntar por el mes en letra. Nota: La función TO_CHAR puede
devolver espacios a la derecha)
• Visualizar el salario de los empleados con dos decimales y en dólares y
también en la moneda local (el ejemplo es con euros, suponiendo que el
cambio esté en 0,79$)
*/

SELECT * FROM EMPLOYEES WHERE 
TO_CHAR(hire_date,'MON') = 'MAY';

SELECT * FROM EMPLOYEES
WHERE TO_CHAR(hire_date,'YYYY')= 2007;

SELECT TO_CHAR(TO_DATE('02-05-1998'),'DAY') FROM DUAL;

SELECT * FROM EMPLOYEES WHERE
TO_CHAR(hire_date,'MON') = 'JUN';

SELECT SALARY, TO_CHAR(salary,'$99999'), TO_CHAR(salary,'L99999'), TO_CHAR(salary,'99999.99') FROM EMPLOYEES;

--TO_DATE(STRING,'FORMATO')

SELECT TO_DATE('10-01-89') FROM DUAL;
SELECT TO_DATE('10-01-1989') FROM DUAL;
SELECT TO_DATE('10-JUN-89') FROM DUAL;
--FECHA SIN FORMATEAR FALLA
SELECT TO_DATE('12-22-89') FROM DUAL;

-- FORMATEANDO LA FECHA PARA QUE SEPA COMO LEERLA
SELECT TO_DATE('12-22-89','MM,DD,YY') FROM DUAL;
SELECT TO_DATE('JUN-22-89','mm-dd-yy') FROM DUAL;
/*
RR
yy

0-49 siglo actual
50-99 siglo 1900
USARA ESTE METODO AUTOMATICO CON RR
YY ES PARA PONER CUALQUIER FORMATO MANUALMENTE
*/

SELECT TO_CHAR(TO_DATE('10-01-89'),'DD-MM-YYYY')FROM DUAL;
SELECT TO_CHAR(TO_DATE('10-01-39'),'DD-MM-YYYY')FROM DUAL;
SELECT TO_CHAR(TO_DATE('10-01-39','DD-MM-RR'),'DD-MM-YYYY') FROM DUAL;
SELECT TO_CHAR(TO_DATE('10-01-99','DD-MM-YY'),'DD-MM-YYYY') FROM DUAL;

--TO_NUMBER(STRING,'FORMATO')
SELECT TO_NUMBER('1000.89','9999.99') FROM DUAL;
SELECT TO_NUMBER('$1000','L9999')FROM DUAL;

SELECT TO_NUMBER('1210.73','9999.99') FROM DUAL;
SELECT TO_NUMBER('$127.2','$9999.9') FROM DUAL;

SELECT TO_NUMBER('$127.2','$99999') FROM DUAL;
select TO_DATE('10-febrero-2018','dd-month-yyyy') from dual;

select phone_number,TO_NUMBER(SUBSTR(PHONE_NUMBER,1,3))*2 from employees;

--NULOS NVL(EXPRESION,VALOR) PUEDE DEVOLVER UN VALOR CONCRETO QUE EXPRESE LA CARACTERISTICA

SELECT NVL('HOLA','ADIOS') FROM DUAL;
SELECT NVL(NULL,'ADIOS') FROM DUAL;
SELECT NVL(NULL,NULL) FROM DUAL;

SELECT first_name, commission_pct*salary, NVL(commission_pct,0)*SALARY FROM EMPLOYEES;
--                CON V  SIN VALOR
-- NVL2(EXPRESION,VALOR1,VALOR2)

SELECT first_name,SALARY,NVL2(commission_pct,salary*commission_pct,salary*0.1), commission_pct FROM EMPLOYEES;

--NULLIF COMPARA DOS VALORES, SI SON IGUALES SALE NULO, SI NO SALE PRIMER VALOR (V1,V2)

SELECT NULLIF(1,1) FROM DUAL;
SELECT NULLIF(1,10) FROM DUAL;
-- SI EL RESULTADO ES IGUAL DEVUELVE NULO, SINO PRIMER VALOR
SELECT COUNTRY_ID,UPPER(SUBSTR(COUNTRY_NAME,1,2)), country_name, NULLIF(country_id,UPPER(SUBSTR(country_name,1,2))),
 NVL2( NULLIF(country_id,UPPER(SUBSTR(country_name,1,2))), 'NO SON IGUALES','SON IGUALES')
FROM COUNTRIES;
-- COALESCE(V1,V2,V3,V4) PERMITE PONER MUCHOS VALORES, CUANDO ENCUENTRA EL PRIMER NO NULO LO MUESTRA, SINO AVANZA
SELECT COALESCE(NULL,'VALOR1','VALOR2','VALOR3') FROM DUAL;
SELECT COALESCE(NULL,NULL,NULL,'VALOR3') FROM DUAL;
SELECT first_name, TO_CHAR(commission_pct), TO_CHAR(manager_id) FROM EMPLOYEES;
SELECT first_name, COALESCE(TO_CHAR(commission_pct), TO_CHAR(manager_id),'SIN JEFE NI COMISION') FROM EMPLOYEES;
-- EJERCICIOS DE PRACTICA
/*
• De la tabla LOCATIONS visualizar el nombre de la ciudad y el estadoprovincia. En el caso de que no tenga que aparezca el texto “No tiene”
• Visualizar el salario de los empleados incrementado en la comisión
(PCT_COMMISSION). Si no tiene comisión solo debe salir el salario
• Seleccionar el nombre del departamento y el manager_id. Si no tiene,
debe salir un -1
• De la tabla LOCATIONS, devolver NULL si la ciudad y la provincia son
iguales. Si no son iguales devolver la CITY.
*/
select city, NVL(state_province,'NO TIENE') from locations;
SELECT salary,commission_pct,NVL2(COMMISSION_PCT,SALARY+SALARY*COMMISSION_PCT/100,SALARY) FROM EMPLOYEES;
SELECT department_name,manager_id,COALESCE(TO_CHAR(manager_id),'-1') FROM DEPARTMENTS;
SELECT department_name, manager_id,NVL(manager_id,-1) FROM DEPARTMENTS;
SELECT city,state_province, NULLIF(city,state_province) FROM LOCATIONS;

select first_name,job_id,
CASE JOB_ID
WHEN 'AD_PRES' THEN 'TIPO 1'
WHEN 'SA_REP'  THEN 'TIPO 2'
WHEN UPPER('st_clerk') THEN 'TIPO 3'
WHEN 'IT_PROG' THEN 'TIPO 4'
WHEN 'SH_CLERK' THEN 'TIPO 5'
else 'SIN TIPO'
END CASE
from employees
WHERE DEPARTMENT_ID = 50;

-- CASE SEARCHED, SE PUEDEN USAR OPERADORES LOGICOS, CON MAYOR CAPACIDAD QUE EL ANTERIOR

SELECT first_name, salary,
CASE
WHEN salary < 2500 OR SALARY > 23000 THEN 'ERES POBRE'
WHEN SALARY BETWEEN 2500 AND 3500 THEN 'CLASE MEDIA BAJA'
WHEN SALARY BETWEEN 3501 AND 4500 THEN 'CASI GERENTE'
WHEN SALARY BETWEEN 4501 AND 5000 THEN 'ESTAFADOR PROFESIONAL'
WHEN SALARY BETWEEN 5001 AND 15000 THEN 'MILLONARIO'
WHEN SALARY > 15000 THEN 'PIÑERA'
END
FROM EMPLOYEES
ORDER BY SALARY;

-- DECODE, MAS ESTANDAR Y ANTIGUA QUE EL CASE
SELECT first_name, department_id,
DECODE(department_id,50,'informatica',90,'arquitecto',60,'matematico',80,'chofer','otro rol')
from employees;
 
/*
1. Expresiones condicionales
• Visualizar los siguientes datos con CASE.
o Si el departamento es 50 ponemos Transporte
o Si el departamento es 90 ponemos Dirección
o Cualquier otro número ponemos “Otro departamento”
• Mostrar de la tabla LOCATIONS, la ciudad y el país. Ponemos los
siguientes datos dependiendo de COUNTRY_ID.
o Si es US y CA ponemos América del Norte
o Si es CH, UK, DE,IT ponemos Europa
o Si es BR ponemos América del Sur
o Si no es ninguno ponemos ‘Otra zona’
• Realizar el primer ejercicio con DECODE en vez de con CASE
*/ 
-- SOLUCIONES
-- EJERCICIO 1 CON DECODE
SELECT FIRST_NAME, DEPARTMENT_ID,
DECODE(department_id,50,'TRANSPORTE',90,'DIRECCION','OTRO DEPARTAMENTO')
FROM EMPLOYEES;
-- EJERCICIO 1 CON CASE
select first_name, department_id,
CASE department_id
WHEN 50 THEN 'TRANSPORTE'
WHEN 90 THEN 'DIRECCION'
ELSE 'OTRO DEPARTAMENTO'
END CASE
from employees;
-- EJERCICIO 2
SELECT city,country_id,
CASE COUNTRY_ID
WHEN 'US' THEN 'AMERICA DEL NORTE'
WHEN 'CA' THEN 'AMERICA DEL NORTE'
WHEN 'BR' THEN 'AMERICA DEL SUR'
ELSE 'OTRA ZONA'
END
FROM LOCATIONS;
-- VERSION 2 EJERCICIO 2
SELECT CITY,COUNTRY_ID,
CASE 
WHEN COUNTRY_ID IN('US','CA') THEN 'AMERICA DEL NORTE'
WHEN COUNTRY_ID = 'BR' THEN 'AMERICA DEL SUR'
ELSE 'OTRA ZONA'
END CASE
FROM LOCATIONS;



-- FUNCIONES DE GRUPO, ESTAS NO PUEDEN JUNTARSE CON FUNCIONES SIMPLES
--AVG CALCULA PROMEDIO
  SELECT AVG(SALARY) FROM EMPLOYEES;
--MIN CALCULA MINIMO
  SELECT MIN(SALARY) FROM EMPLOYEES;
--MAX CALCULA MAXIMO
  SELECT MAX(SALARY) FROM EMPLOYEES;

SELECT AVG(SALARY), MIN(SALARY), MAX(SALARY) FROM EMPLOYEES
WHERE DEPARTMENT_ID= 50;

SELECT MAX(HIRE_DATE), MIN(HIRE_DATE) FROM EMPLOYEES;

SELECT MAX(FIRST_NAME), MIN(FIRST_NAME) FROM EMPLOYEES;

-- count cuenta todos los datos aunque sean repetidos, pero no los nulos
-- hay 107 empleados de los que solo 35 tienen comision
select count(first_name), count(commission_pct) from employees;

select count(employee_id) from employees;

select count(*) from employees
where department_id = 60;

select count(*) from employees
where salary > 6000;
-- distinct muestra resultados sin repetir
select count(distinct first_name) from employees;
select count(distinct department_id) from employees;
select distinct department_id from employees;
-- sum
select sum(salary) as "salario mensual",sum(salary)*12 as "salario anual"  from employees
where department_id = 50;

select max(salary)-min(salary) from employees;


-- natural join
-- EN LOS NATURAL JOIN NO SE DEBE PONER ID CON COLUMNA PORQUE LA PONE
AUTOMATICA
SELECT re.region_id, region_name, COUNTRY_ID, COUNTRY_NAME
FROM 
REGIONS RE NATURAL JOIN COUNTRIES CO;

-- LA TABLA DE MISMO NOMBRE CON DISTINTAS TABLAS SE PONE SIN SU ALIAS 
-- EN NATURAL JOIN
-- ES PELIGROSO NATURAL JOIN PORQUE PUEDE UNIR COLUMNAS DE TABLAS DISTINTAS
-- CON EL MISMO NOMBRE PERO DISTINTO SIGNIFICADO, DANDO RESULTADOS INCOHERENTES
-- SOLO SIRVE CUANDO SE UNEN TABLAS CON LOS MISMOS DATOS Y MISMO NOMBRE
SELECT REGION_NAME, COUNTRY_NAME
FROM
REGIONS RE NATURAL JOIN COUNTRIES CO;

-- USING
-- NOS SIRVE PARA ESPECIFICAR CUAL SERA LA COLUMNA DE UNION QUE QUEREMOS USAR
SELECT DEPARTMENT_NAME, FIRST_NAME
FROM EMPLOYEES E JOIN DEPARTMENTS D 
USING (DEPARTMENT_ID)
WHERE SALARY > 5000;

-- ON con un and.(funciona como un where)
SELECT E.DEPARTMENT_ID ,D.DEPARTMENT_NAME, E.FIRST_NAME,
L.CITY
FROM EMPLOYEES E JOIN DEPARTMENTS D 
ON (E.DEPARTMENT_ID=d.department_id)
 JOIN LOCATIONS L
 ON (d.location_id=l.location_id)
and SALARY > 5000;

-- PRACTICAS JOIN ON 

select country_name, region_name from countries
natural join 

-- GROUP BY, SE PUEDE UTILIZAR CON FUNCIONES DE GRUPO
-- JUNTO A TODAS LAS COLUMNAS AFECTADAS POR UN GROUP BY
select department_id, sum(salary),max(salary),trunc(avg(salary)) from employees
group by department_id
ORDER BY DEPARTMENT_ID;

-- HAVING ES COMO EL WHERE PERO PARA FUNCIONES DE GRUPO
SELECT DEPARTMENT_ID, JOB_ID, COUNT(*), SUM(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
HAVING SUM (SALARY) > 25000 AND COUNT(*) > 10
ORDER BY DEPARTMENT_ID;

-- PRACTICAS FUNCIONES DE GRUPO
SELECT DEPARTMENT_ID,COUNT(*) FROM EMPLOYEES
WHERE department_id = 50
GROUP BY DEPARTMENT_ID;

SELECT count(*) FROM EMPLOYEES
where hire_date BETWEEN '01-01-2007' and '31-12-2007';

select max(salary)-min(salary) from employees;

select sum(salary) FROM employees
where department_id = 100;

select department_id,ROUND(avg(salary),2) from employees
GROUP BY DEPARTMENT_ID;

select country_id, count(city) from countries c natural join
locations
GROUP by country_id
ORDER BY COUNT(CITY) DESC;

SELECT DEPARTMENT_ID, round(AVG(SALARY),2) FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL GROUP BY DEPARTMENT_ID;

select department_id,trunc(avg(salary))
, sum(commission_pct) as sas from employees
where commission_pct is not null
group by department_id;
-- TO_CHAR(hire_date,'YYYY') MOSTRAR AÑOS CON MAS DE 10 EMPLEADOS
select  TO_CHAR(hire_date,'YYYY') AÑO, COUNT(*)
FROM EMPLOYEES
GROUP BY TO_CHAR(HIRE_DATE,'YYYY')
HAVING COUNT (*) > 10
ORDER BY AÑO; 

SELECT DEPARTMENT_ID, TO_CHAR(HIRE_DATE,'YYYY') AÑO, COUNT(*)
FROM EMPLOYEES 
GROUP BY DEPARTMENT_ID,  TO_CHAR(HIRE_DATE,'YYYY')
ORDER BY DEPARTMENT_ID;

SELECT DISTINCT DEPARTMENT_ID, COUNT(employee_id), COUNT(manager_id) MANAGER
FROM EMPLOYEES 
GROUP BY DEPARTMENT_ID, MANAGER_ID
HAVING COUNT(manager_id) > 5;
-- practica joins
-- natural join para ver nombre y pais de region
select country_name, region_name from countries
natural join regions;
-- usando ejemplo anterior ver tambien ciudad
select c.country_name, region_name, city
from countries c join locations l on (c.country_id=l.country_id)
join regions r on (c.region_id=r.region_id);
-- indicar nombre de departamento y la media de sus salarios
select department_name, round(avg(salary),2)
from employees e join departments d on (e.department_id=d.department_id)
group by d.department_name; 
-- mismo con using
select department_name, round(avg(salary),2)
from employees e join departments d using (department_id)
group by d.department_name; 
-- nombre departamento manager y ciudad
select d.department_name,e.first_name, city from departments d
join employees e on (d.manager_id=e.employee_id)
join locations l on (l.location_id=d.location_id);
-- job title
select j.job_title, d.department_name, e.last_name,
e.hire_date as inicio from jobs j
join employees e on (e.job_id=j.job_id)
join departments d on (e.department_id=d.department_id)
where e.hire_date > '01-01-2000' and e.hire_date < '01-01-2004';
-- lo mismo con using
select last_name, hire_date, department_name, job_title
from employees join departments
using (department_id)
join jobs
using (job_id)
where to_char (hire_date,'yyyy') between 2002 and 2004;
-- job title y media salarios superiores a 7000
select j.job_title, avg(e.salary) salario from jobs j join 
employees e on (e.job_id=j.job_id)
group by j.job_title
having avg(e.salary) > 7000;
-- region y num departamento
SELECT REGION_NAME,COUNT(*) AS "NUM DEPAR"
FROM REGIONS NATURAL JOIN COUNTRIES NATURAL JOIN LOCATIONS 
NATURAL JOIN DEPARTMENTS
GROUP BY REGION_NAME;
-- mostrar nombre de empleado, departamento y país
select e.first_name, d.department_name,c.country_name
from employees e join departments d on d.department_id=e.department_id
join locations l on l.location_id=d.location_id join
countries c on c.country_id=l.country_id;
-- mismo con using
select e.first_name, d.department_name,c.country_name
from employees e join departments d using 
(department_id)
join locations l USING (LOCATION_ID) join
countries c USING (COUNTRY_ID);

-- cursores pl/sql
/*
implicitos
explicitos
los cursores explicitos se abren y se cierran, son mas potentes que los implicitos,
pero eso no significa que se deban usar en todos los casos
*/
/*
SQL%ISOPEN -- SOLO VALE PARA CURSORES EXPLÍCITOS ¿ESTA ABIERTO EL CURSOR?
SQL%FOUND  -- ¿SE ENCUENTRA UN CURSOR? SOLO APLICA A LO QUE ESTA ANTES DE LANZARLO
SQL%NOTFOUND-- ¿NO SE ENCUENTRA? 
SQL%ROWCOUNT -- CUENTA LAS FILAS DEL CURSOR
*/

begin
 UPDATE TEST SET C2='PPPP' WHERE C1= 10;
 DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
 IF SQL%FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ENCONTRADO');
    END IF;
     IF SQL%NOTFOUND THEN 
      DBMS_OUTPUT.PUT_LINE('NO ENCONTRADO');
       END IF;
 END;
 


DECLARE
    COL1 test.c1%TYPE;
BEGIN
    COL1:=10;
    INSERT INTO TEST (C1,C2) VALUES (COL1,'AAAA');
    COMMIT;
END;

DECLARE
    T TEST.C1%TYPE;
BEGIN
    T:=10;
    UPDATE TEST SET C2='CCCC' WHERE C1=T;
END;

DECLARE
 T test.c1%TYPE;
BEGIN
 T:=10;
 DELETE FROM TEST WHERE C1=T;
 COMMIT;
END;



BEGIN

INSERT INTO departments (DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) VALUES (300,'ARTE',107,1500);
END;

BEGIN
UPDATE departments SET location_id=1700 WHERE department_id=300;  
END;

BEGIN
DELETE FROM departments WHERE department_id=290;
COMMIT;
END;

-- cursor con loop simple

DECLARE
    CURSOR C1 IS SELECT * FROM REGIONS;
    V1 REGIONS%ROWTYPE;
BEGIN
    OPEN C1;
    LOOP
        FETCH C1 INTO V1;
        EXIT WHEN C1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V1.REGION_ID||' '|| V1.REGION_NAME);
    END LOOP;
    CLOSE C1;
---------------------------------------------------------
--BUCLE FOR, CUANDO SE USA CON CURSORES ES MAS SENCILLO

FOR i IN C1 LOOP 
  DBMS_OUTPUT.PUT_LINE(i.REGION_NAME);
    END LOOP;
    END;
    
    BEGIN
    FOR i IN (SELECT * FROM REGIONS) LOOP
     DBMS_OUTPUT.PUT_LINE(i.REGION_NAME||' '||i.region_id);
     END LOOP;
     END;
     
     DECLARE
     CURSOR C1 (SAL number) IS SELECT * FROM EMPLOYEES
     WHERE SALARY > SAL;
     emp1 EMPLOYEES%ROWTYPE;
    BEGIN
    OPEN C1(10000);
    LOOP
     FETCH C1 INTO  emp1;
     EXIT WHEN C1%NOTFOUND;
     DBMS_OUTPUT.PUT_LINE(emp1.first_name||' '||emp1.salary);
     END LOOP;
     DBMS_OUTPUT.PUT_LINE('HE ENCONTRADO '||c1%rowcount||' empleados');
     CLOSE C1;
     END;
     -- ACTUALIZAR DATOS CON CURSOR
     -- where current of significa que afecte a la fila en la que este en ese momento del cursor
     -- rowtype es que convierta la variableiable del tipo de toda la fila de la tabla asignada
     --for update es para poder posteriormente actualizar datos
     DECLARE
     empl employees%rowtype;
     CURSOR cur IS SELECT * FROM EMPLOYEES FOR UPDATE;
     BEGIN
     OPEN cur;
     LOOP
     FETCH cur INTO empl;
     EXIT WHEN cur%notfound;
     IF empl.COMMISSION_PCT IS NOT NULL THEN
        UPDATE EMPLOYEES SET SALARY=SALARY*1.10 WHERE CURRENT OF cur;
    ELSE
        UPDATE EMPLOYEES SET SALARY=SALARY*1.15 WHERE CURRENT OF cur;
    END IF;
  END LOOP;
  
  CLOSE cur;
END;

/*Hacer un programa que tenga un cursor que vaya visualizando los salarios de los empleados.
Si en el cursor aparece el jefe (Steven King) se debe generar un RAISE_APPLICATION_ERROR indicando que el sueldo del jefe no se puede ver
*/

DECLARE
CURSOR C1
IS SELECT first_name,last_name,salary from EMPLOYEES;
BEGIN
for i IN C1
LOOP
IF i.first_name='Steven' AND i.last_name='King'
THEN
raise_application_error(-20300,'El salario del jefe no puede ser visto');
ELSE
DBMS_OUTPUT.PUT_LINE(i.first_name ||' ' || i.last_name || ': '|| i.salary || 'DLS');
END IF;
END LOOP;
END;

/*Hacemos un bloque con dos cursores. (Esto se puede hacer fácilmente con una sola SELECT pero vamos a hacerlo de esta manera para probar parámetros en cursores)
o El primero de empleados
o El segundo de departamentos que tenga como parámetro el MANAGER_ID
o Por cada fila del primero, abrimos el segundo curso pasando el ID del MANAGER
o Debemos pintar el Nombre del departamento y el nombre del MANAGER_ID
o Si el empleado no es MANAGER de ningún departamento debemos poner “No es jefe de nada”
*/
 
SET SERVEROUTPUT ON
DECLARE
DEPARTAMENTO DEPARTMENTS%ROWTYPE;
jefe DEPARTMENTS.MANAGER_ID%TYPE;
CURSOR C1 IS SELECT * FROM EMployees;
CURSOR C2(j DEPARTMENTS.MANAGER_ID%TYPE)
IS SELECT * FROM DEPARTMENTS WHERE MANAGER_ID=j;
begin
for EMPLEADO in c1 loop
open c2(EMPLEADO.employee_id) ;
FETCH C2 into departamento;
if c2%NOTFOUND then
DBMS_OUTPUT.PUT_LINE(EMPLEADO.FIRST_NAME ||' No es JEFE de NADA');
ELSE
DBMS_OUTPUT.PUT_LINE(EMPLEADO.FIRST_NAME || 'ES JEFE DEL DEPARTAMENTO '|| DEPARTAMENTO.DEPARTMENT_NAME);
END IF;
CLOSE C2;
END LOOP;
END;


/*Crear un cursor con parámetros que pasando el número de departamento visualice el número de empleados de ese departamento*/

SET SERVEROUTPUT ON
DECLARE
CODIGO DEPARTMENTS.DEPARTMENT_ID%TYPE;
CURSOR C1(COD DEPARTMENTS.DEPARTMENT_ID%TYPE ) IS SELECT COUNT(*) FROM employeeS
WHERE DEPARTMENT_ID=COD;
NUM_EMPLE NUMBER;
BEGIN
CODIGO:=10;
OPEN C1(CODIGO);
FETCH C1 INTO NUM_EMPLE;
DBMS_OUTPUT.PUT_LINE('numero de empleados de ' ||codigo||' es '||num_emple);
end;


/*Crear un bucle FOR donde declaramos una subconsulta que nos devuelva el nombre de los empleados que sean ST_CLERCK. Es decir, no declaramos el cursor sino que lo indicamos directamente en el FOR.*/


BEGIN

  FOR EMPLE IN(SELECT * FROM EMPLOYEES WHERE JOB_ID='ST_CLERK') LOOP
     DBMS_OUTPUT.PUT_LINE(EMPLE.FIRST_NAME);
    END LOOP;
END;

/*Creamos un bloque que tenga un cursor para empleados. Debemos crearlo con FOR UPDATE.
o Por cada fila recuperada, si el salario es mayor de 8000 incrementamos el salario un 2%
o Si es menor de 800 lo hacemos en un 3%
o Debemos modificarlo con la cláusula CURRENT OF
o Comprobar que los salarios se han modificado correctamente.
*/

SET SERVEROUTPUT ON
DECLARE
CURSOR C1 IS SELECT * FROM EMployees for update;
begin
for EMPLEADO IN C1 LOOP
IF EMPLEADO.SALARY > 8000 THEN
UPDATE EMPLOYEES SET SALARY=SALARY*1.02
WHERE CURRENT OF C1;
ELSE
UPDATE EMPLOYEES SET SALARY=SALARY*1.03
WHERE CURRENT OF C1;
END IF;
END LOOP;
COMMIT;
END ;
     
/
SELECT * FROM TEST;


EXCEPCIONES
--	Ejemplo excepcion
Declare
  
	V_numero number;
	V_exe exception;  -- declarando variableiable de tipo excepción
Begin

	V_numero := &ingrese_numero; -- con el & le pediomos al usuario ingresar un numero
If v_numero > 10 then
		Dbms_output.put_line('el numero es mayor a 10');
Else
	Raise v_exe; -- si numero es menor a 10 ocurre excepción
End if;
When v_exe then
	Dbms_output.put_line(‘el numero no es mayor a 10’);
  when others then -- captura cualquier excepcion que no coincida con las anteriores
  DBMS_OUTPUT.put_line('error final');

End; 

 
Declare
  
	V_numero number;
	V_exe exception;  -- declarando variableiable de tipo excepción
Begin

	V_numero := &ingrese_numero; -- con el & le pedimos al usuario ingresar un numero
  If v_numero > 10 then
    Declare
      v_numero2 number;
    begin
      v_numero2:=&ingrese_segundo_numero;
      if v_numero2>10 then
        Dbms_output.put_line('Suma :' || (v_numero2+v_numero));
      
      end if;
      Else
	Raise v_exe; -- si numero es menor a 10 ocurre excepción
      end if;
    end; 

exception

When v_exe then
	Dbms_output.put_line(‘el numero no es mayor a 10’);
  when others then -- captura cualquier excepcion que no coincida con las anteriores
  DBMS_OUTPUT.put_line('error final');

End; 

-- ejemplo2 
--sql: select first_name,last_name from employees where employee_id=100;
--pl 

Declare
v_nombre variablechar2(45);
v_apellido variablechar2(45);
begin
    select first_name,last_name
    INTO v_nombre,v_apellido
     from employees where employee_id=&ingrese_codigo;
     Dbms_output.put_line('nombre completo: ' ||  v_nombre||' '||v_apellido);
end;

/*
a diferencia de los bloques anonimos, los procedimientos almacenados
se guardan en la base de datos con un nombre, las funciones deben retornar
un valor (como un void en java)

TRIGGER reacciona cuando ocurren acciones, tambien tienen nombre
PACKAGE es una clase en donde se pueden organizar los procedimientos y funciones


*/

-- creacion de procedimiento almacenados
create or replace procedure sp_ejemplo
is 
    v_numero1 number;
    v_numero2 number;
    v_total number;
begin
    v_numero1:= 5;
    v_numero2:=10;
    v_total:= v_numero1+v_numero2;
    DBMS_OUTPUT.PUT_line('la suma es: ' || v_total);
    end;

    -- se tomo el codigo y se guardo como procedimiento almacenado

    /*
    el amperson (&) es util en bloques anonimos, pero en procedimientos
    almacenados se pueden pasar parametos, igual que en un metodo
    */

    -- procedimiento con parametros

    create or replace procedure sp_ejemplo (p_num1 number,p_num2 number)
is 

    v_total number;
begin
    v_total:= p_num1+p_num2;
    DBMS_OUTPUT.PUT_line('la suma es: ' || v_total);
    end;

  -- para ejecutar procedimiento credado

  executeute sp_ejemplo; -- para cuando no tiene parametros

  executeute sp_ejemplo(num1,num2); -- cuando tiene parametros forma 1
  executeute sp_ejemplo(&ingrese_num1,&ingrese_num2); -- forma 2 de ejecucion con parametros

-------------------------------------------------------------
-- creando una funcion
create or replace
function fn_ejemplo(p_num1 number,p_num2 number)
return number -- se dice que tipo de dato retorna siempre
is
    -- declaracion de variableiables
    v_total number;
begin
    v_total:=p_num1+p_num2;
    return v_total;
end;
---------------------------------------------------------------------------
/*
para poder llamar una funcion se hace a traves de bloque
anonimo o de otro subprograma
*/

declare
    v_num1 number;
    v_num2 number;
    v_total number;
begin
    v_num1:=&Ingrese_num1;
    v_num2:=&Ingrese_num2;
    v_total:= fn_ejemplo(v_num1,v_num2);
    dbms_output.put_line('Total: ' || v_total);
end;
---------------------------------------------------------
-- los package se componen de cabecera y el body
-- en cabecera se definen objetos que se van a guardar
-- cabecera
create or replace package pkg_ejemplo
is
    procedure sp_ejemplo (p_num1 number,p_num2 number);

    function fn_ejemplo(p_num1 number,p_num2 number) 
    return number; -- se dice que tipo de dato retorna siempre
end;
-- fin cabecera
-----------------------------------------------------
-- body paquete
create or replace package body pkg_ejemplo
is
 procedure sp_ejemplo (p_num1 number,p_num2 number)
is 
    v_total number;
begin
    v_total:= p_num1+p_num2;
    DBMS_OUTPUT.PUT_line('la suma es: ' || v_total);
    end;

function fn_ejemplo(p_num1 number,p_num2 number)
return number -- se dice que tipo de dato retorna siempre
is -- is es como el declare 
    -- declaracion de variableiables
    v_total number;
begin
    v_total:=p_num1+p_num2;
    return v_total;
end;
end;
-- fin body 
-- ejecucion de procedimiento dentro de package
executeute pkg_ejemplo.sp_ejemplo(14,50);


-- USO SE EXCEPCIONES para errores comunes 
----------------------------------------------------------------
declare
    v_codigo number;
    v_nombre variablechar2(45);
    v_apellido variablechar2(45);
    v_email variablechar2(45);
begin
    select 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.email
    into v_codigo, v_nombre, v_apellido, v_email
    
    from employees e
    where employee_id > &Ingrese_Cod;
    DBMS_OUTPUT.put_line('recupero datos' || v_codigo);
    DBMS_OUTPUT.put_line('codigo: ' || v_codigo);
    DBMS_OUTPUT.put_line('Nombre: ' || v_nombre);
    DBMS_OUTPUT.put_line('email: ' || v_email);
exception
    when no_data_found then -- mensaje cuando no encuentra datos
        dbms_output.put_line('No recupero Datos, No Existe');
    when too_many_rows then -- mensaje cuando son demasiadas filas
        dbms_output.put_line('Has pedido demasiadas filas');
end;
--------------------------------------------------------------------
/
--select employee_id, first_name, last_name, email from employees;
/
-- Recorrer a todos los empleados
declare
begin
for reg in (select employee_id, first_name, last_name, email
from employees)
    LOOP
    dbms_output.put_line('Nombre: ' || reg.first_name ||' '|| reg.last_name);
    end loop;
end;
/
----------------------------------------
declare 
    v_codigo number(3) not null :=0;
    c_iva constant number:= 0.19; -- constante iva
    
begin
v_codigo :=88;
c_iva
;
end;
-----------------------
/
-- usando variableiables en bloque pl/sql
variableIABLE numero number;
execute :numero := 115
declare 
v_apellido variablechar2(45);
begin
    select last_name
    into v_apellido 
    from employees where employee_id=:numero;
    DBMS_OUTPUT.PUT_LINE('Apellido del empleado '||:numero||' es '||v_apellido );
end;
/
-- probando type y la inserción de datos de tablas en variableiables
declare
    v_nombre employees.first_name%type; -- type dice que variableiable nombre sera del mismo tipo que el campo first_name de la tabla employees
    v_apellido variablechar2(45);
    v_id number;
begin
    select first_name, last_name, employee_id
    into v_nombre, v_apellido, v_id
    from employees where employee_id=100;
    DBMS_OUTPUT.PUT_LINE('Nombre del empleado numero '||v_id ||' es '|| v_nombre||' '||v_apellido);
end;
/
/*
Requisitos para nombrar variableiables
A. Debe comenzar con una letra
B. Puede incluid caracteres especiales
como :$,_ y #. (aún asi no recomendado)
C. Puede incluir letras y números
D. No debe contener palabras reservadas
E. Debe tener un largo máximo de 30 caracteres

La Sintaxis considera:
identificador: es el nombre de variableiable
constant: indica que valor de variableiable no puede modificarse, deben inicializarse
tipo dato: indica que la variableiable es del tipo escalar, compuesto o lob
not null: indica que variableiable debe contener siempre un valor, debe ser inicializada
expr: es cualquier expresion pl/sql que puede ser expresion literal, otra variableiable
o incluso una expresion que utiliza una función.

Consideraciones para Declarar e inicializar variableiables pl/sql
- usar las convenciones de nombres para variableiables
- usar nombres de variableiables significativos
- Inicializar variableiables con not null y constant
- inicializar variableiables con := o Default
- Declarar un identificador por linea
- Evitar usar nombre de columnas como identificadores
- Usar not null cuando la variableiable debe almacenar un valor

- Tipos de datos escalares: tienen un solo valor, depende del tipo de dato de variable
- tipos de datos compuestos: recuperan variableios datos 
- tipos de datos de referencia: tienen valores llamados punteros que apuntan a un lugar
de almacenamiento (ej cursor)

D. Tipos de datos lob: tienen valores llamados localizadores que especifican 
la ubicacion de los objetos grandes (como imagenes) que se almacenan fuera de la
tabla.

E. variableiables Bind: No estan declaradas dentro del bloque, sino que fuera como
variableiables globales, estas pueden ser utilizadas por variableios bloques
*/
-- DIA 2 TAV    
/*
La Sintaxis considera:
identificador: es el nombre de variableiable
constant: indica que valor de variableiable no puede modificarse, deben inicializarse
tipo dato: indica que la variableiable es del tipo escalar, compuesto o lob
not null: indica que variableiable debe contener siempre un valor, debe ser inicializada
expr: es cualquier expresion pl/sql que puede ser expresion literal, otra variableiable
o incluso una expresion que utiliza una función.

Consideraciones para Declarar e inicializar variableiables pl/sql
- usar las convenciones de nombres para variableiables
- usar nombres de variableiables significativos
- Inicializar variableiables con not null y constant
- inicializar variableiables con := o Default
- Declarar un identificador por linea
- Evitar usar nombre de columnas como identificadores
- Usar not null cuando la variableiable debe almacenar un valor

- Tipos de datos escalares: tienen un solo valor, depende del tipo de dato de variable
- tipos de datos compuestos: recuperan variableios datos 
- tipos de datos de referencia: tienen valores llamados punteros que apuntan a un lugar
de almacenamiento (ej cursor)

D. Tipos de datos lob: tienen valores llamados localizadores que especifican 
la ubicacion de los objetos grandes (como imagenes) que se almacenan fuera de la
tabla.

E. variableiables Bind: No estan declaradas dentro del bloque, sino que fuera como
variableiables globales, estas pueden ser utilizadas por variableios bloques
*/

---------------------------------------------------------------------------------------
-- dia 2 tav
/*
simbolos simples: + - * /
delimitadores: son simbolos que tienen funciones especiales en pl/sql.
pueden ser operadores aritmeticos, logicos y operadores relacionales.
ej simbolos compuestos:
 :=
 =>
 ||
 (/ *) delimitador de inicio de comentario de variableias lineas
 (* /)delimitador de fin comentario variableias lineas
  .. operador de rango
 <> operador de distinto
 != operador distinto
 >= mayor o igual
 <= menor o igual
 -- comentario de una linea

Existen identificadores especiales denominados palabras reservadas,
no se pueden utilizar para declarar variableiables
- las buenas practicas permiten construid un codigo claro y de mantancion
mas facil

- Documentar el codigo con comentarios
Son una buena practica de programacion para explicar el codigo o parte 
del codigo de un bloque

- Escribir en mayusculas
* sentencias sql
* palabras reservadas
* tipos de datos

- Escribir en minusculas
* identificadores variableiables
* parametros
* nombres de tablas y columnas

- Indentar el codigo
- Nombre estandar de variableiables, comienzan von v (v_variable)
- Nombre de constantes estandar: comienza con c (c_cons)
- nombre registros estandar: comienzan con reg (reg_empleado)
- Nombre de cursores estandar: cur (cur_cursor)
- nombre de funciones estandar fn (fn_funcion)
- Nombre de procedimientos almacenados: sp (sp_procedimiento)
- Nombre packete: pkg (pkg_paquete)
- nombre trigger: tgr (tgr_trigger)
- nombre vistas: vw (vw_vista)
- nombre secuencias: seq (seq_cliente)

Sentencias y funciones integradas
Las funciones disponibles en sentencias procedimentasles son 
quellas que estan disponibles para ser usadas en sentencias pl/sql
y en sentencias sql que forman parte del bloque pl/sql

- funciones numericas
- funciones de caracteres de una fila
- funciones de conversiones de tipo de dato
- funciones de fecha
- funciones Timestamp
- funciones Greatest y Least
- funciones Generales

Funciones No Disponibles: solo pueden ser usadas en sentencias sql
(dentro de pl/sql)

*/

-- recuperar nombre completo, departamento y comision del empleado 
-- del id 120

declare
v_nombre_completo variablechar2(80);
v_depto departments.department_name%type;
v_comission employees.commission_pct%type;
begin
    select emp.first_name||' '||emp.last_name,
         dp.department_name,nvl(emp.commission_pct,0)
         
    into v_nombre_completo, v_depto,v_comission
    from employees emp 
    inner join departments dp
    on (emp.department_id = dp.department_id)
    where employee_id = 120;
    DBMS_OUTPUT.PUT_LINE('Nombre '|| v_nombre_completo);
    DBMS_OUTPUT.PUT_LINE('Depto '|| v_depto);
    DBMS_OUTPUT.PUT_LINE('Comision '|| v_comission);
end;
------------------------
select sysdate from dual;
----------------------------
create table xxx(
    id number primary key,
    nombre variablechar2(45)
);

create sequence seq_xxx;

declare
    v_contador number;
begin
    v_contador:=seq_xxx.nextval;

insert into xxx values(v_contador,'aldo');
end;
select * from xxx;
commit;
-- uso de update
declare
begin
    update xxx set nombre='Nicolas' where id=1;
    end;
    commit;
 -----------------------------------------
-- merge (si no existe inserta, si existe actualiza)
create table copia_empleados as (select * from employees);
select * from copia_empleados;
truncate table copia_empleados;

declare
begin
    merge into copia_empleados c
    using employees e 
    on (e.employee_id= c.employee_id) -- buscar
    when matched then
        update set c.last_name= e.last_name
    when not matched then 
        insert values(e.employee_id,e.first_name,e.last_name,e.email,
        e.phone_number,e.hire_date,e.job_id,e.salary,e.COMMISSION_PCT,e.manager_id,
        e.department_id);
end;

select * from copia_empleados order by employee_id;
rollback;

-- elimina empleado 100, todo lo hecho despues de eso se cancela
-- por el rollback hasta el savepoint hasta
declare 
begin
    delete from copia_empleados where employee_id= 101;
    commit;
    update copia_empleados set salary = salary-10;
    savepoint hasta;
    update copia_empleados set salary=salary+10000;
    update copia_empleados set COMMISSION_PCT=COMMISSION_PCT+0.1;
    rollback to hasta;
    commit;
end;

delete from copia_empleados; -- se eliminan todos los datos de tabla
rollback; -- se recuperan con volver atras en rollback
select * from copia_empleados;
/*
las consultas select into deben recuperar solo un valor
cada valor se debe almacenar en una variableiable mediante clausula into
debe retornar solo una fila cuando se utilizan variableiables escalares
si quiere recuperar multiples filas debe utilizar cursores

- Convenciones de Nombres
* usar convenciones para evitar ambigüedades en clausula where
* evitar nombre de columnas de bd para identificadores
* nombres de columnas de tablas de bd tienen precedencia
por sobre los nombres de variable locales
* nombres de variable locales y parametros formales tienen prioridad por sobre
los nombres de la tabla de la base de datos

- Manipulación de Datos en pl/sql

Se manipulan los datos en la bd mediante el uso de los comandos
DML. Se pueden ejecutar comandos DML de INSERT, UPDATE, DELETE Y 
MERGE sin restricciones en PL/SQL.
*/

/*
Control de transacciones pl/sql


- COMMIT finaliza la transaccion actual y 
efectua los cambios en bd

- ROLLBACK finaliza la transaccion actual y deshace todos 
los cambios realizados en la bd por la transaccion actual, 
deshace cambios hasta anterior commit o savepoint, para ir al savepoint
(rollback to nombre_savepoint )

- SAVEPOINT nombra y marca un punto donde se puede retornar el control
luego de ejecutarse una sentencia rollback

- CREATE TABLE, ALTER TABLE O DROP TABLE TIENEN UN COMMIT IMPLICITO
- se puede utilizar sql dinamico para otorgar permisos
*/

/*
Conversion de Tipo de datos

- CONVERSION IMPLICITA (Es Automatica)
- de variableCHAR2 o CHAR  a NUMBER.
- de variablechar2 o char a date
- de number a variablechar2
- de date a variablechar2

- CONVERSION EXPLICITA (Es manual mediante funciones predefinidas en sql)
- TO_CHAR
- TO_DATE
- TO_NUMBER
- TO_TIMESTAMP
*/

/*
Operadores pl/sql

- LOGICOS (AND, OR, NOT)
- ARITMETICOS (+,-,*,/)
- COMPARACION (=,<,>,<=,>=,<>,IS NULL ,LIKE ,BETWEENM IN)
- CONCATENACION (CONCAT,||)
- PARENTESIS PARA CONTROLAR EL ORDEN DE LAS OPERACIONES 
- EXPONENCIALES(**)

- OPERACIONES DE MAYOR A MENOR PRIORIDAD
- ** EXPONENCIACION
- +,- IDENTIFICACION, negacion
- *,/ multiplicacion, division
- <,> comparacion
- not negacion
- and conjuncion
- or inclusion
*/

-- GUIA 1 TAV (DIA 2)
-- ejercicio a 1.1
declare
    v_rut cliente.rutcliente%type;
    v_nombre cliente.nombre%type;
    v_cantidad number;
    v_suma number;
    v_max number;
    v_min number;
    v_pro number;
begin

select cli.rutcliente, cli.nombre,
count(fact.total), sum(fact.total), max(fact.total),
min(fact.total),avg(fact.total)

INTO v_rut,v_nombre,v_cantidad,v_suma,v_max,v_min,v_pro

from cliente cli 
inner join factura fact
on fact.rutcliente = cli.rutcliente
group by cli.rutcliente, cli.nombre
-- having se usa despues de agrupar, a diferencia del where que va antes
having count(fact.total)= (select max(count(fac.total)) 
                    from cliente cli inner join factura fac
                    on fac.rutcliente = cli.rutcliente
                    group by cli.nombre);

   dbms_output.put_line('Rut de Cliente: ' || v_rut);
   dbms_output.put_line('Nombre de Cliente: ' || v_nombre);
   dbms_output.put_line('Cantidad Factura : ' || v_cantidad);
   dbms_output.put_line('Monto Total Facturas : ' || v_suma);
   dbms_output.put_line('Monto Promedio Facturas: ' || v_pro);
   dbms_output.put_line('Monto Máximo Facturas: ' || v_max);
   dbms_output.put_line('Monto Minimo Facturas: ' || v_min);
end;
/
-- ejercicio b 1.1
-- sub consulta del monto mayor
select max(sum(fact.total)) from cliente cli
inner join factura fact
on fact.rutcliente=cli.rutcliente 
group by cli.nombre;

-- monto menor
select min(sum(fact.total)) from cliente cli
inner join factura fact
on fact.rutcliente=cli.rutcliente 
group by cli.nombre;

select cli.rutcliente, cli.nombre,sum(fact.total) from cliente cli inner join factura fact
on fact.rutcliente = cli.rutcliente 
group by cli.rutcliente, cli.nombre
having sum(fact.total) = (select min(sum(fact.total)) from cliente cli
inner join factura fact
on fact.rutcliente=cli.rutcliente 
group by cli.nombre);

declare
    v_run cliente.rutcliente%type;
    v_nombre variablechar2(50);
    v_sum number;
begin
select cli.rutcliente, 
cli.nombre,
sum(fact.total)
into v_run, v_nombre, v_sum
from cliente cli inner join factura fact
on fact.rutcliente = cli.rutcliente 
group by cli.rutcliente, cli.nombre
having sum(fact.total) = (select min(sum(fact.total)) from cliente cli
inner join factura fact
on fact.rutcliente=cli.rutcliente 
group by cli.nombre);

DBMS_OUTPUT.PUT_LINE('Cliente con Menor Facturación');
DBMS_OUTPUT.PUT_LINE('---------------------------------');
DBMS_OUTPUT.PUT_LINE('Rut '||v_run||' - Nombre:'||v_nombre||' Monto Facturado: '||v_sum);

select cli.rutcliente, 
cli.nombre,
sum(fact.total)
into v_run, v_nombre, v_sum
from cliente cli inner join factura fact
on fact.rutcliente = cli.rutcliente 
group by cli.rutcliente, cli.nombre
having sum(fact.total) = (select max(sum(fact.total)) from cliente cli
inner join factura fact
on fact.rutcliente=cli.rutcliente 
group by cli.nombre);

DBMS_OUTPUT.PUT_LINE('Cliente con Mayor Facturación');
DBMS_OUTPUT.PUT_LINE('---------------------------------');
DBMS_OUTPUT.PUT_LINE('Rut '||v_run||' - Nombre:'||v_nombre||' Monto Facturado: '||v_sum);

end;
/

----------------------------------------------------------------------------
-- DIA 3
/*
control de flujo de ejecucion
Expresiones case: retornan un resultado basado en una o mas alternativas,

SENTENCIAS CASE: evaluan una condicion y realiza una accion

SENTENCIA IF
IF condicion_verdadera THEN -- si cumple condicion hace esto
sentencias;
ELSIF condicion THEN -- si la anterior es falsa cumple esta
sentencias;
END IF;
-- (idealmente no tener mas de 5 if anidados, si es asi esta mal pensada la solucion)


-- repaso de update
para afectar toda una columna
update usuario set campo='realmadrir'

filtramos update para campos que cumplan con condicion
update usuarios set capo='boca'
where nombre='marcelo'

actualizamos dos columnas con un update
update (tabla) usuarios set (campos) nombre='marcelo', clave='10'
where nombre='marco'

DENTRO DE UN IF, LOS NULOS SE CONSIDERAN FALSOS 
*/

-----------------------------------------------------------------------
-- Instrucciones IF
declare
    v_numero number :=&ingrese_nota;

begin
    if v_numero > 1 and v_numero <4 then
        dbms_output.put_line('reprueba');
    elsif v_numero>=4 and v_numero<= 7 then 
        dbms_output.put_line('aprueba');
    else 
        dbms_output.put_line('pendiente');
    end if;
end;
/
-- escala
/*
    1- 3.5 => repro
    3.6 - 3.9 => oport
    4 - 4.5 => bueno
    4.6 - 5.5 => muy bueno
    5.5 > => excelente
*/
-- creamos tabla tramo notas
create table tramo_notas(
    id number primary key,
    minima number(2,1) not null,
    maxima number (2,1) not null
);
-- actualizamos campo minima
update tramo_notas set minima = 5.6
where id = 5;

-- insertamos datos en tramo_notas
insert into tramo_notas values (1, 1, 3.5); -- repro
insert into tramo_notas values (2, 3.6 ,3.9); -- oport
insert into tramo_notas values (3, 4, 4.5); -- bueno
insert into tramo_notas values (4, 4.6, 5.5);-- muy bueno
insert into tramo_notas values (5 ,5.6 ,7);-- excelente
commit;
select * from tramo_notas;

-- añadimos columna a tramo_notas
alter table tramo_notas add situacion variablechar2(45);

-- seteamos nuevo campo situacion de tabla tramo_notas
update tramo_notas set situacion ='Reprobado' where id = 1;
update tramo_notas set situacion ='Oportunidad' where id = 2;
update tramo_notas set situacion ='Bueno' where id = 3;
update tramo_notas set situacion ='Muy Bueno' where id = 4;
update tramo_notas set situacion ='Excelente' where id = 5;
/
-- ocupar tabla de tramo
declare
    v_nota number(2,1):= 0;
    v_situacion tramo_notas.situacion%type;
begin
    v_nota:=&Ingrese_nota;
    select situacion 
    into v_situacion
    from tramo_notas
    where v_nota between minima and maxima;
    dbms_output.put_line('Situacion: ' || v_situacion);
exception
    when no_data_found then 
    dbms_output.put_line('nota no se encuentra en los tramos');
    when too_many_rows then 
    dbms_output.put_line('Nota duplicada en tabla');
    when others then 
    dbms_output.put_line('problema diferente');
end;
/
-- Expresiones CASE
-- retorna un resultado basado en una o mas alternativas
-- CUANDO SE ANTEPONE UNA variableIABLE AL CASE (V_variable := CASE), el case termina con 'END';
-- CUANDO NO SE ANTEPONE, SE TERMINA CON 'END CASE';
declare
    v_categoria variablechar2(1):='A';
    v_sueldo number :=0;
    v_bono number :=0;
begin
    v_categoria:='&ingrese_categoria';
    v_sueldo:=&ingrese_sueldo;
    v_bono:= CASE -- CASE termina con end cuando se antepone variableiable
                WHEN v_categoria='A' and v_sueldo <1500 then 520
                WHEN v_categoria='A' and (v_sueldo >= 1500 and v_sueldo <= 3000) then 420
            else
                800
            end;
          dbms_output.put_line('Bono: ' || v_bono);  
end;
/
declare 
    v_categoria variablechar2(1):='A';
begin
    v_categoria:=UPPER('&Ingrese_categoria');
    case
        when v_categoria='A' then
            dbms_output.put_line('Mejor empleado');
        when v_categoria='B' then
            dbms_output.put_line('Buen empleado');
        when v_categoria='C' then
            dbms_output.put_line('Empleado normal');
        when v_categoria='D' then
            dbms_output.put_line('Mal empleado');
        else 
            dbms_output.put_line('EMPLEADO NO CATALOGADO');
    END case;
end;
/
---------------------------------------------------------
declare
    v_edad number;
begin
    if v_edad is null then
        dbms_output.put_line('es nulo');
    else 
        dbms_output.put_line('es nulo');
    end if;
end;
/
-- estructura de control de iteraciones
-- bucle eterno sin salida
-- loop simple

declare
    v_cont number:= 0;
begin
    loop
        dbms_output.put_line('Contador: '|| v_cont);
    v_cont := v_cont+1;
    end loop;
end;
/
-- bucle con condicion de salida
-- loop simple
declare
    v_cont number:= 0;
begin
    loop
        dbms_output.put_line('Contador: '|| v_cont);
    v_cont := v_cont+1; -- aumenta valor de variableiable
    exit when v_cont= 15; -- condicion de salida
    end loop;
end;
/
-- WHILE LOOP
-- while se usa como cabecera
declare
    v_contador number:=0;
begin
    while v_contador<10
    loop
    dbms_output.put_line('cont: '||v_contador);
    v_contador:= v_contador+1;
    end loop;
end;
/
--
declare
    
begin
    for v_cont in 1..10 -- v_cont es una variableiable temporal del for la cual se puede
                        -- utilizar dentro del loop, y los .. significan 'hasta'
                        -- ( for (para) v_cont in desde..hasta)
    loop
        dbms_output.put_line('Contador: ' || v_cont);
    end loop;
end;
/
---------------------------------------

-- registros en for
declare
    v_cate variablechar2(45);
begin
    for reg in (select first_name, salary from employees)
    loop
        if reg.salary>10000 then
        v_cate:='El Mejor empleado';
        else 
            v_cate:='Del Monton';
        end if;
        dbms_output.put_line('Nomb. '||reg.first_name||' categoria '||v_cate);
    end loop;
end;

-- CLASE 4
-- Solo se hicieron ejercicios de la primera unidad
-- CLASE 5, se MANDO PRUEBA
-- CLASE 6, SE ENVIO PRUEBA
---------------------------------------------------------------------------------
-- CLASE 7, COMIENZA LA SEGUNDA UNIDAD
/*
tipo de variableiables lob
* LOBS (largo objetos) el medio para almacenar datos grandes
* CLOB: usado para caracteres largos (libros), reemplaza al tipo long, esta dentro de bd
* BFILE: se guarda una referencia, indicando una ruta (vinculo), que apunta a la
  ubicacion de los datos (dentro de servidor), guardandose estos fuera de la base de datos.
* Existe una maxima cantidad de archivos concurrentes que pueden ser leidos por sesión,
la cual esta limitada por el parametro SESSION_MAX_OPEN_FILES(por defecto 10), por lo
que limita tambien la cantidad de lecturas concurrentes sobre campos BFILE por sesión.

* NCLOB: Similar a CLOB, solo que almacena texto cuyo juego de caracteres esta
definido por el National Character Set de la base de datos (guardar distintos idiomas
en un registro)

* Temporary Lob: Solo se encuentran vigente dentro del ciclo de vida dentro de una 
sesión de usuario, no generan redo log (ctrl + z) por lo que es mas liviano y rapido.
no soy muy frecuentes o utiles.

Package Oracle DBMS_LOB tiene las opciones:
- READ: lee en buffer el numero de bytes
- WRITE: escribe desde buffer indicando numero de bytes (BFILE, BLOB)
- COPY: Procedimiento que copia todo o parte del contenido de un LOB a otro LOB.
- ERASE: Elimina todo o parte del contenido de un LOB
- FILEEXISTS: Indica la existencia o no del archivo indicado,
si devuelve 1 existe, con 0 no existe

- FILEGETNAME: Devuelve el Directorio + archivo asociado a ese localizador, dentro de 
las variableiables indicadas.

- GETLENGHT: devuelve tamaño en bytes
-  LOADFROMFILE: Se usa para leer todo o parte de un archivo (se usara harto) 
- COMPARE: para comparar objetos.
 A) si devuelve 0 => archivos identicos
 B) 1 => archivos diferentes
 C) NULL => Objetos de diferente tipo.

- FILEOPEN: Abre el archivo definido por BFILE en el modo de acceso indicado
- FILECLOSE: Cierra el archivo previamente abierto
*/

-- creacion de objetos clob
create table informe(
    rut variablechar2(45),
    comentario clob DEFAULT empty_clob()
);
-- insertar registro en informe
insert into informe values('19913649-6','es un buen');
select * from informe;
/
-- actualizar el registro para agregar mas datos en 'comentario'
declare
    v_clob clob;
    v_largo number;
begin
    select comentario into v_clob
    from informe where rut='19913649-6' for update; -- for update significa que
    -- lo que le pase a la variableiable que guarda v_clob sera lo mismo que cambie en campo comentario
    select length(' hombre de familia') into v_largo from dual;
    dbms_lob.writeappend(v_clob,v_largo,' hombre de familia');
    commit;
end;
select * from informe;
----------------------------------------------
-- insertar imagenes
create table vacaciones2021(
    cod number primary key,
    descripcion variablechar2(80),
    foto blob default empty_blob()
);
select * from vacaciones2021;
-- crear una referencia hacia un directorio existente en el disco 
-- en el disco se debe ejecutar como administrador system
create or replace directory OBJ_VACACIONES as 'C:\vacaciones\';
-- dar permisos de uso del directorio al usuario o esquema prueba1_tav_freddie
grant read, write on directory OBJ_VACACIONES TO prueba1_tav_freddie;

-- recien ahora podemos insertar la imagen
declare
    v_blob blob; --guarda la foto como binario
    v_bfile bfile; -- dice donde esta la foto fisicamente en el disco
    v_foto variablechar2(80); -- indica como se llama la foto
begin
    insert into vacaciones2021 values(1,'cartagena en cuarentena',empty_blob())
    RETURNING foto into v_blob; -- se hace lo mismo que con for update
    -- significa que toma la foto vacia en empty y la guarda en v_blob
    -- cualquier cosa que pase en v_blob se insertara en campo blob
    v_foto:='cartagena.jpg';
    v_bfile:=bfilename('OBJ_VACACIONES',v_foto);
    dbms_lob.open(v_bfile,dbms_lob.lob_readonly);
    dbms_lob.loadfromfile(v_blob,v_bfile,dbms_lob.getlength(v_bfile));
    dbms_lob.close(v_bfile);
end;
select * from vacaciones2021;
---------------------------------------------------------------
-- carga masiva de fotografias (1:53:00 clase_7)
-- agregar campo tipo fotografia
alter table alumno add foto blob default empty_blob();
select * from alumno;

-- crear el objeto de tipo directorio (ejecutar en conexión system)
-- ubicacion siempre en mayuscula
-- se utilizo script de prueba1 tav
create or replace directory OBJ_ALUMNO as 'C:\alumno';
grant read, write on directory OBJ_ALUMNO to prueba1_tav_cristian;
-- bloque desde alumno
declare
    v_blob blob;
    v_bfile bfile;
    v_foto variablechar2(80);
begin -- proceso se deja dentro del bloque para capturar excepcion
    for x in (select * from alumno)
    loop
        begin
        v_foto:= x.cod_alumno||'.jpg';
        
        select foto into v_blob 
        from alumno where cod_alumno=x.cod_alumno for update; -- for update hace que cualquier cosa que le pase a variableiable le pasa a foto
    
        v_bfile:=bfilename('OBJ_ALUMNO',v_foto);
        dbms_lob.open(v_bfile, dbms_lob.lob_readonly);
        dbms_lob.loadfromfile(v_blob,v_bfile,dbms_lob.getlength(v_bfile));
        dbms_lob.close(v_bfile);
        commit;        
    exception
    when others then
        dbms_output.put_line('Foto: ' || v_foto || ' no esta');
        end;
    end loop;
end;

select * from alumno;
--------------------------------------------------------------------------------
-- cambio de script alumnos a prueba 2 de tav con freddie
-- se insertan imagenes en cadena como se haria en prueba, con tabla para guardar error
-- en caso de no encontrar foto

declare
    v_blob blob;
    v_bfile bfile;
    v_foto variablechar2(300);
    v_mensaje_error variablechar2(300);
begin
    for x in (select * from alumno)
    loop
        declare
        begin
        v_foto:=x.cod_alumno||'.jpg';
        select foto into v_blob from alumno
        where cod_alumno = x.cod_alumno for update;
        
        v_bfile:=bfilename('OBJ_ESTUDIANTES',v_foto);
        dbms_lob.open(v_bfile, dbms_lob.lob_readonly);
        dbms_lob.loadfromfile(v_blob, v_bfile, dbms_lob.getlength(v_bfile));-- guarda en blob imagen en bfile, y que sea el largo total de imagen
        dbms_lob.close(v_bfile);
        commit;
    exception
        when others then
            v_mensaje_error := sqlerrm;
            insert into error_fotografias
            values(seq_error_foto.nextval,v_mensaje_error,v_foto); -- inserta seq, men erorr y nombre foto con error
        end;
    end loop;
end;

----------------------------------------------------------------------------------------

select * from alumno;
select * from error_fotografias;
alter table alumno add foto blob DEFAULT empty_blob();

-- tabla de error fotos
drop table error_fotografias;
create table error_fotografias(
    id number primary key,
    descripcion variablechar2(300),
    foto variablechar2(300)
);
commit;

create sequence seq_error_foto;
drop sequence seq_error_foto;
-- crear objeto directorio
create or replace directory OBJ_ESTUDIANTES AS 'C:\estudiantes';
grant read, write on directory OBJ_ESTUDIANTES to prueba2_tav_freddie;
/
-- insertar imagenes

declare
    v_blob blob;
    v_bfile bfile;
    v_foto variablechar2(300);
    v_mensaje_error variablechar2(300);
begin
    for x in (select * from alumno)
    loop
        declare
        begin
        v_foto:=x.cod_alumno||'.jpg';
        select foto into v_blob from alumno
        where cod_alumno = x.cod_alumno for update;
        
        v_bfile:=bfilename('OBJ_ESTUDIANTES',v_foto);
        dbms_lob.open(v_bfile, dbms_lob.lob_readonly);
        dbms_lob.loadfromfile(v_blob, v_bfile, dbms_lob.getlength(v_bfile));-- guarda en blob imagen en bfile, y que sea el largo total de imagen
        dbms_lob.close(v_bfile);
        commit;
    exception
        when others then
            v_mensaje_error := sqlerrm;
            insert into error_fotografias
            values(seq_error_foto.nextval,v_mensaje_error,v_foto); -- inserta seq, men erorr y nombre foto con error
        end;
    end loop;
end;
----------------------------------------------------------------------
-- objetos compuestos, son como variableiables pero con tipo
declare 
    type tipo_reg is record(
        nombre variablechar2(45),
        edad number(3),
        rut variablechar2(12)
    );
    reg_emp tipo_reg;
begin
    reg_emp.nombre:='Juanito';
    reg_emp.edad:=25;
    reg_emp.rut:='19913649-6';
    dbms_output.put_line('Nombre: '||reg_emp.nombre);
    dbms_output.put_line('Edad: '||reg_emp.edad);
    dbms_output.put_line('Rut: '||reg_emp.rut);
end;
/
---- crear un tipo table

declare
    type tipo_nombres is table of 
        PROFESOR.PNOMBRE%type
        index by pls_integer;
    v_nombre  tipo_nombres;
    
begin
    declare
    begin
    v_nombre(1):='Marco';
    v_nombre(3):='Antonio';
    v_nombre(8):='Pedro';
    DBMS_OUTPUT.PUT_LINE('nombre 1: ' || v_nombre(1));
    DBMS_OUTPUT.PUT_LINE('nombre 1: ' || v_nombre(2));
    exception
    when no_data_found then
    DBMS_OUTPUT.PUT_LINE('no existe el nombre solicitado ');
    end;
end;
/
-- creacion de tabla y recorrer con for

declare
    type comunas is table of variablechar2(100) 
    index by pls_integer;-- indexar sirve para reorganizar
    v_comunas comunas;
begin
    v_comunas(1):='Las Condes';
    v_comunas(2):='Vitacura';
    v_comunas(3):='Providencia';
    v_comunas(4):='La Reina';
    v_comunas(5):='Maipu';
    v_comunas(6):='Puente Alto';
    v_comunas(7):='San Miguel';
    
    for x in v_comunas.first..v_comunas.last
    loop
        dbms_output.put_line('Comuna: '|| v_comunas(x));
    end loop;
end;

-- creacion de cursor basico
declare
    cursor cur_profesores is select * from profesor;
    reg_profesores cur_profesores%rowtype; -- rowtype hace la variableiable del tipo de fila cursor (tabla)
begin
    -- un cursor primero se abre
    open cur_profesores;
    loop
        -- recuperar un registro del curosr
        FETCH cur_profesores into reg_profesores;
        -- salir cuando no hay mas registros
        exit when cur_profesores%notfound; -- condicion de salida
        -- procesar el registro recuperado
       dbms_output.put_line('Nombre: ' || reg_profesores.pnombre);
    end loop;
    close cur_profesores;
end;
----------------------------------------------------------------------------------------
-- CLASE 8


-- se pueden utilizar atributos con cursores, como los siguientes:
-- %isopen %notfound %found %rowcount
-- se debe anteponer sql (sql%rowcount) y para cursores anteponer nombre cursor (cur%notfound)
-- en cursores implicitos se usa sql, en explicitos nombre cursor
--tambien se pueden usar con delete update insert

-- el cursor se aplica sobre columnas especificadas, no es conveniente hacer un select *,
-- es mejor especificar

/*
sql%open BOOLEANO 
sql%notfound BOOLEANO si no encuentra registros afectados es verdadera
sql%found BOOLEANO retorna verdadero si la ultima sentencia afecto a n filas
sql%rowcount NUMERICO cuenta las filas afectadas
*/

-- clausula desc sirve para ver tipos de datos en una tabla
-- opciones asociadas a cursores implicitos
/*
no_data_found: se produce cuando sentencia select intenta recuperar datos pero no 
encuentra ninguno

too_many_rows: ocurre cuando se detecta mas de una fila en los resultados, puesto que 
que cursores implicitos solo pueden recuperar una fila
*/

-- ejemplo de error con excepcion
-- DEBEMOS DEJAR CONSTANCIA DE ERRROES INSERTANDOLOS EN UNA TABLA
declare
v_apellido variableCHAR2(50);
begin
select LAS_NAME
  into v_apellido
  from EMPLOYEES
 where FIRST_NAME='DEVID';
exception
  when no_data_found then
    DBMS_OUTPUT.PUT_LINE('ERROR!!! CURSOR IMPLICITO NO RETORNA FILAS');

    insert into ERRORES 
    values (
        SEQ_EMPLEADO.nextval,
        'ERROR EN EL PROCESO DE EMPLEADO CON NOMBRE DEVID. NO EXISTEN FILAS A PROCESAR');
end;

-- otro ejemplo de exepciones

DECLARE
    v_cod alumno.cod_alumno%type;
    v_error variablechar2(300);
BEGIN
    select cod_alumno into v_cod
    from alumno
    where cod_alumno=10;
    DBMS_OUTPUT.PUT_LINE('el alumno existe');
exception
    when no_data_found then
    DBMS_OUTPUT.PUT_LINE('no existe alumno');
    when too_many_rows then
    DBMS_OUTPUT.PUT_LINE('muchas filas de retorno');
    when others then -- siempre es bueno usar when others para errores desconocidos
    -- y aplicar variableiable para insertar cual es el error
    v_error:= sqlerrm;
    DBMS_OUTPUT.PUT_LINE('Error: ' || v_error);
END;
---------------- uso de atributos sql (%)
select * from alumno;
declare
    
begin
    update alumno set porc_repro = 2 where cod_alumno=1;
    if sql%notfound then 
        DBMS_OUTPUT.PUT_line('No modifica');
        else
        dbms_output.put_line('actualizo N° ' || SQL%ROWCOUNT);
    END IF;
end;
desc alumno;
------------------------------------------------------------
declare
begin
    delete from tramo_asistencia where id_tramo = 1;
    if sql%found then
    dbms_output.put_line('Se eliminaron '||sql%rowcount);
    else
    dbms_output.put_line('No se eliminaron registros.');
end if;
end;
rollback;
select * from tramo_asistencia;
----------------------------------------------------------
-- cursor explicito que retorna cod alumno y rut
declare
    cursor cur_alumnos is
    (select cod_alumno, numrut, dvrut from alumno);
    v_cod alumno.cod_alumno%type;
    v_run alumno.numrut%type;
    v_dv alumno.dvrut%type;
begin
    open cur_alumnos;
    loop
        fetch cur_alumnos INTO v_cod, v_run, v_dv;
        exit when cur_alumnos%notfound;
        DBMS_OUTPUT.PUT_LINE('cod_alumno '||v_cod);        
        DBMS_OUTPUT.PUT_LINE('Rut: '||v_run||'-'||v_dv);
    end loop;
    close cur_alumnos;
end;
-- creacion de cursor con registro como variableiable compuesta
declare
    cursor cur_alumnos is
    (select cod_alumno, numrut, dvrut from alumno);
    reg_alumnos cur_alumnos%rowtype; -- reg es de tipo cursor
begin
    open cur_alumnos;
    loop
        fetch cur_alumnos INTO reg_alumnos;
        exit when cur_alumnos%notfound;
        DBMS_OUTPUT.PUT_LINE('cod_alumno '||reg_alumnos.cod_alumno);        
        DBMS_OUTPUT.PUT_LINE('Rut: '||reg_alumnos.numrut||'-'||reg_alumnos.dvrut);
    end loop;
    close cur_alumnos;
end;
-- creacion de tabla e insercion de datos a traves de cursor
-- manera simple de crear tabla
create table clie2 as
(select numrut, dvrut
  from alumno);

-- manera independiente
create table clie(
    run number primary key,
    dv_run variablechar2(1)
);

declare
    cursor cur_alumnos is
    (select cod_alumno, numrut, dvrut from alumno);
    reg_alumnos cur_alumnos%rowtype; -- reg es de tipo cursor
begin
    open cur_alumnos;
    loop
        fetch cur_alumnos INTO reg_alumnos;
        exit when cur_alumnos%notfound;
        DBMS_OUTPUT.PUT_LINE('cod_alumno '||reg_alumnos.cod_alumno);        
        DBMS_OUTPUT.PUT_LINE('Rut: '||reg_alumnos.numrut||'-'||reg_alumnos.dvrut);
        insert into clie values(reg_alumnos.numrut,reg_alumnos.dvrut);
    end loop;
    close cur_alumnos;
end;
select * from clie;

/*
-- un cursor puede ser reabierto solo si esta cerrado, 
si se leen datos de un cursor cerrado aparece la excepcion INVALID_CURSOR

- por defecto se pueden tener abiertos 50 cursores por sesión, esto se determina
con el parametro OPEN_CURSORS

atributos para cursores explicitos:
cur%isopen
cur%notfound
cur%found rowcount
cur%rowcount

EXIT WHEN cur_emp%rowcount >10 or cur_emp%notfound;
(sale del cursor al encontrar 10 resultados o al momento de dejar de encontrar datos)


*/

-- ver cada cliente con sus creditos
declare
    cursor cur_clientes is select * from clientes;
    cursor cur_creditos(p_run number) is
    -- parametro que asocia cliente con cada uno de sus creditos
    select * from creditos where run_cliente=p_run;
    reg_cli cur_clientes%rowtype;
    reg_cre cur_creditos%rowtype;
    v_total number:=0;
    v_nombre variablechar2(100);
begin
    open cur_clientes;
    loop
    fetch cur_clientes into reg_cli;
    exit when cur_clientes %notfound;
    v_nombre:=reg_cli.nombre ||' '||reg_cli.appaterno||' '||reg_cli.apmaterno;
        dbms_output.put_line('Nombre: '||v_nombre||' Direccion: '||reg_cli.direccion);   
    
    open cur_creditos(reg_cli.run_cliente);
    loop
        fetch cur_creditos into reg_cre;
        exit when cur_creditos%notfound;
      dbms_output.put_line('id: '|| reg_cre.id_credito||'monto: '||reg_cre.monto_pago||'cuotas'||reg_cre.cuotas)
    end loop;
    close cur_creditos;
end loop;
close cur_clientes;
end;

-- ejemplo variableray
/*
1.define, 2.declara, 3.inicializa, 4.asigna, 5.accede
*/
-- se define con type
declare
TYPE V_array_type IS variableray(7) OF variableCHAR2(30);

-- se declara e inicializa
v_day V_array_type :=V_array_type(null,null,null,
                        null,null,null,null,);
-- se asigna
begin
  v_day(1) := 'monday';
    v_day(2) := 'tuesday';
      v_day(3) := 'wednesday';
        v_day(4) := 'thursday';
          v_day(5) := 'friday';
            v_day(6) := 'saturday';
              v_day(7) := 'sunday';

    -- se accede
    dbms_output.put_line('v_day(1)' || v_day(1));
    dbms_output.put_line('v_day(2)' || v_day(2));
    dbms_output.put_line('v_day(3)' || v_day(3));
    dbms_output.put_line('v_day(4)' || v_day(4));
    dbms_output.put_line('v_day(5)' || v_day(5));
    dbms_output.put_line('v_day(6)' || v_day(6));
    dbms_output.put_line('v_day(7)' || v_day(7));
end;






/*
- diferencia drop y truncate es que truncate borra resultados
pero no la tabla.
- y drop borra todo, tanto tabla como sus datos

parametros formale
son variableiables declaradas en la lista de parametros del
subprograma(modo in, out o in out) por defecto es in,
se usan en la seccion de ejecucion.

parametros actuales.
son valores, variableiables o expresiones usados para ejecutar un subprograma 
con parametros. se asocian a los parametros formales del sub
programa.

variableray tiene un solo tipo de dato
in out manda un valor adentro y se pide que retorne un resultado

primer cursor tiene relacion de uno a muchos para el segundo
*/

-- avance prueba2 

/*
condiciones para hacer la prueba 
- se debe redondear todo a enteros  
- funciones parametricas para informacion (BIND)
- por cada profesional procesado se almacena en detalle_asignacion_mes
- en resumen_mes_profesion va resumen de profesiones de datos obtenidos en proceso
- informacion de errores que se deben controlar en el proceso se almacena en tabla errores_p
- error_id es = a seq_errores
- BIND para  fechas y valor limite 410.000 de asignacion de pago 
- variableRAY para: valores de 5 porcentajes de traslado y monto mov fijo
- record para almacenar informacion. min dos registros
- estructura for loop y while loop para cursores
- valores redondeados
- dos cursores simultaneos para informacion detallada y resumida
- excepcion definida por usuario para capturar monto total de asignaciones
- (que no supere los 410.000), se debe interceptar error y guardar en tabla
- de errores y reemplazar monto calculado de comision por monto limite (410.000)
- excepciones predefinidas para controlar cualquier error que se produzca de recuperar
- los % necesarios para calcular asignacion por evaluacion.
- tabla DETALLE_ASIGNACION info se debe almacenar ordenada en forma ascendente por
profesion, apellido paterno y nombre del profesional. 
En tabla resumen ascendente por profesion
PARA LA PRUEBA. EJECUTAR PROCESO CONSIDERANDO ASESORIAS DEL MES DE JUNIO DE 2021.
*/

-- obtener numero y monto total de las asesorias de todos los profesionales
-- en mes de proceso, se debe poder cambiar mes y año (bind)
DROP SEQUENCE SEQ_ID;
CREATE SEQUENCE SEQ_ID;
TRUNCATE TABLE DETALLE_ASIGNACION_MES; 
TRUNCATE TABLE RESUMEN_MES_PROFESION;
TRUNCATE TABLE ERRORES_P;

variableIABLE b_mes_proceso number;
execute :b_mes_proceso :=6; 
variableIABLE b_anno_proceso number;
execute :b_anno_proceso :=2021; 

DECLARE
    TYPE asesoria_type IS RECORD(
    mes number,
    anno number,
    run number,
    nombre variablechar2(80),
    profesion variablechar2(50),
    nro_ases number,
    honorarios number, 
    asig_mov number,
    asig_eval number,
    asig_tipocont number,
    asig_profesion number,
    total_asignaciones_profesional number);
    
    rec_asesoria asesoria_type;
 
  CURSOR cur_asesoria is (select
     EXTRACT(MONTH FROM ases.inicio_asesoria) as mes_proceso,
     EXTRACT(YEAR FROM ases.inicio_asesoria) as anno_proceso,
     ases.numrun_prof as numrun_prof,
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno as nombre_profesional, 
     prosion.nombre_profesion as profesion,
     count(ases.numrun_prof)
    -- ases.honorario as honorarios
 
     from asesoria ases
     INNER JOIN profesional prof
     on (ases.numrun_prof=prof.numrun_prof)
     INNER JOIN PROFESION prosion ON (prosion.cod_profesion=prof.cod_profesion)
     WHERE extract(month from inicio_asesoria)=:b_mes_proceso
     AND extract(YEAR FROM inicio_asesoria)=:b_anno_proceso
 group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria), 
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     ases.numrun_prof, prof.nombre||' '||prof.appaterno||' '||prof.apmaterno,
     prosion.nombre_profesion)
 order by ases.numrun_prof;
 BEGIN
open cur_asesoria;
loop
 fetch cur_asesoria into rec_asesoria.mes, rec_asesoria.anno,rec_asesoria.run 
 ,rec_asesoria.nombre,rec_asesoria.profesion,rec_asesoria.nro_ases;
 exit when cur_asesoria%notfound;
 
 DBMS_OUTPUT.PUT_LINE('mes '||rec_asesoria.mes||' año '||rec_asesoria.anno||
 ' run '||rec_asesoria.run||' nombre '||rec_asesoria.nombre||' profesion '||
 rec_asesoria.profesion||' n° asesorias '||rec_asesoria.nro_ases);
end loop;
close cur_asesoria;
end;


-- MANEJO DE EXCEPCIONES
/*
- siempre es buena practica colocar when others al final para errores
- que no podemos manejar

- exception comienza la seccion de manejo de excepciones
- se pueden crear variableios controladores de excepciones
- solo un gestor de excepciones es procesado antes qde que la ejecucion
- del bloque finaliza 
- when others debe ser la ultima clausula de manejo de excepciones.
- guardar errores en bd para tener nociones de lo que ocurre
*/

/*
excepciones predefinidas del servidor oracle
DUP_VAL_ON_INDEX ORA-00001(error de duplicacion primary key)
INVALID_CURSOR ORA-01001(cuando cursor no retorna registros)
INVALID_NUMBER ORA-01722 (cuando se cargan variableiables largos en variable de tamaño pequeño)
NO_DATA_FOUND ORA-01403 (cuando no encuentra datos en select into)
TOO_MANY_ROWS ORA-06502 (CUANDO RETORNA MUCHAS FILAS)
VALUE_ERROR ORA-06502 (cuando se ingresan valores erroneos como number en campo variablechar2)
ZERO_DIVIDE ORA-01476 (cuando se divide el contenido de una variableiable con valor 0 o nulo)
*/

--  CONTROLANDO EXCEPCIONES PREDEFINIDAS 
-- captura no_data_found
DECLARE
v_name variablechar2(15);
begin
 select last_name
    into v_name
    from employees
    where first_name='Juanito';
    DBMS_OUTPUT.PUT_LINE('Johns last name: '||v_name);
    exception
    WHEN TOO_MANY_ROWS THEN
    dbms_output.put_line('la sentencia select recupera multiples filas');
    when no_data_found then
    dbms_output.put_line('la sentencia select no recupera filas');
    end;
    
-- sqlcode entrega numero de error
-- sqlerrm recupera descripcion de error
-- variablechar para sqlerrm se recomienda de tamaño mayor a 200

-- Bloques anidados para controlar excepciones
-- cuando hay mas de un cursor usar excepciones para cada bloque

 --exception con nombre (pragma)
 select * from departments;
 
 declare
 v_codigo_error number;
 v_mensaje_error variablechar2(255);
 begin
    insert into departments
    values (10,'informatica',200,1700);
exception
    when others then
    v_codigo_error:=sqlcode;
    v_mensaje_error:=sqlerrm;
    DBMS_OUTPUT.PUT_LINE('error '|| v_codigo_error);
    DBMS_OUTPUT.PUT_LINE('mensaje error '|| v_mensaje_error);
 end;
 
 -- asignar nombre a numero de error
     
 declare
    error_clave_duplicada exception;
    -- se asocia error -1 con nombre creado de excepcion
    pragma EXCEPTION_INIT (error_clave_duplicada, -1);
    v_mensaje_error variablechar2(255);
 begin
    insert into departments
    values (10,'informatica',200,1700);
exception 
-- cuando ocurre error -1 ocurre excepcion
    when error_clave_duplicada then
    DBMS_OUTPUT.PUT_LINE('error clave duplicada');
    when others then
    v_mensaje_error:=sqlerrm;
    DBMS_OUTPUT.PUT_LINE('error codigo'|| sqlcode);
    DBMS_OUTPUT.PUT_LINE('mensaje error '|| v_mensaje_error);
 end;
 ---------------------------
 --excepcion con raise
 
DECLARE
    v_edad number;
    error_edad exception;
BEGIN
    v_edad:=&ingrese_edad;
    if v_edad<18 then
        raise error_edad;
    end if;
    DBMS_OUTPUT.PUT_LINE('es mayor de edad ');
exception
    when error_edad then
    DBMS_OUTPUT.PUT_LINE('es menor de edad: ' || v_edad);
END;
-- raise con manejo de sql (update, delete, insert)

declare
    error_actualizar exception;
begin
    update employees set salary=salary+1500
    where employee_id=99;
    if sql%notfound then 
    raise error_actualizar;
end if;
    DBMS_OUTPUT.PUT_LINE('hay '|| sql%rowcount||' suertudos');
exception
    when error_actualizar then
        DBMS_OUTPUT.PUT_LINE('no existen suertudos');
end;

-- raise apllication error (error definido para oracle)
-- hay numeros predefinidos para asignarle errores creados
-- no es tan util como gatillar con raise para evitar proceso con mensaje de error
-- siempre debe decir terminado satisfactoriamente, no como ahora
declare
    v_jefe number := 55;
begin
    delete from employees where employee_id = v_jefe;
    if sql%notfound then 
        raise_application_error(-20000,'no elimino el jefe ' || v_jefe);
    end if;
    DBMS_OUTPUT.PUT_LINE('elimino el jefe');
 end;
 
-- fin manejo de excepciones

-----------------
/*
condiciones para hacer la prueba 
- se debe redondear todo a enteros  
- funciones parametricas para informacion (BIND)
- por cada profesional procesado se almacena en detalle_asignacion_mes
- en resumen_mes_profesion va resumen de profesiones de datos obtenidos en proceso
- informacion de errores que se deben controlar en el proceso se almacena en tabla errores_p
- error_id es = a seq_errores
- BIND para  fechas y valor limite 410.000 de asignacion de pago 
- variableRAY para: valores de 5 porcentajes de traslado y monto mov fijo
- record para almacenar informacion. min dos registros
- estructura for loop y while loop para cursores
- valores redondeados
- dos cursores simultaneos para informacion detallada y resumida
- excepcion definida por usuario para capturar monto total de asignaciones
- (que no supere los 410.000), se debe interceptar error y guardar en tabla
- de errores y reemplazar monto calculado de comision por monto limite (410.000)
- excepciones predefinidas para controlar cualquier error que se produzca de recuperar
- los % necesarios para calcular asignacion por evaluacion.
- tabla DETALLE_ASIGNACION info se debe almacenar ordenada en forma ascendente por
profesion, apellido paterno y nombre del profesional. 
En tabla resumen ascendente por profesion
PARA LA PRUEBA. EJECUTAR PROCESO CONSIDERANDO ASESORIAS DEL MES DE JUNIO DE 2021.
*/

-- obtener numero y monto total de las asesorias de todos los profesionales
-- en mes de proceso, se debe poder cambiar mes y año (bind)
DROP SEQUENCE SEQ_ID;
CREATE SEQUENCE SEQ_ID;
TRUNCATE TABLE DETALLE_ASIGNACION_MES; 
TRUNCATE TABLE RESUMEN_MES_PROFESION;
TRUNCATE TABLE ERRORES_P;

variableIABLE b_mes_proceso number;
execute :b_mes_proceso :=6; 
variableIABLE b_anno_proceso number;
execute :b_anno_proceso :=2021; 

DECLARE
    TYPE asesoria_type IS RECORD(
    mes number,
    anno number,
    run number,
    nombre variablechar2(80),
    profesion variablechar2(50),
    nro_ases number,
    honorarios number, 
    asig_mov number,
    asig_eval number,
    asig_tipocont number,
    asig_profesion number,
    total_asignaciones_profesional number);
    
    rec_asesoria asesoria_type;
  
  CURSOR cur_asignaciones (p_run number) is
  select prof.numrun_prof,
  co.codemp_comuna,
  sum(ases.honorario)
  from profesional prof
  join comuna co on (co.cod_comuna=prof.cod_comuna)
  join asesoria ases on (ases.numrun_prof=prof.numrun_prof)
  where numrun_prof = p_run 
  group by prof.numrun_prof,
  co.codemp_comuna;
  
  CURSOR cur_asesoria is (select
     EXTRACT(MONTH FROM ases.inicio_asesoria) as mes_proceso,
     EXTRACT(YEAR FROM ases.inicio_asesoria) as anno_proceso,
     ases.numrun_prof as numrun_prof,
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno as nombre_profesional, 
     prosion.nombre_profesion as profesion,
     count(ases.numrun_prof)
    -- ases.honorario as honorarios
 
     from asesoria ases
     INNER JOIN profesional prof
     on (ases.numrun_prof=prof.numrun_prof)
     INNER JOIN PROFESION prosion ON (prosion.cod_profesion=prof.cod_profesion)
     WHERE extract(month from inicio_asesoria)=:b_mes_proceso
     AND extract(YEAR FROM inicio_asesoria)=:b_anno_proceso
   group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria), 
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     ases.numrun_prof, prof.nombre||' '||prof.appaterno||' '||prof.apmaterno,
     prosion.nombre_profesion)
    order by ases.numrun_prof;
 
 BEGIN

open cur_asesoria;
loop
 fetch cur_asesoria into rec_asesoria.mes, rec_asesoria.anno,rec_asesoria.run 
 ,rec_asesoria.nombre,rec_asesoria.profesion,rec_asesoria.nro_ases;
 exit when cur_asesoria%notfound;
 
 DBMS_OUTPUT.PUT_LINE('mes '||rec_asesoria.mes||' año '||rec_asesoria.anno||
 ' run '||rec_asesoria.run||' nombre '||rec_asesoria.nombre||' profesion '||
 rec_asesoria.profesion||' n° asesorias '||rec_asesoria.nro_ases);
end loop;
close cur_asesoria;
end;
/

declare

 v_exe exception;
 
 CURSOR cur_asignaciones is
  (select prof.numrun_prof as run,
  co.codemp_comuna as codemp,
  sum(ases.honorario) as suma
  from profesional prof
  join comuna co on (co.cod_comuna=prof.cod_comuna)
  join asesoria ases on (ases.numrun_prof=prof.numrun_prof)
  where EXTRACT(MONTH FROM INICIO_ASESORIA)=6
  AND EXTRACT (YEAR FROM INICIO_ASESORIA)=2021
  group by prof.numrun_prof,
  co.codemp_comuna);

    reg_asignaciones cur_asignaciones %rowtype;
begin
    open cur_asignaciones;
    loop
    FETCH cur_asignaciones INTO reg_asignaciones;
    exit when cur_asignaciones%notfound;

    IF reg_asignaciones.suma > 410000 THEN 
    raise v_exe; 
    
    end if;
    

end loop;

close cur_asignaciones;

end;




 Declare
  
	V_numero number;
	V_exe exception;  -- declarando variableiable de tipo excepción
Begin

	V_numero := &ingrese_numero; -- con el & le pediomos al usuario ingresar un numero
If v_numero > 10 then
		Dbms_output.put_line('el numero es mayor a 10');
Else
	Raise v_exe; -- si numero es menor a 10 ocurre excepción
End if;
When v_exe then
	Dbms_output.put_line('el numero no es mayor a 10');
  when others then -- captura cualquier excepcion que no coincida con las anteriores
  DBMS_OUTPUT.put_line('error final');

End; 
/*
select numrun_prof,
count(honorario),
TO_CHAR(SUM(HONORARIO),'9G999G999')
from asesoria 
where EXTRACT(MONTH FROM INICIO_ASESORIA)=6
AND EXTRACT (YEAR FROM INICIO_ASESORIA)=2021
group by numrun_prof;
*/

-- PRIMER CURSOR FUNCIONAL HASTA EL MOMENTO 

DROP SEQUENCE SEQ_ID;
CREATE SEQUENCE SEQ_ID;
TRUNCATE TABLE DETALLE_ASIGNACION_MES; 
TRUNCATE TABLE RESUMEN_MES_PROFESION;
TRUNCATE TABLE ERRORES_P;

variableIABLE b_mes_proceso number;
execute :b_mes_proceso :=6; 
variableIABLE b_anno_proceso number;
execute :b_anno_proceso :=2021; 

DECLARE
    TYPE asesoria_type IS RECORD(
    mes number,
    anno number,
    run number,
    nombre variablechar2(80),
    profesion variablechar2(50),
    nro_ases number);
    
    rec_asesoria asesoria_type;
/*  
  CURSOR cur_asignaciones (p_run number) is
  select prof.numrun_prof,
  co.codemp_comuna,
  sum(ases.honorario)
  from profesional prof
  join comuna co on (co.cod_comuna=prof.cod_comuna)
  join asesoria ases on (ases.numrun_prof=prof.numrun_prof)
  where numrun_prof = p_run 
  group by prof.numrun_prof,
  co.codemp_comuna;
  */
  CURSOR cur_asesoria is (select
     EXTRACT(MONTH FROM ases.inicio_asesoria) as mes_proceso,
     EXTRACT(YEAR FROM ases.inicio_asesoria) as anno_proceso,
     ases.numrun_prof as numrun_prof,
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno as nombre_profesional, 
     prosion.nombre_profesion as profesion,
     count(ases.numrun_prof)
     
     from asesoria ases
     INNER JOIN profesional prof
     on (ases.numrun_prof=prof.numrun_prof)
     INNER JOIN PROFESION prosion ON (prosion.cod_profesion=prof.cod_profesion)
     WHERE extract(month from inicio_asesoria)=:b_mes_proceso
     AND extract(YEAR FROM inicio_asesoria)=:b_anno_proceso
   group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria), 
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     ases.numrun_prof, prof.nombre||' '||prof.appaterno||' '||prof.apmaterno,
     prosion.nombre_profesion)
    order by ases.numrun_prof;
 BEGIN
    open cur_asesoria;
    loop
     fetch cur_asesoria into rec_asesoria.mes, rec_asesoria.anno,rec_asesoria.run 
     ,rec_asesoria.nombre,rec_asesoria.profesion,rec_asesoria.nro_ases;
     exit when cur_asesoria%notfound;
 
 DBMS_OUTPUT.PUT_LINE('mes '||rec_asesoria.mes||' año '||rec_asesoria.anno||
 ' run '||rec_asesoria.run||' nombre '||rec_asesoria.nombre||' profesion '||
 rec_asesoria.profesion||' n° asesorias '||rec_asesoria.nro_ases);
end loop;
close cur_asesoria;
end;
/

 /*
 en trigger, 
 El INSERT  solo tiene el new
 UPDATE NEW Y OLD 
 DELETE SOLO TIENE OLD
 for each row permite que trigger sea a nivel de fila
 existen trigger de tabla y de fila, el de fila es con for each row



 */

 /*
 PROCEDIMIENTOS ALMACENADOS
 Identificar caracteristicas y beneficios de subprogramas sql
 caracteristicas procedimiento almacenado
 como crear procedimientos almacenados simples y con parametros en la base de datos
 identificar las diferencias entre parametros formales y actuales.
 como usar los diferentes modos de parametros.
 como incocar un procedimiento almacenado
 como se manejan las excepciones en los procedimientos almacenado
 como eliminar un procedimiento almacenado
 como obtener informacion de los procedimientos almacenados desde el diccionario
 de datos.

 */

 /*
 conceptos generales subprogramas pl/sql
 se pueden declarar y definir un subprograma dentro de 
 cualquier bloque pl/sql o de otro subprograma

 para declarar un subprograma, debe tener una especificacion, que
 incluye descripciones de los parametros, y un cuerpo

 procedimientos procesan informacion pero no devuelven datos,
 las funciones siempre deben devolver un dato, como un metodo en java.

 procedimiento almacenado es como void al que se le pueden pasar parametros 
 y pedir datos de salida pero intrinsecamente es para realizar proceso y devolver
 resultado. (calculos)

create or replace subprograma

is|as 
[declaracion variables locales]
begin
exception

end;

el procedimiento hace lo que se le pide y nada mas

ventajas subprogramas pl/sql (procedimientos almacenados y funciones)
facil mantencion
mejora de la seguridad e integridad de los datos
mejora la claridad del codigo
mejora el rendimiento
 
un subprograma depende directamente de todos los objetos que utilice
se debe tener primero bien hecha la estructura de las tablas antes de hacer procedimientos
si se modifica un subprograma puede invalidar todos los objetos que dependan de el
(directa o indirectamente) y podran necesitar ser recompilados

para que un usuario pueda ejecutar un subprograma del que no es dueño
se le debe otorgar permiso de ejecucion sobre ese objeto
(grant execute nombre_subprograma to usuario)

para que un usuario pueda ejecutar un subprograma que ejecuta a otro, debe
tener los permisos para acceder a todos los objetos
que se hacen referencia en el subprograma
(grant select on nombre_objeto to usuario)


bloques anonimos:
sin nombre
compilados cada vez que se ejecutan
no se almacenan en base de datos
no pueden ser invocados por otras aplicaciones
no retornan valores
no pueden recibir parametros

SUBPROGRAMAS:
bloques con nombre
compilados cuando se crean o cuando se modifican
almacenados en base de datos
se pueden invocar por su nombre desde otras aplicaciones
subprogramas llamados funciones deben retornar valores
pueden recibir parámetros

- El parametro, al igual que los metodos, sirven para afinar el resultado
que se quiere obtener dentro del procedimiento o funcion

crear/editar procedimiento, advertencia o errores de compilacion, si se advierte,
sino se compila correctamente

si hay mensaje de error en procedimiento se debe resolver

procedimiento se puede arreglar desde la pestaña procedimientos, se corrige y guarda,
al mismo tiempo se debe corregir en hoja de trabajo.

procedimientos pueden tener
parametros de entrada o salida o de entrada y salida
 
 */

-- procedimientos almacenados
create or replace procedure sp_listado_emp(p_iddepto number)
is 
    cursor cur_emp is
      select * from employees where department_id=p_iddepto;
begin
    for x in cur_emp
    loop
        DBMS_OUTPUT.PUT_LINE('nombre: '||x.first_name||' sueldo '||x.salary);
    end loop;
end;
--------------------------------
set serveroutput off;
execute sp_listado_emp(60);
----------------------------------------------------------------------
create or replace procedure sp_imp_emp(p_imp number)
is 
    cursor cur_emp is
      select * from employees ;
    v_imp number :=0;
begin
    for x in cur_emp
    loop
        v_imp:=(x.salary*(p_imp/100));
        DBMS_OUTPUT.PUT_LINE('nombre: '||x.first_name||' impuesto '||v_imp||' '||x.salary);
    end loop;
end;
execute sp_imp_emp(&ingrese_impuesto);

declare
    v_imp number;
begin
    v_imp:=&Ingrese_el_impuesto;
    sp_imp_emp(v_imp);
end;
-- definicion de parametros; por defecto es de entrada
-- in --> solo entrada (por defecto)
-- out --> solo salida de datos
-- IN OUT --> permiten la entrada y salida de datos 
create or replace procedure sp_parametros1(p_id in number)
is
    cursor cur_emp is
    select * from employees where department_id=p_id;
    v_suma_sueldos number :=0;
begin
    for x in cur_emp
    loop
        v_suma_sueldos:=v_suma_sueldos+x.salary;
         
    end loop;
 --  dbms_output.put_line('total sueldos: ' || v_suma_sueldos);
end;
---------------------------------------
-- creacion procedimiento almacenado que retorna datos (suma y devuelve sueldo)
-- no es naturaleza retornar pero se puede hacer
create or replace procedure sp_suma_depto(p_id number, p_suma out number)
is
    cursor cur_emp is select * from employees where department_id=p_id;
    v_suma number:=0;
begin
    for x in cur_emp
    loop
        v_suma:=v_suma+x.salary;
    end loop;
    p_suma:= v_suma;
end;
-- para ejecutarlo necesito otro proc. o bloque anonimo por parametro out 
-- para recuperar valor de esa variable de salida
declare
    v_suma_depto number;
    v_depto number:= 60;
begin
-- forma 1 de pasar parametros a procedimiento
    sp_suma_depto(v_depto,v_suma_depto);
    dbms_output.put_line('la suma total es:'|| v_suma_depto);
  v_depto:=90;
    -- asignar valores para parametro id y suma bajo el nombre de parametro
    -- pd_id se almacena en v_depto y p_suma en v_suma_depto
    -- forma 2 de pasar parametros a procedimiento
     sp_suma_depto(p_id=> v_depto, p_suma => v_suma_depto);
    dbms_output.put_line('la suma total es:'|| v_suma_depto);
end;
-- un parametro es in out cuando parte con un valor y sale con otro

/*
arriba p_suma es de salida, cuando se ocupa una var de salida,
cuando el procedimiento requiera devolver algun estado o accion,
aquellos que siempre deben devolver datos son las funciones,
procedimientos procesan info sin indicar si lo hicieron o no,
la var de salida es opcional. 
en este caso recibe dos datos, 1 par de entrada (p_id)
segundo parametro p_suma es de salida, esa var se carga con el 
valor resultante del proceso realizado.
 el cursor selecciona todos los empleados cuyo departamento sea igual
 al parametro de entrada definido (60)
 variable suma con 0 ,
 cursor con x de for lo que hace la maquina es ir sumando,
 el 0 de suma se va sumando mas los salarios que van entrando.
 cuando termine end loop en parametro de salida se guarda resultado
 de sumatoria, cuando se compilo no hubo ningun error.
 para poder ejecutarlo se uso un bloque anonimo, lo que hace es
 crear una var suma_depto donde se rescata lo que devuelve el parametro suma,
 y var depto se adjudica num 60.
 sp_suma_depto se le pasa departamento 60 y variable de donde recoge el resultado
 de la suma  p_suma
*/
-------------------------------------------
-- procedimiento con parametro de entrada y salida
create or replace procedure sp_nuevo_sueldo(p_idemp number, p_sueldo in out number)
is
    v_reajuste number:=0;
    v_departamento number;
begin
    select department_id into v_departamento
    from employees where employee_id=p_idemp;
    if p_sueldo <5000 and v_departamento in (60,90,30) then
        v_reajuste:= p_sueldo*1.5;
        p_sueldo:= v_reajuste;
    else 
        p_sueldo:=0;
    end if;
end;
-- para ejecutar
declare
    v_reajuste number;
    v_sueldo number:=3000;
begin
    sp_nuevo_sueldo(107,v_sueldo);
    dbms_output.put_line('El nuevo sueldo es: ' || v_sueldo);
end;
select * from employees where department_id=60;


--  para eliminar procedimiento (drop procedure nombre_procedimiento;)

-- FUNCIONES ALMACENADAS

/*
describir funciones almacenadas
identificar diferencias con procedimientos
es un tipo de subprograma que siempre retorna
un valor.
puede aceptar parametros y estructuralmente es similar 
a un procedimiento

puede ser compilada y almacenada en la base de datos
debe tener una clausula return en el encabezado y a lo
menos una sentencia return en la seccion ejecutable.
se puede invocar con su nombre desde un procedimiento o bloque

PROCEDIMIENTOS 
Ejecutado como sentencia pl/sql
No contiene la clausula RETURN en el encabezado
Puede retornar un valor usando parametros de salida
Puede contener una sentencia RETURN sin un valor
Ejecutado como sentencia pl/sql

FUNCIONES
Invocadas como parte de una expresión
Debe contener una cláusula RETURN en el encabezado
Debe retornar un valor simple
Debe contener a lo menos una sentencia RETURN
Invocadas como parte de una expresión

CREACION DE FUNCION ALMACENADA

Crear/editar funcion
advertencias y errores si hay errores
si hay errores se ven (errores logicos no detecta)
si no se invoca la funcion

Se ven errores en sql developer
usar comando show errores en sql plus
se pueden usar vistas USER/ALL/DBA_ERRORS
(por lo general se ve en ventana los errores)
---------------------------------------------------------------
la sentencia create function permite crear una nueva funcion 
en la base de datos
Opcionalmente se puede usar la clausula replace

Se pueden declarar parametros, se debe indicar el tipo
de dato a retornar y se debe definir las acciones a ser
realizadas a través de un bloque pl/sql estándar

El bloque pl/sql en la funcion comienza con BEGIN, puede estar
precedida por la declaración de variables locales, y termina con end

Se debe declarar una sentencia RETURN para retornar un valor
con un tipo de dato que sea consistente conm la declaracion de la función

create or replace function nombre_funcion
return TIPO DATO IS|AS
BEGIN
-- sentencia ejecutables
RETURN expresión
[EXCEPTION]
-- sentencia excepcion
[RETURN expresión]
END;
*/
 
 -- creacion de funciones
 ------------------------
-- estructura básica de una función
create or replace 
function fn_bono(p_sueldo number) return number
is
 -- declaracion de variables
 v_porc_bono number := 0.6;
 v_nuevo_sueldo number:=0;
begin
    v_nuevo_sueldo:=(p_sueldo+(p_sueldo*v_porc_bono));
    return v_nuevo_sueldo;
exception
    when others then
        return 0;
end;
-- para ejecutar con procedimiento almacenado o bloque anonimo
declare
    v_salario number:=0;
    v_nuevo number:=0;
begin
    select salary into v_salario from employees
    where employee_id=100;
    v_nuevo:= fn_bono(v_salario);
    dbms_output.put_line('Sueldo es: '|| v_nuevo);
end;

/*
COMO USAR FUNCIONES predefinidas por usuario en sentencias sql
Pueden ser referenciadas en cualquier sentencia sql

- actuan en forma similar a las funciones predefinidas de una fila de sql
- pueden ser usadas en la clausula select, where, having, order by,
group by, values y set
- permite efectuar calculos y operaciones complejas que no se pueden hacer a traves 
de una sentencia simple de sql
- incrementa la eficiencia de las queries cuando son utilizadas en la clausula where para 
filtrar datos
*/
-- para ejecutar en select
select first_name,last_name,salary,fn_bono(salary)-- se pasa parametro de funcion
as nuevo_sueldo from employees;

-- restricciones de funciones definidas por el usuario
/*
- no se puede usar para especificar un valor por defecto de una columna
- cuando son invocadas desde una sentencia select sobre una tabla t no pueden
contener sentencias dml (update o insert o delete) sobre la misma tabla t
porque si dentro de la funcion estoy modificando los registro de la tabla no puedo
llamarla desde un select
- No pueden ser invocadas desde clausula de check (condicionante)
constraint o desde una sentencia create table o alter table
- Las funciones invocadas desde sentencias update o delete sobre una tabla 
t no pueden tener una sentencia select o contener dml sobre la misma tabla t
(si dentro de instruccion hay funciones select empleadas con update o delete no se permite)
*/

-- para eliminar funcion drop function nombre_funcion;
select * from user_objects where object_type='FUNCTION';
DROP FUNCTION nombre_funcion;
drop procedure sp_ejemplo;
-- FUNCION DE EJEMPLO DE UNA GUIA para retornar nombre
CREATE OR REPLACE FUNCTION FN_NOMBRE_COMPLETO(ID_EMP NUMBER) RETURN VARCHAR2
IS
    V_NOMBRE VARCHAR2(100);
BEGIN
    SELECT PNOMBRE||' '||SNOMBRE||' '||AP_PATERNO||' '||AP_MATERNO INTO V_NOMBRE
    FROM empleados WHERE ID_EMPLEADO=ID_EMP;
    RETURN '--'; -- si no encuentra nada retorna --
END;
-- PARA LLAMAR A LA FUNCION
FN_NOMBRE_COMPLETO(ID_EMPLEADO); --se llama a fn y se le pasa el parametro id






------------------------------------------------------------------------------
-- PAQUETES O PACKAGE



-- PACKAGES O PAQUETES




-- packege sirve para organizar procedimientos almacenados y funciones
/*
describir que es un package
como crearlo para agrupar variables relacionadas
como crear package con constructores publicos y privados
como invocar un constructor del package
describir el uso de un paquete sin cuerpo
describir las ventajas del uso de package
como obtener informacion desde el diccionario de datos de los
package creados en la base de datos

Conceptos generales
grupo o de diferentes componente4s pl/sql tambien 
llamados constructores, relacionados logicamente
haciendo una unidad

consta de dos partes
(especificacion y cuerpo)
las que se almacenan por separado en el diccionario de dato

permite al servidor oracle leer multiples objet os en memoria
a la vez

los constructores de un package pueden ser tipos pl sql var estructuras exepciones
procedimientos y funciones

el contenido puede ser compartido con muchas aplicaciones

especificacion del package
- es la que puede ser usada por las aplicaciones. aqui se declaran
los tipos, variables, constantes, cursores y subprogramas para uso publico.
- tamnien puede incluir pragmas que son directivas para el compilador

Cuerpo de package
- Contiene informacion de sus propios subprogramas y la implementacion completa
de los subprogramas declarados en la parte de especificacion
- tambien se definen constructores pl sql como son tipos de variables, constantes,
excepciones y cursores
- si la especificacion del package no contiene declaracion de subprogramas entonces
no se requiere un cuerpo para el package.

ESPECIFICACION DEL PACKAGE:
VARIABLE                        --> ESTA SECCION ES PUBLICA
DECLARACION PROCEDIMIENTO A;

CUERPO DEL PACKAGE:
DEFINICION PROCEDIMIENTO 3...
VARIABLE                        --> ESTA SECCION ES PRIVADA
BEGIN
...
END;


VISIBILIDAD DE LOS COMPONENTES DE UN PACKAGE

Los componentes locales son visibles dentro de la estructura en la 
cual ellos son declarados

la visibilidad de un componente (constructor) significa si este
puede ser referenciado y usado por otros
componentes y objetos

los componentes declarados globalmente son visibles interna o externamente
al package

un subprograma privado puede ser invocado solo desde subprogramas publicos
u otro constructor privado del package

la visibilidad de un componente o constructor depende si ellos son declarados
en forma local (privado) o global (público)
*/

---------------------------------------
-- para organizar las funciones podemos crear un packete

-- crear un packete para organizar las funciones y procedimientos almacenados
-- 1) crear la cabecera
-- todo lo que este en la cabecera sera publico
create or replace package pkg_prueba2
is
    -- se copia todo antes del is para implementar
     procedure sp_nuevo_sueldo(p_idemp number, p_sueldo in out number);
     procedure sp_suma_depto(p_id number, p_suma out number);
     function fn_bono(p_sueldo number) return number;
end;
-- 2) Crear el cuerpo del paquete
-- involucra copiar todo el codigo de funciones y procedimientos
create or replace package body pkg_prueba2
is
procedure sp_nuevo_sueldo(p_idemp number, p_sueldo in out number)
is
    v_reajuste number:=0;
    v_departamento number;
begin
    select department_id into v_departamento
    from employees where employee_id=p_idemp;
    if p_sueldo <5000 and v_departamento in (60,90,30) then
        v_reajuste:= p_sueldo*1.5;
        p_sueldo:= v_reajuste;
    else 
        p_sueldo:=0;
    end if;
end;
procedure sp_suma_depto(p_id number, p_suma out number)
is
    cursor cur_emp is select * from employees where department_id=p_id;
    v_suma number:=0;
begin
    for x in cur_emp
    loop
        v_suma:=v_suma+x.salary;
    end loop;
    p_suma:= v_suma;
end;

function fn_bono(p_sueldo number) return number
is
 -- declaracion de variables
 v_porc_bono number := 0.6;
 v_nuevo_sueldo number:=0;
begin
    v_nuevo_sueldo:=(p_sueldo+(p_sueldo*v_porc_bono));
    return v_nuevo_sueldo;
exception
    when others then
        return 0;
end;
end;
-----------------------------------------------------
-- ejecutar desde un paquete
execute pkg_prueba2.fn_bono(3000);

-- ejecutando dentro del bloque funcion que esta dentro de package
declare
    v_salario number:=0;
    v_nuevo number:=0;
begin
    select salary into v_salario from employees
    where employee_id=100;
    v_nuevo:= pkg_prueba2.fn_bono(v_salario);
    dbms_output.put_line('Sueldo es: '|| v_nuevo);
end;








-- PROCEDIMIENTOS ALMACENADOS









-- procedimientos almacenados
create or replace procedure sp_listado_emp(p_iddepto number) -- el parametro es opcional para afinar resultado
is
    cursor cur_emp is
        select * from employees 
    where department_id = p_iddepto;

begin   
    for x in cur_emp 
    loop
        dbms_output.put_line('Nombre: ' || x.first_name|| ' Sueldo '||x.salary);
    end loop;

end;
--------------------------------------------------------------------
exec sp_listado_emp(60); -- ejecutando procedimiento
----------------------------------------------------------------------

 create or replace procedure sp_imp_emp(p_imp number) -- el parametro es opcional para afinar resultado
is
    cursor cur_emp is
        select * from employees;
    v_imp number := 0;
begin   
    for x in cur_emp 
    loop
    v_imp := (x.salary*(p_imp/100));
        dbms_output.put_line('Nombre: ' || x.first_name|| ' Sueldo '||x.salary||' Imp. '||v_imp);
    end loop;
end;

exec sp_imp_emp(10); -- ejecuta procedimiento indicando valor de parametro % imp_empleado
exec sp_imp_emp(&ingrese_imp); -- pregunta por numero de parametro al momento de ejecutar proceso
------------------------------------------------------------------------------------
-- se pueden ejecutar procesos almacenados con exec o dentro de bloque anonimo
-- mayoritariamente se usan bloques o procesos asociadosa programas en algun lenguaje
declare
    v_imp number;
begin
    v_imp:=&Ingrese_El_Impuesto;
    sp_imp_emp(v_imp);
end;
-- definicion de parametros:
-- IN --> solo entrada (por defecto)
-- out --> solo salida de datos
-- IN OUT --> permiten entrada y salida de datos
create or replace procedure sp_parametros1(p_id in number)
is
    cursor cur_emp is
        select * from employees where department_id =p_id;
    v_suma_sueldos number:= 0;
begin
    for x in cur_emp
    loop
        v_suma_sueldos:=v_suma_sueldos+x.salary;
    end loop;
    dbms_output.put_line('Total sueldos ' || v_suma_sueldos);
end;
-----------------------------------------------------------------------
-- creacion de procedimiento almacenado que retorna datos
create or replace procedure sp_suma_depto(p_id number, p_suma out number)
is
    cursor cur_emp is select * from employees where department_id=p_id;
    v_suma number := 0;
begin
    for x in cur_emp
    loop
        v_suma:= v_suma+x.salary;
    end loop;
    p_suma:= v_suma;
end;
-- para ejecutarlo necesito otro proc. o bloque anonimo, por el parametro de salida
-- se debe recuperar ese valor
declare
    v_suma_depto number;
    v_depto number := 60;
begin
    sp_suma_depto(v_depto,v_suma_depto); -- organizacion por orden de los parametros de proc.
    dbms_output.put_line('la suma total de salarios es: ' || v_suma_depto||' del departamento '|| v_depto );
    v_depto:= 90; -- cambio de id dep
    sp_suma_depto(p_id=> v_depto, p_suma=> v_suma_depto); -- organizacion por asignación;
    dbms_output.put_line('la suma total de salarios es: ' || v_suma_depto||' del departamento '|| v_depto );
end;
--------------------------------------------------------
create or replace procedure sp_nuevo_sueldo(p_idemp number, p_sueldo in out number)
is
    v_reajuste number:=0;
    v_departamento number;
begin
    select department_id into v_departamento
    from employees where employee_id = p_idemp;
    if p_sueldo<5000 and v_departamento in (60,90,30) then
        v_reajuste:= p_sueldo*1.5;
        p_sueldo:=v_reajuste;
    else
        p_sueldo:= 0;
    end if;
    end;
-- para ejecutar
declare
    v_sueldo number := 8000;
    v_id number := 107;
begin
    sp_nuevo_sueldo(v_id,v_sueldo); -- parametros out se pasan por variable
    dbms_output.put_line('El nuevo sueldo es:' ||v_sueldo);
--    update employees set salary=v_sueldo where employee_id=v_id; para actualizar campo salario 
end;


 










-- FUNCIONES ALMACENADAS

/*
Igual que procedimiento con diferencia en cabecera, donde siempre
se debe asignar un valor que se retornara.

va con cabecera, is y luego seccion de variables, begin cuerpo y end 
para terminar con el proceso.

Puede ser compilada y almacenada en BD
Debe tener clausula return en encabezado y al menos un return en cuerpo
cuando se tenga listo resultado para devolver.

Puede ser invocado, usando su nombrem desde una aplicacion, a traves de
bloque pl/plsql.

Procedimientos
-  Ejecutado como sentencia pl/sql
- No contiene clausula return en el encabezado
- Puede retornar un valor usando parametros de salir
- Puede contener una sentencia Return sin un valor
- Ejecutado como sentencia pl/sql

Funciones 
- Invocadas como parte de una expresion (bloque anonimo)
- Debe contener una clausula Return en el encabezado
- Debe retornar un valor siempre
- Debe contener a lo menos una sentencia Return como valor de salida
- Invocada como parte de una expresión (bloque pl/sql)

Compilador entrega ventana donde se muestran los errores


*/



/*
Sentencias:

CREATE FUNCTION:
    permite crear una nueva funcion de la bd.
    Opcionalmente se puede usar la clausula replace

Se pueden declarar parametros, se debe indicar el tipo de dato a retornar
y se debe definir las acciones a a ser realizadas a traves de un bloque 
pl/sql estandar

El bloque pl/sql en la Funcion comienza con BEGIN, puede estar precedida por
la declaración de variables locales, y termina con END

Se debe declarar una sentencia RETURN para retornar un valor
con un tipo de dato que se consistente con la declaracion de 
la función.

*/
-- TRABAJANDO CON USUARIO HR
-- creacion de funciones
-----------------------------------------
-- estructura basica de una funcion
create or replace function fn_bono(p_sueldo number) return number -- colocar tipo de dato a retornar
is
-- seccion declarativa
    v_porc_bono number:=0.6;
    v_nuevo_sueldo number :=0;
begin
    v_nuevo_sueldo:=(p_sueldo+ (p_sueldo*v_porc_bono));
    return v_nuevo_sueldo;
exception
    when others then
        return 0;
end;
-- para ejecutar funcion (a travez de proc o bloque)
declare
    v_salario number:=0;
    v_nuevo number:=0;
begin
    select salary into v_salario from employees
    where employee_id=100;
    v_nuevo:=fn_bono(v_salario); -- v_salaraio pasa a ser el parametro
    dbms_output.put_line('Sueldo es: ' ||v_salario||' con aumento '||v_nuevo);
end;

/*
uso de funciones
- Pueden ser referenciadas en cualquier sentencia sql 
- Pueden ser usadas en la clausula select, where, having, order by, group by, values y set
- Actuan en forma similar a las funciones predefinidas de una fila se sql
- Permite efectuar calculos y operaciones complejas que no se pueden realizar a traves
de una sentencia
- Incrementa la eficacia de las queries cuando son utilizadas en  la clausula WHERE para
filtrar datos
*/


/*
no se puede utilizar funciones DML desde un select con una funcion, porque
estaria recuperando datos y a la vez modificarlos, solo puede hacer una cosa a la vez


*/

-- ejemplo de funcion para retornar nombre completo

create or replace function FN_NOMBRE_COMPLETO(ID_EMP number) return VARCHAR2
is 
    v_nombre VARCHAR2(100);
begin
  select pnombre ||' '|| snombre||' '||ap_paterno||' '||ap_materno into v_nombre
   from empleados where ID_EMPLEADO=ID_EMP;
   return v_nombre
    exception
      when no_data_found then
        RETURN '--';
end;

-- para utilizar en SELECT
FN_NOMBRE_COMPLETO(ID_EMPLEADO)

-- ejemplo de funcion con dos parametros para sacar porc de afp
create or replace function fn_afp(P_PORC NUMBER, P_SUELDO NUMBER) RETURN NUMBER
IS 
    V_PORCENTAJE NUMBER:=0;
begin
  V_PORCENTAJE:=P_SUELDO*(P_PORC/100); -- DEVUELVE VALOR DE PORC PARA AFP EN PESOS
  RETURN V_PORCENTAJE;
exception
  when others then
    RETURN 0;
end;

-- USANDO FUNCION DE DOS PARAMETROS EN SELECT
fb_afp(AFP.PORC_AFP,E.SUELDO) AS AFP -- Se pasa porc afp y sueldo para retornar pesos afp
--------------------------------------------------------------------------------
-- ejemplo de funcion para sacar bono por pertenecer a algunas comunas
create or replace function fn_bono_comuna(p_comuna varchar2) return number
is 
    v_bono number:=0;
begin
 if p_comuna in('Renca','Puente Alto','Conchali','Independencia') then
    v_bono := 10000;
    else
    v_bono := 0;
    end if;
    return v_bono;
end;

-- usando funcion comuna
select fn_bono_comuna(comu.nomb_comuna) as bono_comuna from comuna comu;

------------------------------------------------------------------------------------
-- creando funcion para sacar bono por vacaciones
create or replace function fn_bono_vacaciones(P_DIAS number) return number
is 
    v_error varchar2(255);
    v_bono_vaca number :=0;
begin
  select valor_bono into v_bono_vaca from bono_vacaciones
  where P_DIAS BETWEEN dia_min and dia_max;
  RETURN v_bono_vaca; -- se puede retornar una variable
exception
  when others then
     v_error:= sqlerrm;
     -- si existe tabla de errores podemos usar excepcion para insertar mensaje de error
     insert into error_procesos values (sq_error_proceso.nextval, 'Error en dias vaca fn',v_error )
    return 0; -- y se puede retornar valor sin estar relacionado a variable
end;
-- usando funcion para bono de vacaciones
select fn_bono_vacaciones(te.vacaciones) as bono_vaca from tipo_empleado te;
------------------------------------------------------------------------------------------





-- PAQUETES O PACKAGE
-- creando package para ordenar procedimientos y funciones
/*
Almacena elementos en base a un tipo
- Grupo o de diferentes componentes pl/sql, también llamados constructores,
relacionados logicamente haciendolos una unidad

- Consta de dos partes (Cabecera y Cuerpo) las que se almacenan por 
separado en el diccionario de datos

- Los constructores de un Package pueden ser tipos PL/SQL, variables,
estructuras de datos, excepciones, procedimientos y funciones

- Permite al servidor Oracle leer múltiples objetos en memoria a la vez

- El contenido puede ser compartido con muchas aplicaciones

ESPECIFICACION DEL PACKAGE (CABECERA, es publica):
- Es la que puede ser usada por las aplicaciones. Aqui se declaran los tipos,
variables, constantes, cursores y subprogramas para uso publico.
- Tambien puede incluir PRAGMAS que son directivas para el compilador 

CUERPO DEL PACKAGE (Privado):
-Contiene información de sus propios subprogramas y la implementacion completa de los
subprogramas declarados en la parte de especificación.

- También se definen constructores pl/SQL como son tipos de variables, constantes,
excepciones y cursores.

- Si la especificación del package no contiene declaración de subprogramas entonces no se
requiere un cuerpo para el package (si solo se crean definiciones de constantes variables
o tipos no requiere de cuerpo porque lo necesario esta declarado en la cabecera)


VISIBILIDAD DE LOS COMPONENTES DE UN PACKAGE

- La visibilidad de un componente (constructor) significa
si este puede ser referenciado y usado por otros componentes u objetos

- Los componentes locales son visibles dentro de la estructura en la cual ellos 
son declarados

- La visibilidad de un componentes o constructor depende si ellos son de clarados
en forma local (privado) o global (publico)

- Los componentes declarados globalmente son visibles interna o externamente al 
package

- Un subprograma privado puede ser invocado solo desde subprogramas publicos u otro
constructor privado del package


*/

create or replace procedure sp_proceso1(p_uf number) 
-- para organizar las funciones y procedimientos podemos crear un paquete
--1 crear la cabecera copiamos todo lo que esta "antes del IS"
create or replace package pkg_prueba2

is 
-- se elimina create o replace porque esto ya lo hace el package
   function fn_bono_vacaciones(P_DIAS number) return number; 
   function fn_bono_comuna(p_comuna varchar2) return number;
   function fn_afp(P_PORC NUMBER, P_SUELDO NUMBER) RETURN NUMBER;
   function FN_NOMBRE_COMPLETO(ID_EMP number) return VARCHAR2;
   function fn_bono(p_sueldo number) return number;
   procedure sp_nuevo_sueldo(p_idemp number, p_sueldo in out number);
end;
--2) crear el cuerpo del paquete (copiamos todo el codigo)
create or replace package body pkg_prueba2
is

function fn_bono_vacaciones(P_DIAS number) return number
is 
    v_error varchar2(255);
    v_bono_vaca number :=0;
begin
  select valor_bono into v_bono_vaca from bono_vacaciones
  where P_DIAS BETWEEN dia_min and dia_max;
  RETURN v_bono_vaca; -- se puede retornar una variable
exception
  when others then
     v_error:= sqlerrm;
     -- si existe tabla de errores podemos usar excepcion para insertar mensaje de error
     insert into error_procesos values (sq_error_proceso.nextval, 'Error en dias vaca fn',v_error )
    return 0; -- y se puede retornar valor sin estar relacionado a variable
end;

function fn_bono_comuna(p_comuna varchar2) return number
is 
    v_bono number:=0;
begin
 if p_comuna in('Renca','Puente Alto','Conchali','Independencia') then
    v_bono := 10000;
    else
    v_bono := 0;
    end if;
    return v_bono;
end;

function fn_afp(P_PORC NUMBER, P_SUELDO NUMBER) RETURN NUMBER
IS 
    V_PORCENTAJE NUMBER:=0;
begin
  V_PORCENTAJE:=P_SUELDO*(P_PORC/100); -- DEVUELVE VALOR DE PORC PARA AFP EN PESOS
  RETURN V_PORCENTAJE;
exception
  when others then
    RETURN 0;
end;

function FN_NOMBRE_COMPLETO(ID_EMP number) return VARCHAR2
is 
    v_nombre VARCHAR2(100);
begin
  select pnombre ||' '|| snombre||' '||ap_paterno||' '||ap_materno into v_nombre
   from empleados where ID_EMPLEADO=ID_EMP;
   return v_nombre
    exception
      when no_data_found then
        RETURN '--';
end;

function fn_bono(p_sueldo number) return number -- colocar tipo de dato a retornar
is
-- seccion declarativa
    v_porc_bono number:=0.6;
    v_nuevo_sueldo number :=0;
begin
    v_nuevo_sueldo:=(p_sueldo+ (p_sueldo*v_porc_bono));
    return v_nuevo_sueldo;
exception
    when others then
        return 0;
end;

procedure sp_nuevo_sueldo(p_idemp number, p_sueldo in out number)
is
    v_reajuste number:=0;
    v_departamento number;
begin
    select department_id into v_departamento
    from employees where employee_id = p_idemp;
    if p_sueldo<5000 and v_departamento in (60,90,30) then
        v_reajuste:= p_sueldo*1.5;
        p_sueldo:=v_reajuste;
    else
        p_sueldo:= 0;
    end if;
    end;
-- para ejecutar
declare
    v_sueldo number := 8000;
    v_id number := 107;
begin
    sp_nuevo_sueldo(v_id,v_sueldo); -- parametros out se pasan por variable
    dbms_output.put_line('El nuevo sueldo es:' ||v_sueldo);
--    update employees set salary=v_sueldo where employee_id=v_id; para actualizar campo salario 
    end;
end;

--  EJECUTAR DESDE UN PAQUETE PACKAGE
execute pkg_prueba2.sp_nuevo_sueldo();

------------------------------------------------------------------------------------










-- CREANDO TRIGGERS
/*
- Identificar las caracteristicas y el uso de un Trigger.
- Describir los eventos que pueden ser controlados a traves de un Trigger
- Tipos de Triggers asociados a sentencias DML
- Uso de predicadores condicionales en un Trigger
- Uso de las pseducomumnas OLD y NEW
- Cómo crear un Trigger a Nivel de Fila
- Como incorporar restricciones en Trigger a Nivel de Fila 
- Como crear un Trigger INSTEAD OF
- Como crear Trigger asociado a sentencias DDL y a eventos
- Como obtener información de los Procedimientos Almacenados desde el Diccionario de
datos


Conceptos generales Triggers de Base de Datos

- Un Trigger de Base de Datos es un bloque pl/sql o asociado a una tabla, vista, esquema 
o Base de Datos

- Se ejecutan implícitamente cuando ocurren los sitguientes eventos: DML sobre tablas,
DML sobre Vistas y DDL

- Se activan implícitamente por la base de datos en respuesta a un evento especifico, 
sin importar qué usuario está conectado o la aplicación que se está ejecutando

- Se pueden utilizar para: Integridad referencial, auditar cambios en los datos, 
seguridad, efectuar acciones cuando una tabla es modificada o auditar eventos en la base
de datos.

- Las acciones de un Trigger pueden considerar ejecutar un conjunto de sentencias SQL, 
pl/SQL y subprogramas

------------------------

Características de los Triggers
- Se almacena solo el codigo fuente del Trigger, por lo tanto se compila
cada vez que se activan

- Para definir un Trigger se deben especificar las condiciones bajo las 
cuales el trigger será ejecutado y las acciones que se realizarán cuando el 
Trigger se ejecute

- Un Trigger no admite parámetros y puede afectar a N filas

- Un nombre de Trigger debe ser único con respecto a otro Trigger del mismo
esquema

- Cuando un Trigger falla, el servidor Oracle realiza automáticamente un Rollback de 
las sentencias que conforman el cuerpo del Trigger
-----------------

Tipo de eventos que un Trigger puede controlar
- Sentencias DML: Una sentencia INSERT, UPDATE o DELETE en una tabla específica(o vista,
en algunos casos).

- Sentencias DDL: Sentencia CREATE, ALTER o DROP en cualquier objeto de esquema

- Operación de la Base de Datos: 
- El inicio o cierre de una instancia o base de datos (startup, shutdown).
- Un mensaje de error especiico o cualquier mensaje de error
- El inicio o cierre de sesion de usuario (logon, logoff).
*/
/*
- Creacion de Trigger asociado a Sentencias DML
  La sentencia CREATE TRIGGER permite crear un nuevo Trigger en la Base 
  de Datos, el cual consta de tres partes: Comando, Restricción y Acción.

- En el Comando se especifica la sentencia DML que activará al Trigger y la tabla
asociada. Se especifica tambien si el Trigger se activa ANTES o DESPUES de la sentencia

- En la Restricción se define la condición que tiene que verificar cada fila
de la tabla para que que se ejecute la acción del Trigger

- En la Acción se define la tarea específica que realiza el Trigger a través
de comandos y sentencias SQL y PL/SQL.

--------------------------
Tiempo de Ejecución de un Trigger DML
- Se puede especificar el tiempo de ejecución de las acciones del Trigger

- AFTER: ejecuta el cuerpo del Trigger después de que el evento DML que lo 
desencadena se ejecute sobre la tabla

- BEFORE: ejecuta el cuerpo del Trigger antes de que el evento DML que lo desencadena
se ejecute sobre la tabla

- INSTEAD OF: ejecuta el cuerpo del Trigger en lugar de la sentencia DML que se 
ejecuta sobre una vista (ni antes ni despues, solo sustituyendola)

- Si se definen multiples triggers sobre el objeto, entonces el orden en que
se activan los Triggers es arbitrario
*/

/*
---------------------------------
Tipos de Triggers DML
- El tipo de Trigger determina si el cuerpo del Trigger se ejecutara para cada fila
o solo una vez cuando se ejecute la sentencia DML en la tabla

# TRIGGER A NIVEL DE FILA: 
- Se ejecuta una vez por cada fila afectada por la sentencia SQL que activa la ejecucion
del trigger

- No se ejecuta si el evento que gatilla al trigger no afecta ninguna fila

- Esta indicado por la especificacion de la clausula FOR EACH ROW

- Usa un nombre de correlación para accesar al valor almacenado en la Base de Datos
o al nuevo valor de la fila que está siendo procesada por el trigger

# TRIGGER A NIVEL DE SENTENCIA
- Es el tipo de trigger por defecto
- Se ejecuta una vez antes o después de la sentencia SQL que gatilla el trigger
- Se gatilla una vez (no importa el número de filas que serán afectadas) Incluso si
ninguna fila es afectada
*/

-- creacion de triggers
create or replace trigger trg_nombre
before / after --> cuando se ejecutara BEFORE: antes / AFTER : despues
update or delete or insert --> acciones a monitorear
on tabla_a_monitorear
for each row --> se ejecuta el trigger para cada fila afectada
declare
    -- declaracion de variables
begin
     -- proceso
end;
---------------------------------------------

-- crearemos un duplicado de la tabla de empleados
create table empleados as select * from employees;
select * from empleados;
-- crearemos un trigger para monitorear las acciones sobre la tabla
create or replace trigger trg_uno
before 
update or delete or insert 
on empleados
for each row
declare
begin
    dbms_output.put_line('Realizo una accion sobre la tabla');
end;

-- probando trigger uno
delete from empleados where salary>20000;
select * from empleados where salary>20000;
rollback;
-- para diferenciar cada una de las acciones de un trigger
-- emplean predicados: 
--INSERTING, DELETING, UPDATING pregunta si se elimino o si se actualizo
create or replace trigger trg_uno
before
update or delete or insert 
on empleados
for each row
declare 
    -- cada variable predicado se carga con TRUE / FALSE
begin
    if inserting then
        dbms_output.put_line('inserto registro en tabla empleados');
    end if;
    if deleting then
        dbms_output.put_line('elimino reg. en tabla empleados');
    end if;
    if updating then 
        dbms_output.put_line('actualizo registro en tab empleados');
     end if;
end;
-- probar
delete from empleados where salary <3500;
update empleados set salary= salary + 500 where salary < 3500;

rollback;

-- podemos utilizar el registro que se afecto con el trigger 
-- :old --> toma el antiguo registro 
-- :new --> toma el nuevo registro
create or replace trigger trg_uno
before 
update or delete or insert
on empleados
for each row
declare

begin
    if inserting then -- inserting es new
        dbms_output.put_line('Inserto el empleado ' || :new.first_name ||' '||:new.LAST_NAME); -- quiero el nuevo registro
    end if;
    if deleting then -- deleting es old
        dbms_output.put_line('Elimino empleado '|| :old.first_name||' '||:old.last_name);
    end if;
    if updating then -- solo el updating tiene old y new
        dbms_output.put_line('Sueldo antiguo:' || :old.salary ||'y el nuevo es: ' || :new.salary);
    end if;
end;
-- ahora puedo ver datos de los registros que estan siendo modificados
-- probar
update empleados set salary=salary-500
where salary < 3000;

delete from empleados where salary =2500;
rollback;

insert into empleados values(90,'Carlos','Salinas','carlos.oibur',8520068,'2/5/98','SH_CLERK',30000,0.25,122,50);
rollback;
----------------------------------------------------
-- crear un trigger que evalua una condicion (WHEN 'CUANDO')

-- desactivar trigger
alter trigger trg_uno disable; -- se desactiva para no tener dos triggers asosiados a la misma tabla
-- activar trigger
alter trigger trg_uno enable;

-- TRIGGER 2
create or replace trigger trg_dos
before
delete or update
on empleados
for each row when (old.SALARY<3500) -- determina que filas cumplen con condicion para poder usarse el trigger
declare
begin
    if deleting then 
    dbms_output.put_line('elimino emp. N° ' || :old.EMPLOYEE_ID || 'sueldo: '|| :old.SALARY);
        end if;
    if updating then
        dbms_output.put_line('Actualizo reg. ' ||:old.EMPLOYEE_ID || ' sueldo antiguo' ||:old.SALARY|| ' por el nuevo ' || :new.SALARY);
    end if;
end;
-- probar
-- delete no entra en trigger porque salario esta por sobre el valor asignado en for each row
delete from empleados where salary > 3500 and salary < 6000;

rollback;
-- update si entra en trigger porque esta dentro de los valores asignados en for each row
update empleados set salary=salary+100 where salary < 3500;

alter trigger trg_dos disable;
--------------------------------------------------------------
-- creacion de un proceso con triggers de monitoreo
create table auditoria(
    id number primary key,
    proceso varchar2(50),
    fecha date 
);
create sequence sq_auditoria;
-- crear un trigger que almacene lo que esta realizando el usuario
create or replace trigger trg_auditoria
before 
delete or update or insert
on empleados
for each row
declare
begin
    if inserting then
        insert into auditoria values(sq_auditoria.nextval,'Inserto reg. ' || :new.employee_id, sysdate);
    end if;
    if deleting then
        insert into auditoria values(sq_auditoria.nextval,'Elimino reg. '|| :old.employee_id , sysdate);
    end if;
    if updating then
        insert into auditoria values(sq_auditoria.nextval,'Actualizo reg. '|| :old.employee_id , sysdate);
    end if;
end;
-- probar 
update empleados set salary=salary+200 where salary < 2500;
delete from empleados where salary > 15000;

rollback;
select * from auditoria;
----------------------------------------------------------------
-- ejemplo 2
create table bodega(
    id_producto number primary key,
    descripcion varchar2(80),
    cantidad number,
    precio number
);
insert into bodega values (1,'Platano',100,780);
insert into bodega values (2,'Sandia',80,3000);
insert into bodega values (3,'Pera',40,100);
select * from bodega;

create table ventas (
    id_venta number primary key,
    id_producto number not null,
    cantidad number
);
-- crear un trigger que permita modificar las cantidades 
-- de bodega a medida que se compran productos
create or replace trigger trg_bodega
after
insert or delete
on ventas
for each row
declare
begin
    if inserting then
    update bodega set cantidad=cantidad- :new.cantidad
    where id_producto= :new.id_producto;
    end if;
    if deleting then
    update bodega set cantidad=cantidad + :old.cantidad
    where id_producto= :old.id_producto;
    end if;
end;
-- podemos ingresar una venta
create sequence seq_venta;
truncate table ventas;
insert into ventas values (seq_venta.nextval,1,10);
insert into ventas values(seq_venta.nextval,2,20);
insert into ventas values(seq_venta.nextval,3,20);

select * from bodega;
select * from ventas;
delete from ventas where id_venta=3;





--------------------------------------------------------------
--------------------------------------------------------------
-- ultima materia: sql dinámico (3:47:36 clase 14)

--------------------------------------------------------------
-- SQL DINAMICO
-- permite la construccion en tiempo de ejecucion de un proc.
-- almacenado o funcion de un SQL que permita procesar datos
-- se puede crear procedimientos y funciones que alteren tablas
create or replace function fn_cantidad_emp(p_sueldo_min number, p_sueldo_max number)
return number
is
    v_cantidad number :=0;
    v_sql varchar2(255); -- variable sql donde escribiremos la consulta
begin
    v_sql:= 'select count(*) from empleados where salary between :smin and :smax'; -- dos puntos antes de nombre significa parametro 
    execute immediate v_sql into v_cantidad using p_sueldo_min, p_sueldo_max;
    return v_cantidad;
end;


-- probar sql dinamico
declare
    v_total number := 0;
begin
    v_total:=fn_cantidad_emp(2600,3500);
    dbms_output.put_line('Cant. Empleados entre 2600 y 3500 dólares: '|| v_total);
end;
--------------------------------------------------------------
-- SQL DINAMICO DE ACTUALIZACION
create or replace 
function fn_act_sueldo(p_sueldo number, p_reajuste number)
return number 
is
    v_sql varchar2(255);
begin
    v_sql:='update empleados set salary=salary+((salary *:p1)/100 ) where salary < :p2';
    execute immediate v_sql using p_reajuste,p_sueldo;
    return sql%rowcount; -- return es para sentencias sql, la ultimja fue update
end;
-- probar
declare
    v_cantidad number:=0;
begin
    v_cantidad:=fn_act_sueldo(3500,20);
    dbms_output.put_line('Cantidad Emp. reajustados ' || v_cantidad);
end;

--------------------------------------------------------------
-- examen

create or replace trigger trg_cupo
after 
insert or delete 
on TRANSACCION_TARJETA_CLIENTE
for each row
declare
begin
    if inserting then
        update tarjeta_cliente set cupo_compra=cupo_compra - :new.MONTO_TOTAL_TRANSACCION
        where NRO_TARJETA= :new.NRO_TARJETA;
    end if;
    if deleting then
        update tarjeta_cliente set cupo_compra=cupo_compra + :old.MONTO_TOTAL_TRANSACCION
        where NRO_TARJETA= :old.NRO_TARJETA;
    end if;
end;

insert into transaccion_tarjeta_cliente values (31021713767,1004,sysdate,20000,6,21000,102,1311);
delete from transaccion_tarjeta_cliente where nro_transaccion = 1004 and nro_tarjeta = 31021713767 ;

select * from transaccion_tarjeta_cliente where nro_tarjeta = 31021713767;

select * from tarjeta_cliente where nro_tarjeta = 31021713767;