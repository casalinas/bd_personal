tipos de datos sql

char: cadena de caracteres de longitud fija (rellena con 
espacios en blanco si se ponen menos caracteres),
por defecto es 1 byte

varchar2: cadena de caracteres de longitud variable, 
tamaño maximo de n bytes, obligatorio asignar un tamaño

number: numerico, no es obligatorio especificar tamaño

date: tipo fecha, desde -4712 hasta el 9999

long: para albergar caracteres de longitud variable,
hasta 2gb, se recomienda no usar

clob: alberga caracteres multi-byte o single-byte
se usa para textos grandes. (aun se usa)

nclob: igual que clob pero con caracteres unicode,
almacena cadenas de caracteres de tipo nacional de
distintos lenguajes

raw: datos binarios, mismos limites que varchar2

blob: objeto binario hasta 4gb

bfile: contiene punteros a ficheros externos de bd,
se guardan afuera de la bd

rowid: representa el id unico de una fila

timestamp: fecha que almacena fracciones de segundo,
hay variaciones como with timezone o with 
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
de varias tablas.

proyeccion, seleccionar algunas columnas

seleccion, seleccionar algunas filas.

SELECT DATOS FROM TABLA

-----------------------------------------------------

primeros pasos select.

es necesario poner ; al final de las sentencias para poder
ejecutarlas ordenadamente cuando existan varias en una hoja
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

IN: Esta funcion permite poner varias cualidades que queremos que se cumplan, por ejemplo empleados del departamento 50 y 60, el in se pone despues del where y la condicion va entre ()

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



---------------------------------------------------------------------------

FUNCIONES


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
     -- rowtype es que convierta la variable del tipo de toda la fila de la tabla asignada
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
	V_exe exception;  -- declarando variable de tipo excepción
Begin

	V_numero := &ingrese_numero; -- con el & le pediomos al usuario ingresar un numero
If v_numero > 10 then
		Dbms_output.put_line(‘el numero es mayor a 10’);
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
	V_exe exception;  -- declarando variable de tipo excepción
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
      end if;
    end; 

  Else
	Raise v_exe; -- si numero es menor a 10 ocurre excepción
  End if;

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
v_nombre varchar2(45);
v_apellido varchar2(45);
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

  execute sp_ejemplo; -- para cuando no tiene parametros

  execute sp_ejemplo(num1,num2); -- cuando tiene parametros forma 1
  execute sp_ejemplo(&ingrese_num1,&ingrese_num2); -- forma 2 de ejecucion con parametros

-------------------------------------------------------------
-- creando una funcion
create or replace
function fn_ejemplo(p_num1 number,p_num2 number)
return number -- se dice que tipo de dato retorna siempre
is
    -- declaracion de variables
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
    -- declaracion de variables
    v_total number;
begin
    v_total:=p_num1+p_num2;
    return v_total;
end;
end;
-- fin body 
-- ejecucion de procedimiento dentro de package
execute pkg_ejemplo.sp_ejemplo(14,50);


-- USO SE EXCEPCIONES para errores comunes 
----------------------------------------------------------------
declare
    v_codigo number;
    v_nombre varchar2(45);
    v_apellido varchar2(45);
    v_email varchar2(45);
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
-- usando variables en bloque pl/sql
VARIABLE numero number;
exec :numero := 115
declare 
v_apellido varchar2(45);
begin
    select last_name
    into v_apellido 
    from employees where employee_id=:numero;
    DBMS_OUTPUT.PUT_LINE('Apellido del empleado '||:numero||' es '||v_apellido );
end;
/
-- probando type y la inserción de datos de tablas en variables
declare
    v_nombre employees.first_name%type; -- type dice que variable nombre sera del mismo tipo que el campo first_name de la tabla employees
    v_apellido varchar2(45);
    v_id number;
begin
    select first_name, last_name, employee_id
    into v_nombre, v_apellido, v_id
    from employees where employee_id=100;
    DBMS_OUTPUT.PUT_LINE('Nombre del empleado numero '||v_id ||' es '|| v_nombre||' '||v_apellido);
end;
/
/*
Requisitos para nombrar variables
A. Debe comenzar con una letra
B. Puede incluid caracteres especiales
como :$,_ y #. (aún asi no recomendado)
C. Puede incluir letras y números
D. No debe contener palabras reservadas
E. Debe tener un largo máximo de 30 caracteres

La Sintaxis considera:
identificador: es el nombre de variable
constant: indica que valor de variable no puede modificarse, deben inicializarse
tipo dato: indica que la variable es del tipo escalar, compuesto o lob
not null: indica que variable debe contener siempre un valor, debe ser inicializada
expr: es cualquier expresion pl/sql que puede ser expresion literal, otra variable
o incluso una expresion que utiliza una función.

Consideraciones para Declarar e inicializar variables pl/sql
- usar las convenciones de nombres para variables
- usar nombres de variables significativos
- Inicializar variables con not null y constant
- inicializar variables con := o Default
- Declarar un identificador por linea
- Evitar usar nombre de columnas como identificadores
- Usar not null cuando la variable debe almacenar un valor

- Tipos de datos escalares: tienen un solo valor, depende del tipo de dato de var
- tipos de datos compuestos: recuperan varios datos 
- tipos de datos de referencia: tienen valores llamados punteros que apuntan a un lugar
de almacenamiento (ej cursor)

D. Tipos de datos lob: tienen valores llamados localizadores que especifican 
la ubicacion de los objetos grandes (como imagenes) que se almacenan fuera de la
tabla.

E. Variables Bind: No estan declaradas dentro del bloque, sino que fuera como
variables globales, estas pueden ser utilizadas por varios bloques
*/
-- DIA 2 TAV    
/*
La Sintaxis considera:
identificador: es el nombre de variable
constant: indica que valor de variable no puede modificarse, deben inicializarse
tipo dato: indica que la variable es del tipo escalar, compuesto o lob
not null: indica que variable debe contener siempre un valor, debe ser inicializada
expr: es cualquier expresion pl/sql que puede ser expresion literal, otra variable
o incluso una expresion que utiliza una función.

Consideraciones para Declarar e inicializar variables pl/sql
- usar las convenciones de nombres para variables
- usar nombres de variables significativos
- Inicializar variables con not null y constant
- inicializar variables con := o Default
- Declarar un identificador por linea
- Evitar usar nombre de columnas como identificadores
- Usar not null cuando la variable debe almacenar un valor

- Tipos de datos escalares: tienen un solo valor, depende del tipo de dato de var
- tipos de datos compuestos: recuperan varios datos 
- tipos de datos de referencia: tienen valores llamados punteros que apuntan a un lugar
de almacenamiento (ej cursor)

D. Tipos de datos lob: tienen valores llamados localizadores que especifican 
la ubicacion de los objetos grandes (como imagenes) que se almacenan fuera de la
tabla.

E. Variables Bind: No estan declaradas dentro del bloque, sino que fuera como
variables globales, estas pueden ser utilizadas por varios bloques
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
 (/ *) delimitador de inicio de comentario de varias lineas
 (* /)delimitador de fin comentario varias lineas
  .. operador de rango
 <> operador de distinto
 != operador distinto
 >= mayor o igual
 <= menor o igual
 -- comentario de una linea

Existen identificadores especiales denominados palabras reservadas,
no se pueden utilizar para declarar variables
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
* identificadores variables
* parametros
* nombres de tablas y columnas

- Indentar el codigo
- Nombre estandar de variables, comienzan von v (v_var)
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
v_nombre_completo varchar2(80);
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
    nombre varchar2(45)
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
cada valor se debe almacenar en una variable mediante clausula into
debe retornar solo una fila cuando se utilizan variables escalares
si quiere recuperar multiples filas debe utilizar cursores

- Convenciones de Nombres
* usar convenciones para evitar ambigüedades en clausula where
* evitar nombre de columnas de bd para identificadores
* nombres de columnas de tablas de bd tienen precedencia
por sobre los nombres de var locales
* nombres de var locales y parametros formales tienen prioridad por sobre
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
- de VARCHAR2 o CHAR  a NUMBER.
- de varchar2 o char a date
- de number a varchar2
- de date a varchar2

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
    v_nombre varchar2(50);
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
alter table tramo_notas add situacion varchar2(45);

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
-- CUANDO SE ANTEPONE UNA VARIABLE AL CASE (V_VAR := CASE), el case termina con 'END';
-- CUANDO NO SE ANTEPONE, SE TERMINA CON 'END CASE';
declare
    v_categoria varchar2(1):='A';
    v_sueldo number :=0;
    v_bono number :=0;
begin
    v_categoria:='&ingrese_categoria';
    v_sueldo:=&ingrese_sueldo;
    v_bono:= CASE -- CASE termina con end cuando se antepone variable
                WHEN v_categoria='A' and v_sueldo <1500 then 520
                WHEN v_categoria='A' and (v_sueldo >= 1500 and v_sueldo <= 3000) then 420
            else
                800
            end;
          dbms_output.put_line('Bono: ' || v_bono);  
end;
/
declare 
    v_categoria varchar2(1):='A';
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
    v_cont := v_cont+1; -- aumenta valor de variable
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
    for v_cont in 1..10 -- v_cont es una variable temporal del for la cual se puede
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
    v_cate varchar2(45);
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
tipo de variables lob
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
las variables indicadas.

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
    rut varchar2(45),
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
    -- lo que le pase a la variable que guarda v_clob sera lo mismo que cambie en campo comentario
    select length(' hombre de familia') into v_largo from dual;
    dbms_lob.writeappend(v_clob,v_largo,' hombre de familia');
    commit;
end;
select * from informe;
----------------------------------------------
-- insertar imagenes
create table vacaciones2021(
    cod number primary key,
    descripcion varchar2(80),
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
    v_foto varchar2(80); -- indica como se llama la foto
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
    v_foto varchar2(80);
begin -- proceso se deja dentro del bloque para capturar excepcion
    for x in (select * from alumno)
    loop
        begin
        v_foto:= x.cod_alumno||'.jpg';
        
        select foto into v_blob 
        from alumno where cod_alumno=x.cod_alumno for update; -- for update hace que cualquier cosa que le pase a variable le pasa a foto
    
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
    v_foto varchar2(300);
    v_mensaje_error varchar2(300);
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
    descripcion varchar2(300),
    foto varchar2(300)
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
    v_foto varchar2(300);
    v_mensaje_error varchar2(300);
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
-- objetos compuestos, son como variables pero con tipo
declare 
    type tipo_reg is record(
        nombre varchar2(45),
        edad number(3),
        rut varchar2(12)
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
    type comunas is table of varchar2(100) 
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
    reg_profesores cur_profesores%rowtype; -- rowtype hace la variable del tipo de fila cursor (tabla)
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
v_apellido VARCHAR2(50);
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
    v_error varchar2(300);
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
    -- y aplicar variable para insertar cual es el error
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
-- creacion de cursor con registro como variable compuesta
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
    dv_run varchar2(1)
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
    v_nombre varchar2(100);
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

-- ejemplo varray
/*
1.define, 2.declara, 3.inicializa, 4.asigna, 5.accede
*/
-- se define con type
declare
TYPE V_array_type IS varray(7) OF VARCHAR2(30);

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
son variables declaradas en la lista de parametros del
subprograma(modo in, out o in out) por defecto es in,
se usan en la seccion de ejecucion.

parametros actuales.
son valores, variables o expresiones usados para ejecutar un subprograma 
con parametros. se asocian a los parametros formales del sub
programa.

varray tiene un solo tipo de dato
in out manda un valor adentro y se pide que retorne un resultado

primer cursor tiene relacion de uno a muchos para el segundo
*/