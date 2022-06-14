/*
condiciones para hacer la prueba 
- se debe redondear todo a enteros  
- funciones parametricas para informacion (BIND)
- por cada profesional procesado se almacena en detalle_asignacion_mes
- en resumen_mes_profesion va resumen de profesiones de datos obtenidos en proceso
- informacion de errores que se deben controlar en el proceso se almacena en tabla errores_p
- error_id es = a seq_errores
- BIND para  fechas y valor limite 410.000 de asignacion de pago 
- VARRAY para: valores de 5 porcentajes de traslado y monto mov fijo
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

VARIABLE b_mes_proceso number;
EXEC :b_mes_proceso :=6; 
VARIABLE b_anno_proceso number;
EXEC :b_anno_proceso :=2021; 

DECLARE
    TYPE asesoria_type IS RECORD(
    mes number,
    anno number,
    run number,
    nombre varchar2(80),
    profesion varchar2(50),
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
  CURSOR cur_general is 
  
(SELECT DISTINCT
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
     ases.numrun_prof,
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno, 
     prosion.nombre_profesion)
    order by ases.numrun_prof;
 BEGIN
    open cur_general;
    loop
     
     FETCH cur_general INTO
     rec_asesoria.mes,
     rec_asesoria.anno,
     rec_asesoria.run, 
     rec_asesoria.nombre,
     rec_asesoria.profesion,
     rec_asesoria.nro_ases;
     exit when cur_general%notfound;
 
 DBMS_OUTPUT.PUT_LINE('mes '||rec_asesoria.mes||' año '||rec_asesoria.anno||
 ' run '||rec_asesoria.run||' nombre '||rec_asesoria.nombre||' profesion '||
 rec_asesoria.profesion||' n° asesorias '||rec_asesoria.nro_ases);
end loop;
close cur_general;

END;
/



/*POSICIONES VARRAY
- 1 CODEMP 10 = 2%
- 2 CODEMP 20 = 4%
- 3 CODEMP 30 = 5%
- 4 CODEMP 40 = 7%
- 5 CUALQUIER OTRO CASO DE RESIDENCIA SIN NULO = 9%
- 6 SI NO HAY RESIDENCIA 25.000 FIJO
*/
declare
-- DECLARANDO E INICIALIZANDO ARRAY
TYPE V_array_type IS VARRAY(6) of number;
v_array V_array_type := V_array_type(2,4,5,7,9,25000);

v_error exception;

TYPE asignaciones_type IS RECORD(
    run number,
    honorarios number,
    asig_mov number,

    asig_eval number,
    asig_tipocont number,
    asig_profesion number,
    total_asignaciones_profesional number,
    codemp number,
    codmuna number,
    comuna varchar2(35));

 reg_asig asignaciones_type;
 v_exe exception;
 
     CURSOR cur_asignaciones is
-- SELECT                            
(SELECT prof.numrun_prof as run,
    sum(ases.honorario) as suma,
    co.codemp_comuna as codemp,
    co.cod_comuna as codmuna,
    co.nom_comuna comuna
    
    from profesional prof
    left outer join comuna co on (co.cod_comuna=prof.cod_comuna)
    join asesoria ases on (ases.numrun_prof=prof.numrun_prof)
    where EXTRACT(MONTH FROM INICIO_ASESORIA)=6
    AND EXTRACT (YEAR FROM INICIO_ASESORIA)=2021 
    group by 
    prof.numrun_prof, co.codemp_comuna, co.cod_comuna, co.nom_comuna)
    order by run;

    
begin
    open cur_asignaciones;
    loop
    
FETCH cur_asignaciones into
    reg_asig.run,
    reg_asig.honorarios,
    reg_asig.codemp,
    reg_asig.codmuna,
    reg_asig.comuna;
    
    reg_asig.asig_mov := 
    CASE
    WHEN reg_asig.codmuna <> 81 AND reg_asig.codemp =  10 then ROUND(reg_asig.honorarios * v_array(1)/100)
    WHEN reg_asig.codmuna <> 81 AND reg_asig.codemp =  20 then ROUND(reg_asig.honorarios * v_array(2)/100)
    WHEN reg_asig.codmuna <> 81 AND reg_asig.codemp =  30 then ROUND(reg_asig.honorarios * v_array(3)/100)
    WHEN reg_asig.codmuna <> 81 AND reg_asig.codemp =  40 then ROUND(reg_asig.honorarios * v_array(4)/100)
    WHEN reg_asig.codmuna <> 81 AND reg_asig.codemp is not null THEN ROUND(reg_asig.honorarios * v_array(5)/100)
    WHEN reg_asig.codmuna is null AND reg_asig.codemp is null then v_array(6)
    end;
    

    exit when cur_asignaciones%notfound;
    
     dbms_output.put_line(reg_asig.run||' '||reg_asig.comuna  ||' mov '||reg_asig.asig_mov);
    --IF reg_asig.suma > 410000 THEN 
    --raise v_exe; 
    
    --end if;
    

end loop;

close cur_asignaciones;

end;
/




SELECT 
     EXTRACT(MONTH FROM ases.inicio_asesoria) as mes_proceso,
     EXTRACT(YEAR FROM ases.inicio_asesoria) as anno_proceso,
     --ases.numrun_prof as numrun_prof,
     --prof.nombre||' '||prof.appaterno||' '||prof.apmaterno as nombre_profesional, 
     --prosion.nombre_profesion as profesion,
     count(ases.numrun_prof),ases.numrun_prof,
     prof.nombre
     
     from asesoria ases
     left JOIN profesional prof
     on (ases.numrun_prof=prof.numrun_prof)
     INNER JOIN PROFESION prosion ON (prosion.cod_profesion=prof.cod_profesion)
     WHERE extract(month from inicio_asesoria)=6
     AND extract(YEAR FROM inicio_asesoria)=2021
   group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     ases.numrun_prof, prof.nombre;
     
/*
-- excepcion con raise
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

select numrun_prof,
count(honorario),
TO_CHAR(SUM(HONORARIO),'9G999G999')
from asesoria 
where EXTRACT(MONTH FROM INICIO_ASESORIA)=6
AND EXTRACT (YEAR FROM INICIO_ASESORIA)=2021
group by numrun_prof;
*/