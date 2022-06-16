
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

    TYPE V_array_type IS VARRAY(6) of number;
   v_array V_array_type := V_array_type(2,4,5,7,9,25000);

    TYPE V_array_type2 IS VARRAY(5) of number;
   v_array_eval V_array_type2 := V_array_type2(4,6,8,10,12);
   
    TYPE V_array_type3 IS VARRAY(4) of number;
   v_array_cont V_array_type3 := V_array_type3(5,5,10,15);

   TYPE V_array_type4 IS VARRAY(8) of number;
   v_array_prof V_array_type4 := V_array_type4(12.3 ,8 ,14.36 ,21.34 ,14.32 ,22.44 ,12.36 ,18.23);

    TYPE asesoria_type IS RECORD(
    mes number,
    anno number,
    run number,
    nombre varchar2(80),
    profesion varchar2(50),
    nro_ases number,
    honorarios number,
    asig_mov number,
    asig_eval number,
    asig_tipo_cont number,
    
asig_profesion number,
    
    total_asig_prof number,
    codemp number,
    codmuna number,
-- ejercicio profesion    
    sueldo number,
    cod_prof number,
    porc_prof number,
    
    puntaje number,
    contrato number,
    total number
    );
    
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
     count(ases.numrun_prof) as nro_ases,
     sum(ases.honorario) as honorarios,
     co.codemp_comuna as codemp,
    co.cod_comuna as codmuna,
    prof.puntaje as puntaje,
    prof.cod_tpcontrato as contrato,
    prosion.cod_profesion as cod_prof,
    prof.sueldo as sueldo

     
     from asesoria ases
     INNER JOIN profesional prof
     on (ases.numrun_prof=prof.numrun_prof)
     INNER JOIN PROFESION prosion ON (prosion.cod_profesion=prof.cod_profesion)
     INNER JOIN COMUNA co on (co.cod_comuna=prof.cod_comuna)

     WHERE extract(month from inicio_asesoria)=:b_mes_proceso
     AND extract(YEAR FROM inicio_asesoria)=:b_anno_proceso
   group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     ases.numrun_prof, 
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno, 
     prosion.nombre_profesion,
     co.codemp_comuna,
     co.cod_comuna, 
     prof.puntaje,
     cod_tpcontrato,
     prosion.cod_profesion,
     prof.sueldo)
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
     rec_asesoria.nro_ases,
     rec_asesoria.honorarios,
     rec_asesoria.codemp,
     rec_asesoria.codmuna,
     rec_asesoria.puntaje,
     rec_asesoria.contrato,
     rec_asesoria.cod_prof,
     rec_asesoria.sueldo;
     exit when cur_general%notfound;
 
 rec_asesoria.asig_mov := 
    CASE
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  10 then ROUND(rec_asesoria.honorarios * v_array(1)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  20 then ROUND(rec_asesoria.honorarios * v_array(2)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  30 then ROUND(rec_asesoria.honorarios * v_array(3)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  40 then ROUND(rec_asesoria.honorarios * v_array(4)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp is not null THEN ROUND(rec_asesoria.honorarios * v_array(5)/100)
    WHEN rec_asesoria.codmuna is null AND rec_asesoria.codemp is null then v_array(6)
    else 0
    end;
    
    rec_asesoria.asig_eval :=
    CASE 
    WHEN rec_asesoria.puntaje BETWEEN 70 AND 120 then ROUND(rec_asesoria.honorarios * v_array_eval(1)/100)
    WHEN rec_asesoria.puntaje BETWEEN 121 AND 249 then ROUND(rec_asesoria.honorarios * v_array_eval(2)/100)
    WHEN rec_asesoria.puntaje BETWEEN 230 AND 339 then ROUND(rec_asesoria.honorarios * v_array_eval(3)/100)
    WHEN rec_asesoria.puntaje BETWEEN 350 AND 470 then ROUND(rec_asesoria.honorarios * v_array_eval(4)/100)
    WHEN rec_asesoria.puntaje BETWEEN 480 AND 600 then ROUND(rec_asesoria.honorarios * v_array_eval(5)/100)
    end;
    
  rec_asesoria.asig_tipo_cont := 
    CASE
    WHEN rec_asesoria.contrato = 4 then ROUND(rec_asesoria.honorarios * v_array_cont(1)/100)
    WHEN rec_asesoria.contrato = 3 then ROUND(rec_asesoria.honorarios * v_array_cont(2)/100)
    WHEN rec_asesoria.contrato = 2 then ROUND(rec_asesoria.honorarios * v_array_cont(3)/100)
    WHEN rec_asesoria.contrato = 1 then ROUND(rec_asesoria.honorarios * v_array_cont(4)/100)
    end;
 
 rec_asesoria.asig_profesion:=
    CASE
    WHEN rec_asesoria.cod_prof = 1 then ROUND(rec_asesoria.sueldo * v_array_prof(1)/100)
    WHEN rec_asesoria.cod_prof = 2 then ROUND(rec_asesoria.sueldo * v_array_prof(2)/100)
    WHEN rec_asesoria.cod_prof = 3 then ROUND(rec_asesoria.sueldo * v_array_prof(3)/100)
    WHEN rec_asesoria.cod_prof = 4 then ROUND(rec_asesoria.sueldo * v_array_prof(4)/100)
    WHEN rec_asesoria.cod_prof = 5 then ROUND(rec_asesoria.sueldo * v_array_prof(5)/100)
    WHEN rec_asesoria.cod_prof = 6 then ROUND(rec_asesoria.sueldo * v_array_prof(6)/100)
    WHEN rec_asesoria.cod_prof = 7 then ROUND(rec_asesoria.sueldo * v_array_prof(7)/100)
    WHEN rec_asesoria.cod_prof = 8 then ROUND(rec_asesoria.sueldo * v_array_prof(8)/100)
    end;

    rec_asesoria.total:= 
    rec_asesoria.asig_mov + rec_asesoria.asig_eval +
    rec_asesoria.asig_tipo_cont +rec_asesoria.asig_profesion;
 
 DBMS_OUTPUT.PUT_LINE('mes '||rec_asesoria.mes||' año '||rec_asesoria.anno||
 ' run '||rec_asesoria.run||' nombre '||rec_asesoria.nombre||' profesion '||
 rec_asesoria.profesion||' n° asesorias '||rec_asesoria.nro_ases||' honorarios '||rec_asesoria.honorarios||
 ' codemp '|| rec_asesoria.codemp ||' codmuna ' || rec_asesoria.codmuna||
 ' asig_mov '||rec_asesoria.asig_mov || ' ASIGNACION PUNTAJE '||rec_asesoria.asig_eval || ' CONTRATO '||rec_asesoria.asig_tipo_cont||
 ' asig profesion '|| rec_asesoria.asig_profesion||' total '||rec_asesoria.total);
end loop;
close cur_general;

END;
/




-------------------------------
-- CURSORES ANIDADOS FUNCIONANDO




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

    TYPE V_array_type IS VARRAY(6) of number;
   v_array V_array_type := V_array_type(2,4,5,7,9,25000);

    TYPE V_array_type2 IS VARRAY(5) of number;
   v_array_eval V_array_type2 := V_array_type2(4,6,8,10,12);
   
    TYPE V_array_type3 IS VARRAY(4) of number;
   v_array_cont V_array_type3 := V_array_type3(5,5,10,15);

   TYPE V_array_type4 IS VARRAY(8) of number;
   v_array_prof V_array_type4 := V_array_type4(12.3 ,8 ,14.36 ,21.34 ,14.32 ,22.44 ,12.36 ,18.23);

    TYPE asesoria_type IS RECORD(
    mes number,
    anno number,
    run number,
    nombre varchar2(80),
    profesion varchar2(50),
    nro_ases number,
    honorarios number,
    asig_mov number,
    asig_eval number,
    asig_tipo_cont number,
    
asig_profesion number,
    
    total_asig_prof number,
    codemp number,
    codmuna number,
-- ejercicio profesion    
    sueldo number,
    cod_prof number,
    porc_prof number,
    
    puntaje number,
    contrato number,
    total number
    );
    
    rec_asesoria asesoria_type;

    type resumen_type IS RECORD(
    run number,
    mes number,
    anno number,
    annomes_proceso number,
    profesion varchar2(300),
    total_asesorias number,
    total_honorarios number,
    total_asimov number,
    total_asigeval number,
    total_asigtipocont number,
    total_asigprofesion number,
    total_asignaciones number);

rec_resumen resumen_type;

     
  CURSOR cur_general is 
  
  
(SELECT DISTINCT
     EXTRACT(MONTH FROM ases.inicio_asesoria) as mes_proceso,
     EXTRACT(YEAR FROM ases.inicio_asesoria) as anno_proceso,
     ases.numrun_prof as numrun_prof,
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno as nombre_profesional, 
     prosion.nombre_profesion as profesion,
     count(ases.numrun_prof) as nro_ases,
     sum(ases.honorario) as honorarios,
     co.codemp_comuna as codemp,
    co.cod_comuna as codmuna,
    prof.puntaje as puntaje,
    prof.cod_tpcontrato as contrato,
    prosion.cod_profesion as cod_prof,
    prof.sueldo as sueldo

     
     from asesoria ases
     INNER JOIN profesional prof
     on (ases.numrun_prof=prof.numrun_prof)
     INNER JOIN PROFESION prosion ON (prosion.cod_profesion=prof.cod_profesion)
     INNER JOIN COMUNA co on (co.cod_comuna=prof.cod_comuna)

     WHERE extract(month from inicio_asesoria)=:b_mes_proceso
     AND extract(YEAR FROM inicio_asesoria)=:b_anno_proceso
   group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     ases.numrun_prof, 
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno, 
     prosion.nombre_profesion,
     co.codemp_comuna,
     co.cod_comuna, 
     prof.puntaje,
     cod_tpcontrato,
     prosion.cod_profesion,
     prof.sueldo)
    order by ases.numrun_prof;

cursor cur_resumen(numrun number) is

    (SELECT 
    count(ases.numrun_prof)
     
     from asesoria ases 
     join profesional prof on (prof.numrun_prof=ases.numrun_prof)
     join profesion prosion on (prosion.cod_profesion=prof.cod_profesion)
     
     where EXTRACT(MONTH FROM ases.inicio_asesoria)=:b_mes_proceso
     AND EXTRACT(YEAR FROM ases.inicio_asesoria)=:b_anno_proceso
     AND ases.numrun_prof= numrun
     group by
     
     prosion.nombre_profesion
     /*
     group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     prosion.nombre_profesion
     */
     );

 BEGIN
    open cur_general;
    loop
     
     FETCH cur_general INTO
     rec_asesoria.mes,
     rec_asesoria.anno,
     rec_asesoria.run, 
     rec_asesoria.nombre,
     rec_asesoria.profesion,
     rec_asesoria.nro_ases,
     rec_asesoria.honorarios,
     rec_asesoria.codemp,
     rec_asesoria.codmuna,
     rec_asesoria.puntaje,
     rec_asesoria.contrato,
     rec_asesoria.cod_prof,
     rec_asesoria.sueldo;
     exit when cur_general%notfound;
 
 rec_asesoria.asig_mov := 
    CASE
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  10 then ROUND(rec_asesoria.honorarios * v_array(1)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  20 then ROUND(rec_asesoria.honorarios * v_array(2)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  30 then ROUND(rec_asesoria.honorarios * v_array(3)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  40 then ROUND(rec_asesoria.honorarios * v_array(4)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp is not null THEN ROUND(rec_asesoria.honorarios * v_array(5)/100)
    WHEN rec_asesoria.codmuna is null AND rec_asesoria.codemp is null then v_array(6)
    else 0
    end;
    
    rec_asesoria.asig_eval :=
    CASE 
    WHEN rec_asesoria.puntaje BETWEEN 70 AND 120 then ROUND(rec_asesoria.honorarios * v_array_eval(1)/100)
    WHEN rec_asesoria.puntaje BETWEEN 121 AND 249 then ROUND(rec_asesoria.honorarios * v_array_eval(2)/100)
    WHEN rec_asesoria.puntaje BETWEEN 230 AND 339 then ROUND(rec_asesoria.honorarios * v_array_eval(3)/100)
    WHEN rec_asesoria.puntaje BETWEEN 350 AND 470 then ROUND(rec_asesoria.honorarios * v_array_eval(4)/100)
    WHEN rec_asesoria.puntaje BETWEEN 480 AND 600 then ROUND(rec_asesoria.honorarios * v_array_eval(5)/100)
    end;
    
  rec_asesoria.asig_tipo_cont := 
    CASE
    WHEN rec_asesoria.contrato = 4 then ROUND(rec_asesoria.honorarios * v_array_cont(1)/100)
    WHEN rec_asesoria.contrato = 3 then ROUND(rec_asesoria.honorarios * v_array_cont(2)/100)
    WHEN rec_asesoria.contrato = 2 then ROUND(rec_asesoria.honorarios * v_array_cont(3)/100)
    WHEN rec_asesoria.contrato = 1 then ROUND(rec_asesoria.honorarios * v_array_cont(4)/100)
    end;
 
 rec_asesoria.asig_profesion:=
    CASE
    WHEN rec_asesoria.cod_prof = 1 then ROUND(rec_asesoria.sueldo * v_array_prof(1)/100)
    WHEN rec_asesoria.cod_prof = 2 then ROUND(rec_asesoria.sueldo * v_array_prof(2)/100)
    WHEN rec_asesoria.cod_prof = 3 then ROUND(rec_asesoria.sueldo * v_array_prof(3)/100)
    WHEN rec_asesoria.cod_prof = 4 then ROUND(rec_asesoria.sueldo * v_array_prof(4)/100)
    WHEN rec_asesoria.cod_prof = 5 then ROUND(rec_asesoria.sueldo * v_array_prof(5)/100)
    WHEN rec_asesoria.cod_prof = 6 then ROUND(rec_asesoria.sueldo * v_array_prof(6)/100)
    WHEN rec_asesoria.cod_prof = 7 then ROUND(rec_asesoria.sueldo * v_array_prof(7)/100)
    WHEN rec_asesoria.cod_prof = 8 then ROUND(rec_asesoria.sueldo * v_array_prof(8)/100)
    end;

    rec_asesoria.total:= 
    rec_asesoria.asig_mov + rec_asesoria.asig_eval +
    rec_asesoria.asig_tipo_cont +rec_asesoria.asig_profesion;
 /*
 DBMS_OUTPUT.PUT_LINE('mes '||rec_asesoria.mes||' año '||rec_asesoria.anno||
 ' run '||rec_asesoria.run||' nombre '||rec_asesoria.nombre||' profesion '||
 rec_asesoria.profesion||' n° asesorias '||rec_asesoria.nro_ases||' honorarios '||rec_asesoria.honorarios||
 ' codemp '|| rec_asesoria.codemp ||' codmuna ' || rec_asesoria.codmuna||
 ' asig_mov '||rec_asesoria.asig_mov || ' ASIGNACION PUNTAJE '||rec_asesoria.asig_eval || ' CONTRATO '||rec_asesoria.asig_tipo_cont||
 ' asig profesion '|| rec_asesoria.asig_profesion||' total '||rec_asesoria.total);
 */
open cur_resumen(rec_asesoria.run);
loop
FETCH cur_resumen INTO 
rec_resumen.total_asesorias;

rec_resumen.annomes_proceso := :b_anno_proceso ||'0'|| :b_mes_proceso;

rec_resumen.profesion := rec_asesoria.profesion;
--rec_resumen.total_asesorias := select count(numrun_prof) from asesoria;


--rec_resumen.total_asesorias := sum(rec_asesoria.nro_ases);




exit when cur_resumen%notfound;
dbms_output.put_line(' annomesproceso ' ||rec_resumen.annomes_proceso||' '||rec_resumen.profesion||' '||rec_resumen.total_asesorias);
end loop;
close cur_resumen;

end loop;
close cur_general;

END;
/

--------------------------------------------------

-- intento fallido

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

    TYPE V_array_type IS VARRAY(6) of number;
   v_array V_array_type := V_array_type(2,4,5,7,9,25000);

    TYPE V_array_type2 IS VARRAY(5) of number;
   v_array_eval V_array_type2 := V_array_type2(4,6,8,10,12);
   
    TYPE V_array_type3 IS VARRAY(4) of number;
   v_array_cont V_array_type3 := V_array_type3(5,5,10,15);

   TYPE V_array_type4 IS VARRAY(8) of number;
   v_array_prof V_array_type4 := V_array_type4(12.3 ,8 ,14.36 ,21.34 ,14.32 ,22.44 ,12.36 ,18.23);

    TYPE asesoria_type IS RECORD(
    mes number,
    anno number,
    run number,
    nombre varchar2(80),
    profesion varchar2(50),
    nro_ases number,
    honorarios number,
    asig_mov number,
    asig_eval number,
    asig_tipo_cont number,
    
asig_profesion number,
    
    total_asig_prof number,
    codemp number,
    codmuna number,
-- ejercicio profesion    
    sueldo number,
    cod_prof number,
    porc_prof number,
    
    puntaje number,
    contrato number,
    total number
    );
    


     
  CURSOR cur_general is 
  
  
(SELECT DISTINCT
     EXTRACT(MONTH FROM ases.inicio_asesoria) as mes_proceso,
     EXTRACT(YEAR FROM ases.inicio_asesoria) as anno_proceso,
     ases.numrun_prof as numrun_prof,
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno as nombre_profesional, 
     prosion.nombre_profesion as profesion,
     count(ases.numrun_prof) as nro_ases,
     sum(ases.honorario) as honorarios,
     co.codemp_comuna as codemp,
    co.cod_comuna as codmuna,
    prof.puntaje as puntaje,
    prof.cod_tpcontrato as contrato,
    prosion.cod_profesion as cod_prof,
    prof.sueldo as sueldo

     
     from asesoria ases
     INNER JOIN profesional prof
     on (ases.numrun_prof=prof.numrun_prof)
     INNER JOIN PROFESION prosion ON (prosion.cod_profesion=prof.cod_profesion)
     INNER JOIN COMUNA co on (co.cod_comuna=prof.cod_comuna)

     WHERE extract(month from inicio_asesoria)=:b_mes_proceso
     AND extract(YEAR FROM inicio_asesoria)=:b_anno_proceso
   group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     ases.numrun_prof, 
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno, 
     prosion.nombre_profesion,
     co.codemp_comuna,
     co.cod_comuna, 
     prof.puntaje,
     cod_tpcontrato,
     prosion.cod_profesion,
     prof.sueldo)
      order by prosion.nombre_profesion; --  prof.apmaterno prof.nombre ;  --prosion.nombre_profesion asc, prof.appaterno asc, prof.nombre asc;

    rec_asesoria asesoria_type;

    type resumen_type IS RECORD(
    run number,
    mes number,
    anno number,
    annomes_proceso number,
    profesion varchar2(300),
    total_asesorias number,
    total_honorarios number,
    total_asimov number,
    total_asigeval number,
    total_asigtipocont number,
    total_asigprofesion number,
    total_asignaciones number);

rec_resumen resumen_type;

cursor cur_resumen(numrun number) is
    (SELECT DISTINCT
    COUNT(ases.inicio_asesoria) as total_asesorias,
    SUM(ASES.HONORARIO) as total_honorarios,
    prosion.nombre_profesion as profesion 
    FROM ASESORIA ASES
    JOIN PROFESIONAL PROF ON (ases.numrun_prof=prof.numrun_prof)
    JOIN PROFESION PROSION ON (prosion.cod_profesion=prof.cod_profesion) 
    WHERE EXTRACT(YEAR FROM ASES.inicio_asesoria)=2021 AND
    EXTRACT(MONTH FROM ASES.inicio_asesoria)=06
    group by prosion.nombre_profesion);

/*
cursor cur_resumen(numrun number) is

    (SELECT 
    count(ases.numrun_prof)
     
     from asesoria ases 
     join profesional prof on (prof.numrun_prof=ases.numrun_prof)
     join profesion prosion on (prosion.cod_profesion=prof.cod_profesion)
     
     where EXTRACT(MONTH FROM ases.inicio_asesoria)=:b_mes_proceso
     AND EXTRACT(YEAR FROM ases.inicio_asesoria)=:b_anno_proceso
     AND ases.numrun_prof= numrun
     group by
     
     prosion.nombre_profesion
     /*
     group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     prosion.nombre_profesion
     
     );
*/

 BEGIN
    open cur_general;
    loop
     
     FETCH cur_general INTO
     rec_asesoria.mes,
     rec_asesoria.anno,
     rec_asesoria.run, 
     rec_asesoria.nombre,
     rec_asesoria.profesion,
     rec_asesoria.nro_ases,
     rec_asesoria.honorarios,
     rec_asesoria.codemp,
     rec_asesoria.codmuna,
     rec_asesoria.puntaje,
     rec_asesoria.contrato,
     rec_asesoria.cod_prof,
     rec_asesoria.sueldo;
     exit when cur_general%notfound;
 
 rec_asesoria.asig_mov := 
    CASE
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  10 then ROUND(rec_asesoria.honorarios * v_array(1)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  20 then ROUND(rec_asesoria.honorarios * v_array(2)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  30 then ROUND(rec_asesoria.honorarios * v_array(3)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  40 then ROUND(rec_asesoria.honorarios * v_array(4)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp is not null THEN ROUND(rec_asesoria.honorarios * v_array(5)/100)
    WHEN rec_asesoria.codmuna is null AND rec_asesoria.codemp is null then v_array(6)
    else 0
    end;
    
    rec_asesoria.asig_eval :=
    CASE 
    WHEN rec_asesoria.puntaje BETWEEN 70 AND 120 then ROUND(rec_asesoria.honorarios * v_array_eval(1)/100)
    WHEN rec_asesoria.puntaje BETWEEN 121 AND 249 then ROUND(rec_asesoria.honorarios * v_array_eval(2)/100)
    WHEN rec_asesoria.puntaje BETWEEN 230 AND 339 then ROUND(rec_asesoria.honorarios * v_array_eval(3)/100)
    WHEN rec_asesoria.puntaje BETWEEN 350 AND 470 then ROUND(rec_asesoria.honorarios * v_array_eval(4)/100)
    WHEN rec_asesoria.puntaje BETWEEN 480 AND 600 then ROUND(rec_asesoria.honorarios * v_array_eval(5)/100)
    end;
    
  rec_asesoria.asig_tipo_cont := 
    CASE
    WHEN rec_asesoria.contrato = 4 then ROUND(rec_asesoria.honorarios * v_array_cont(1)/100)
    WHEN rec_asesoria.contrato = 3 then ROUND(rec_asesoria.honorarios * v_array_cont(2)/100)
    WHEN rec_asesoria.contrato = 2 then ROUND(rec_asesoria.honorarios * v_array_cont(3)/100)
    WHEN rec_asesoria.contrato = 1 then ROUND(rec_asesoria.honorarios * v_array_cont(4)/100)
    end;
 
 rec_asesoria.asig_profesion:=
    CASE
    WHEN rec_asesoria.cod_prof = 1 then ROUND(rec_asesoria.sueldo * v_array_prof(1)/100)
    WHEN rec_asesoria.cod_prof = 2 then ROUND(rec_asesoria.sueldo * v_array_prof(2)/100)
    WHEN rec_asesoria.cod_prof = 3 then ROUND(rec_asesoria.sueldo * v_array_prof(3)/100)
    WHEN rec_asesoria.cod_prof = 4 then ROUND(rec_asesoria.sueldo * v_array_prof(4)/100)
    WHEN rec_asesoria.cod_prof = 5 then ROUND(rec_asesoria.sueldo * v_array_prof(5)/100)
    WHEN rec_asesoria.cod_prof = 6 then ROUND(rec_asesoria.sueldo * v_array_prof(6)/100)
    WHEN rec_asesoria.cod_prof = 7 then ROUND(rec_asesoria.sueldo * v_array_prof(7)/100)
    WHEN rec_asesoria.cod_prof = 8 then ROUND(rec_asesoria.sueldo * v_array_prof(8)/100)
    end;

    rec_asesoria.total:= 
    rec_asesoria.asig_mov + rec_asesoria.asig_eval +
    rec_asesoria.asig_tipo_cont +rec_asesoria.asig_profesion;
 /*
 DBMS_OUTPUT.PUT_LINE('mes '||rec_asesoria.mes||' año '||rec_asesoria.anno||
 ' run '||rec_asesoria.run||' nombre '||rec_asesoria.nombre||' profesion '||
 rec_asesoria.profesion||' n° asesorias '||rec_asesoria.nro_ases||' honorarios '||rec_asesoria.honorarios||
 ' codemp '|| rec_asesoria.codemp ||' codmuna ' || rec_asesoria.codmuna||
 ' asig_mov '||rec_asesoria.asig_mov || ' ASIGNACION PUNTAJE '||rec_asesoria.asig_eval || ' CONTRATO '||rec_asesoria.asig_tipo_cont||
 ' asig profesion '|| rec_asesoria.asig_profesion||' total '||rec_asesoria.total);
 */
open cur_resumen(rec_asesoria.run);
loop
FETCH cur_resumen INTO 
rec_resumen.total_asesorias,
  rec_resumen.total_honorarios,
  rec_resumen.profesion; 



rec_resumen.annomes_proceso := :b_anno_proceso ||'0'|| :b_mes_proceso;

rec_resumen.profesion := rec_asesoria.profesion;
--rec_resumen.total_asesorias := select count(numrun_prof) from asesoria;


--rec_resumen.total_asesorias := sum(rec_asesoria.nro_ases);




exit when cur_resumen%notfound;
dbms_output.put_line(rec_resumen.total_asesorias||' '|| rec_resumen.total_honorarios||' '|| rec_resumen.profesion );
end loop;
close cur_resumen;

end loop;
close cur_general;

END;
/

SELECT 
COUNT(ases.inicio_asesoria),
SUM(ASES.HONORARIO),
prosion.nombre_profesion 
FROM ASESORIA ASES
JOIN PROFESIONAL PROF ON (ases.numrun_prof=prof.numrun_prof)
JOIN PROFESION PROSION ON (prosion.cod_profesion=prof.cod_profesion) 
WHERE EXTRACT(YEAR FROM ASES.inicio_asesoria)=2021 AND
EXTRACT(MONTH FROM ASES.inicio_asesoria)=06
group by prosion.nombre_profesion;



--------------------------------------------------------------------------------------------


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

    TYPE V_array_type IS VARRAY(6) of number;
   v_array V_array_type := V_array_type(2,4,5,7,9,25000);

    TYPE V_array_type2 IS VARRAY(5) of number;
   v_array_eval V_array_type2 := V_array_type2(4,6,8,10,12);
   
    TYPE V_array_type3 IS VARRAY(4) of number;
   v_array_cont V_array_type3 := V_array_type3(5,5,10,15);

   TYPE V_array_type4 IS VARRAY(8) of number;
   v_array_prof V_array_type4 := V_array_type4(12.3 ,8 ,14.36 ,21.34 ,14.32 ,22.44 ,12.36 ,18.23);

    TYPE asesoria_type IS RECORD( -- TYPE padre
    mes number,
    anno number,
    run number,
    nombre varchar2(80),
    profesion varchar2(50),
    nro_ases number,
    honorarios number,
    asig_mov number,
    asig_eval number,
    asig_tipo_cont number,
    asig_profesion number,
    total_asig_prof number,
    codemp number,
    codmuna number, 
    sueldo number,
    cod_prof number,
    porc_prof number,
    puntaje number,
    contrato number,
    total number
    );
    rec_asesorias asesoria_type; --TYPE PADRE

  CURSOR cur_asesorias is -- CURSOR PADRE
  
(SELECT DISTINCT
     EXTRACT(MONTH FROM ases.inicio_asesoria) as mes_proceso,
     EXTRACT(YEAR FROM ases.inicio_asesoria) as anno_proceso,
     ases.numrun_prof as numrun_prof,
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno as nombre_profesional, 
     prosion.nombre_profesion as profesion,
     count(ases.numrun_prof) as nro_ases,
     sum(ases.honorario) as honorarios,
     co.codemp_comuna as codemp,
    co.cod_comuna as codmuna,
    prof.puntaje as puntaje,
    prof.cod_tpcontrato as contrato,
    prosion.cod_profesion as cod_prof,
    prof.sueldo as sueldo
from asesoria ases
     INNER JOIN profesional prof
     on (ases.numrun_prof=prof.numrun_prof)
     INNER JOIN PROFESION prosion ON (prosion.cod_profesion=prof.cod_profesion)
     INNER JOIN COMUNA co on (co.cod_comuna=prof.cod_comuna)
WHERE extract(month from inicio_asesoria)=:b_mes_proceso
     AND extract(YEAR FROM inicio_asesoria)=:b_anno_proceso
group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     ases.numrun_prof, 
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno, 
     prosion.nombre_profesion,
     co.codemp_comuna,
     co.cod_comuna, 
     prof.puntaje,
     cod_tpcontrato,
     prosion.cod_profesion,
     prof.sueldo)
    order by ases.numrun_prof;
  --------------------------------------------------------HIJO--------------------------------HIJO  
     TYPE profesional_type IS RECORD( -- TYPE hijo
    annomes_proceso number,
    anno number,
    mes number,
    run number,
    total_asesorias number,
    total_honorarios number,
    total_asigmov number,
    total_asigeval number,
    total_asigtipocont number,
    total_asigprofesion number,
    total_asignaciones number,
    codigo_profesion number);
rec_profesional profesional_type; -- VARIABLE COMPUESTA hijo
--------------------------------------------------------------------------------------CURSOR HIJO
CURSOR cur_profesional(cod_prosion number) is -- CURSOR hijo
-- FILTRAR CON TABLA DUAL MES Y ANNO
(SELECT 
numrun_prof
from profesional prof
WHERE cod_profesion=cod_prosion
--GROUP BY numrun_prof
);
    
 -------------------------------------------------BEGIN---------------------------------------------------
 BEGIN
    FOR i IN cur_asesorias
    loop     

     rec_asesorias.mes:= i.mes_proceso;
     rec_asesorias.anno:= i.anno_proceso;
     rec_asesorias.run:= i.numrun_prof;
     rec_asesorias.nombre:= i.nombre_profesional;
     rec_asesorias.profesion:= i.profesion;
     rec_asesorias.nro_ases:= i.nro_ases;
     rec_asesorias.honorarios:= i.honorarios;
     rec_asesorias.codemp:= i.codemp;
     rec_asesorias.codmuna:= i.codmuna;
     rec_asesorias.puntaje:= i.puntaje;
     rec_asesorias.contrato:= i.contrato;
     rec_asesorias.cod_prof:= i.cod_prof; -- CODIGO DE PROFESION PARAMETRO CURSOR HIJO
     rec_asesorias.sueldo:= i.sueldo;
    
 
 rec_asesorias.asig_mov := 
    CASE
    WHEN rec_asesorias.codmuna <> 81 AND rec_asesorias.codemp =  10 then ROUND(rec_asesorias.honorarios * v_array(1)/100)
    WHEN rec_asesorias.codmuna <> 81 AND rec_asesorias.codemp =  20 then ROUND(rec_asesorias.honorarios * v_array(2)/100)
    WHEN rec_asesorias.codmuna <> 81 AND rec_asesorias.codemp =  30 then ROUND(rec_asesorias.honorarios * v_array(3)/100)
    WHEN rec_asesorias.codmuna <> 81 AND rec_asesorias.codemp =  40 then ROUND(rec_asesorias.honorarios * v_array(4)/100)
    WHEN rec_asesorias.codmuna <> 81 AND rec_asesorias.codemp is not null THEN ROUND(rec_asesorias.honorarios * v_array(5)/100)
    WHEN rec_asesorias.codmuna is null AND rec_asesorias.codemp is null then v_array(6)
    else 0
    end;
    
    rec_asesorias.asig_eval :=
    CASE 
    WHEN rec_asesorias.puntaje BETWEEN 70 AND 120 then ROUND(rec_asesorias.honorarios * v_array_eval(1)/100)
    WHEN rec_asesorias.puntaje BETWEEN 121 AND 249 then ROUND(rec_asesorias.honorarios * v_array_eval(2)/100)
    WHEN rec_asesorias.puntaje BETWEEN 230 AND 339 then ROUND(rec_asesorias.honorarios * v_array_eval(3)/100)
    WHEN rec_asesorias.puntaje BETWEEN 350 AND 470 then ROUND(rec_asesorias.honorarios * v_array_eval(4)/100)
    WHEN rec_asesorias.puntaje BETWEEN 480 AND 600 then ROUND(rec_asesorias.honorarios * v_array_eval(5)/100)
    end;
    
  rec_asesorias.asig_tipo_cont := 
    CASE
    WHEN rec_asesorias.contrato = 4 then ROUND(rec_asesorias.honorarios * v_array_cont(1)/100)
    WHEN rec_asesorias.contrato = 3 then ROUND(rec_asesorias.honorarios * v_array_cont(2)/100)
    WHEN rec_asesorias.contrato = 2 then ROUND(rec_asesorias.honorarios * v_array_cont(3)/100)
    WHEN rec_asesorias.contrato = 1 then ROUND(rec_asesorias.honorarios * v_array_cont(4)/100)
    end;
 
 rec_asesorias.asig_profesion:=
    CASE
    WHEN rec_asesorias.cod_prof = 1 then ROUND(rec_asesorias.sueldo * v_array_prof(1)/100)
    WHEN rec_asesorias.cod_prof = 2 then ROUND(rec_asesorias.sueldo * v_array_prof(2)/100)
    WHEN rec_asesorias.cod_prof = 3 then ROUND(rec_asesorias.sueldo * v_array_prof(3)/100)
    WHEN rec_asesorias.cod_prof = 4 then ROUND(rec_asesorias.sueldo * v_array_prof(4)/100)
    WHEN rec_asesorias.cod_prof = 5 then ROUND(rec_asesorias.sueldo * v_array_prof(5)/100)
    WHEN rec_asesorias.cod_prof = 6 then ROUND(rec_asesorias.sueldo * v_array_prof(6)/100)
    WHEN rec_asesorias.cod_prof = 7 then ROUND(rec_asesorias.sueldo * v_array_prof(7)/100)
    WHEN rec_asesorias.cod_prof = 8 then ROUND(rec_asesorias.sueldo * v_array_prof(8)/100)
    end;

    rec_asesorias.total:= 
    rec_asesorias.asig_mov + rec_asesorias.asig_eval +
    rec_asesorias.asig_tipo_cont +rec_asesorias.asig_profesion;
 /*
 DBMS_OUTPUT.PUT_LINE('mes '||rec_asesorias.mes||' año '||rec_asesorias.anno||
 ' run '||rec_asesorias.run||' nombre '||rec_asesorias.nombre||' profesion '||
 rec_asesorias.profesion||' n° asesorias '||rec_asesorias.nro_ases||' honorarios '||rec_asesorias.honorarios||
 ' codemp '|| rec_asesorias.codemp ||' codmuna ' || rec_asesorias.codmuna||
 ' asig_mov '||rec_asesorias.asig_mov || ' ASIGNACION PUNTAJE '||rec_asesorias.asig_eval || ' CONTRATO '||rec_asesorias.asig_tipo_cont||
 ' asig profesion '|| rec_asesorias.asig_profesion||' total '||rec_asesorias.total);
*/

for reg in cur_profesional(i.cod_prof) LOOP
 
 
 -- rec_profesional.codigo_profesion:= reg.cod_prof; -- CODIGO DE PROFESION PARAMETRO CURSOR HIJO 
 rec_profesional.run := reg.numrun_prof;
 rec_profesional.codigo_profesion:= reg.cod_prof ;
 DBMS_OUTPUT.PUT_LINE(' rut hijo '|| rec_profesional.run||'codigo profesion '||rec_profesional.codigo_profesion);
 
end loop;
 
end loop;
END;
/



















































----------------------------------------------------------------------------------------------------------------------
-- HIJO FOR
-- INTENTO FALLIDO WHILE
-- HIJO
DECLARE
 TYPE profesional_type IS RECORD( -- TYPE hijo
    annomes_proceso number,
    anno number,
    mes number,
    run number,
    total_asesorias number,
    total_honorarios number,
    total_asigmov number,
    total_asigeval number,
    total_asigtipocont number,
    total_asigprofesion number,
    total_asignaciones number,
    cod_prof number);
rec_profesional profesional_type; -- VARIABLE COMPUESTA hijo

CURSOR cur_profesional--(cod_prosion number)
is -- CURSOR hijo
-- FILTRAR CON TABLA DUAL MES Y ANNO
(SELECT 
cod_profesion
from profesional prof
GROUP BY COD_PROFESION
--WHERE cod_profesion=cod_prosion
);
 -------------------------------------------------BEGIN---------------------------------------------------
 BEGIN

 for reg in cur_profesional() LOOP
 
 rec_profesional.run := reg.cod_profesion; -- CODIGO DE PROFESION PARAMETRO CURSOR HIJO 
 
   
     
     
  
 DBMS_OUTPUT.PUT_LINE('CALCULOS A REALIZAR '||rec_profesional.cod_prof);
 
end loop;
END;
/

---------------------------END..........................
























-- INTENTO FALLIDO WHILE
-- HIJO
DECLARE
 TYPE profesional_type IS RECORD( -- TYPE hijo
    annomes_proceso number,
    anno number,
    mes number,
    run number,
    total_asesorias number,
    total_honorarios number,
    total_asigmov number,
    total_asigeval number,
    total_asigtipocont number,
    total_asigprofesion number,
    total_asignaciones number,
    cod_prof number);
rec_profesional profesional_type; -- VARIABLE COMPUESTA hijo

CURSOR cur_profesional--(cod_prosion number)
is -- CURSOR hijo
-- FILTRAR CON TABLA DUAL MES Y ANNO
(SELECT 
cod_profesion
from profesional prof
GROUP BY COD_PROFESION
--WHERE cod_profesion=cod_prosion
);
 -------------------------------------------------BEGIN---------------------------------------------------
 BEGIN
 open cur_profesional;
 FETCH cur_profesional into 
 
 rec_profesional.cod_prof; --:= cur_profesional.cod_profesion; -- CODIGO DE PROFESION PARAMETRO CURSOR HIJO
 
   WHILE cur_profesional%FOUND --ROWCOUNT <100
    LOOP     
  --for reg in cur_profesional LOOP
 
     
     
 EXIT WHEN cur_profesional%ROWCOUNT <10;    
 DBMS_OUTPUT.PUT_LINE('CALCULOS A REALIZAR '||rec_profesional.cod_prof);
 
end loop;
END;
/









































-------------------------------
-- CURSORES ANIDADOS FUNCIONANDO
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
    TYPE V_array_type IS VARRAY(6) of number;
    v_array V_array_type := V_array_type(2,4,5,7,9,25000);

    TYPE V_array_type2 IS VARRAY(5) of number;
    v_array_eval V_array_type2 := V_array_type2(4,6,8,10,12);
    
    TYPE V_array_type3 IS VARRAY(4) of number;
    v_array_cont V_array_type3 := V_array_type3(5,5,10,15);
    
    TYPE V_array_type4 IS VARRAY(8) of number;
    v_array_prof V_array_type4 := V_array_type4(12.3 ,8 ,14.36 ,21.34 ,14.32 ,22.44 ,12.36 ,18.23);
-- RECORD PADRE
TYPE asesoria_type IS RECORD(
    mes number,
    anno number,
    run number,
    nombre varchar2(80),
    profesion varchar2(50),
    cod_prof number,
    nro_ases number,
    honorarios number,
    asig_mov number,
    asig_eval number,
    asig_tipo_cont number, 
    asig_profesion number,
    total_asig_prof number,
    codemp number,
    codmuna number,  
    sueldo number,
    porc_prof number,
    puntaje number,
    contrato number,
    total number);
rec_asesoria asesoria_type;
---RECORD HIJO------------------------------------------------
type resumen_type IS RECORD(
    run number,
    mes number,
    anno number,
    annomes_proceso number,
    profesion varchar2(300),
    total_asesorias number,
    total_honorarios number,
    total_asimov number,
    total_asigeval number,
    total_asigtipocont number,
    total_asigprofesion number,
    total_asignaciones number);
rec_resumen resumen_type;
----CURSOR PADRE-------------------------------------------------------------     
  CURSOR cur_general is 
    
(SELECT DISTINCT
     EXTRACT(MONTH FROM ases.inicio_asesoria) as mes_proceso,
     EXTRACT(YEAR FROM ases.inicio_asesoria) as anno_proceso,
     ases.numrun_prof as numrun_prof,
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno as nombre_profesional, 
     prosion.nombre_profesion as profesion,
     count(ases.numrun_prof) as nro_ases,
     sum(ases.honorario) as honorarios,
     co.codemp_comuna as codemp,
     co.cod_comuna as codmuna,
     prof.puntaje as puntaje,
     prof.cod_tpcontrato as contrato,
     prosion.cod_profesion as cod_prof,
     prof.sueldo as sueldo
     from asesoria ases
     INNER JOIN profesional prof
     on (ases.numrun_prof=prof.numrun_prof)
     INNER JOIN PROFESION prosion ON (prosion.cod_profesion=prof.cod_profesion)
     INNER JOIN COMUNA co on (co.cod_comuna=prof.cod_comuna)
WHERE extract(month from inicio_asesoria)=:b_mes_proceso
     AND extract(YEAR FROM inicio_asesoria)=:b_anno_proceso
group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     ases.numrun_prof, 
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno, 
     prosion.nombre_profesion,
     co.codemp_comuna,
     co.cod_comuna, 
     prof.puntaje,
     cod_tpcontrato,
     prosion.cod_profesion,
     prof.sueldo)
order by ases.numrun_prof;
---------------CURSOR HIJO----------------------------
cursor cur_resumen(cod_prof number) is 
(SELECT 
     COD_PROFESION    
     from profesional  
     where cod_profesion=cod_prof
     --EXTRACT(MONTH FROM ases.inicio_asesoria)=:b_mes_proceso AND
     --EXTRACT(YEAR FROM ases.inicio_asesoria)=:b_anno_proceso
     /*
     group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     prosion.nombre_profesion
     */
     );
 BEGIN
    open cur_general;
    loop

     rec_asesoria.mes := ;
     rec_asesoria.anno:= ;
     rec_asesoria.run:= ; 
     rec_asesoria.nombre:= ;
     rec_asesoria.profesion:= ;
     rec_asesoria.nro_ases:= ;
     rec_asesoria.honorarios:= ;
     rec_asesoria.codemp:= ;
     rec_asesoria.codmuna:= ;
     rec_asesoria.puntaje:= ;
     rec_asesoria.contrato:= ;
     rec_asesoria.cod_prof:= ;
     rec_asesoria.sueldo:= ;
     exit when cur_profesional%notfound;
 
 rec_asesoria.asig_mov := 
    CASE
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  10 then ROUND(rec_asesoria.honorarios * v_array(1)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  20 then ROUND(rec_asesoria.honorarios * v_array(2)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  30 then ROUND(rec_asesoria.honorarios * v_array(3)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  40 then ROUND(rec_asesoria.honorarios * v_array(4)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp is not null THEN ROUND(rec_asesoria.honorarios * v_array(5)/100)
    WHEN rec_asesoria.codmuna is null AND rec_asesoria.codemp is null then v_array(6)
    else 0
    end;
    
    rec_asesoria.asig_eval :=
    CASE 
    WHEN rec_asesoria.puntaje BETWEEN 70 AND 120 then ROUND(rec_asesoria.honorarios * v_array_eval(1)/100)
    WHEN rec_asesoria.puntaje BETWEEN 121 AND 249 then ROUND(rec_asesoria.honorarios * v_array_eval(2)/100)
    WHEN rec_asesoria.puntaje BETWEEN 230 AND 339 then ROUND(rec_asesoria.honorarios * v_array_eval(3)/100)
    WHEN rec_asesoria.puntaje BETWEEN 350 AND 470 then ROUND(rec_asesoria.honorarios * v_array_eval(4)/100)
    WHEN rec_asesoria.puntaje BETWEEN 480 AND 600 then ROUND(rec_asesoria.honorarios * v_array_eval(5)/100)
    end;
    
  rec_asesoria.asig_tipo_cont := 
    CASE
    WHEN rec_asesoria.contrato = 4 then ROUND(rec_asesoria.honorarios * v_array_cont(1)/100)
    WHEN rec_asesoria.contrato = 3 then ROUND(rec_asesoria.honorarios * v_array_cont(2)/100)
    WHEN rec_asesoria.contrato = 2 then ROUND(rec_asesoria.honorarios * v_array_cont(3)/100)
    WHEN rec_asesoria.contrato = 1 then ROUND(rec_asesoria.honorarios * v_array_cont(4)/100)
    end;
 
 rec_asesoria.asig_profesion:=
    CASE
    WHEN rec_asesoria.cod_prof = 1 then ROUND(rec_asesoria.sueldo * v_array_prof(1)/100)
    WHEN rec_asesoria.cod_prof = 2 then ROUND(rec_asesoria.sueldo * v_array_prof(2)/100)
    WHEN rec_asesoria.cod_prof = 3 then ROUND(rec_asesoria.sueldo * v_array_prof(3)/100)
    WHEN rec_asesoria.cod_prof = 4 then ROUND(rec_asesoria.sueldo * v_array_prof(4)/100)
    WHEN rec_asesoria.cod_prof = 5 then ROUND(rec_asesoria.sueldo * v_array_prof(5)/100)
    WHEN rec_asesoria.cod_prof = 6 then ROUND(rec_asesoria.sueldo * v_array_prof(6)/100)
    WHEN rec_asesoria.cod_prof = 7 then ROUND(rec_asesoria.sueldo * v_array_prof(7)/100)
    WHEN rec_asesoria.cod_prof = 8 then ROUND(rec_asesoria.sueldo * v_array_prof(8)/100)
    end;

    rec_asesoria.total:= 
    rec_asesoria.asig_mov + rec_asesoria.asig_eval +
    rec_asesoria.asig_tipo_cont +rec_asesoria.asig_profesion;
 /*
 DBMS_OUTPUT.PUT_LINE('mes '||rec_asesoria.mes||' año '||rec_asesoria.anno||
 ' run '||rec_asesoria.run||' nombre '||rec_asesoria.nombre||' profesion '||
 rec_asesoria.profesion||' n° asesorias '||rec_asesoria.nro_ases||' honorarios '||rec_asesoria.honorarios||
 ' codemp '|| rec_asesoria.codemp ||' codmuna ' || rec_asesoria.codmuna||
 ' asig_mov '||rec_asesoria.asig_mov || ' ASIGNACION PUNTAJE '||rec_asesoria.asig_eval || ' CONTRATO '||rec_asesoria.asig_tipo_cont||
 ' asig profesion '|| rec_asesoria.asig_profesion||' total '||rec_asesoria.total);
 */
open cur_resumen(rec_asesoria.run);
loop
FETCH cur_resumen INTO 
rec_resumen.total_asesorias;

rec_resumen.annomes_proceso := :b_anno_proceso ||'0'|| :b_mes_proceso;

rec_resumen.profesion := rec_asesoria.profesion;
--rec_resumen.total_asesorias := select count(numrun_prof) from asesoria;


--rec_resumen.total_asesorias := sum(rec_asesoria.nro_ases);




exit when cur_resumen%notfound;
dbms_output.put_line(' annomesproceso ' ||rec_resumen.annomes_proceso||' '||rec_resumen.profesion||' '||rec_resumen.total_asesorias);
end loop;
close cur_resumen;

end loop;
close cur_general;

END;
/

--------------------------------------------------

-- intento fallido

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

    TYPE V_array_type IS VARRAY(6) of number;
   v_array V_array_type := V_array_type(2,4,5,7,9,25000);

    TYPE V_array_type2 IS VARRAY(5) of number;
   v_array_eval V_array_type2 := V_array_type2(4,6,8,10,12);
   
    TYPE V_array_type3 IS VARRAY(4) of number;
   v_array_cont V_array_type3 := V_array_type3(5,5,10,15);

   TYPE V_array_type4 IS VARRAY(8) of number;
   v_array_prof V_array_type4 := V_array_type4(12.3 ,8 ,14.36 ,21.34 ,14.32 ,22.44 ,12.36 ,18.23);

    TYPE asesoria_type IS RECORD(
    mes number,
    anno number,
    run number,
    nombre varchar2(80),
    profesion varchar2(50),
    nro_ases number,
    honorarios number,
    asig_mov number,
    asig_eval number,
    asig_tipo_cont number,
    
asig_profesion number,
    
    total_asig_prof number,
    codemp number,
    codmuna number,
-- ejercicio profesion    
    sueldo number,
    cod_prof number,
    porc_prof number,
    
    puntaje number,
    contrato number,
    total number
    );
    


     
  CURSOR cur_general is 
  
  
(SELECT DISTINCT
     EXTRACT(MONTH FROM ases.inicio_asesoria) as mes_proceso,
     EXTRACT(YEAR FROM ases.inicio_asesoria) as anno_proceso,
     ases.numrun_prof as numrun_prof,
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno as nombre_profesional, 
     prosion.nombre_profesion as profesion,
     count(ases.numrun_prof) as nro_ases,
     sum(ases.honorario) as honorarios,
     co.codemp_comuna as codemp,
    co.cod_comuna as codmuna,
    prof.puntaje as puntaje,
    prof.cod_tpcontrato as contrato,
    prosion.cod_profesion as cod_prof,
    prof.sueldo as sueldo

     
     from asesoria ases
     INNER JOIN profesional prof
     on (ases.numrun_prof=prof.numrun_prof)
     INNER JOIN PROFESION prosion ON (prosion.cod_profesion=prof.cod_profesion)
     INNER JOIN COMUNA co on (co.cod_comuna=prof.cod_comuna)

     WHERE extract(month from inicio_asesoria)=:b_mes_proceso
     AND extract(YEAR FROM inicio_asesoria)=:b_anno_proceso
   group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     ases.numrun_prof, 
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno, 
     prosion.nombre_profesion,
     co.codemp_comuna,
     co.cod_comuna, 
     prof.puntaje,
     cod_tpcontrato,
     prosion.cod_profesion,
     prof.sueldo)
      order by prosion.nombre_profesion; --  prof.apmaterno prof.nombre ;  --prosion.nombre_profesion asc, prof.appaterno asc, prof.nombre asc;

    rec_asesoria asesoria_type;

    type resumen_type IS RECORD(
    run number,
    mes number,
    anno number,
    annomes_proceso number,
    profesion varchar2(300),
    total_asesorias number,
    total_honorarios number,
    total_asimov number,
    total_asigeval number,
    total_asigtipocont number,
    total_asigprofesion number,
    total_asignaciones number);

rec_resumen resumen_type;

cursor cur_resumen(numrun number) is
    (SELECT DISTINCT
    COUNT(ases.inicio_asesoria) as total_asesorias,
    SUM(ASES.HONORARIO) as total_honorarios,
    prosion.nombre_profesion as profesion 
    FROM ASESORIA ASES
    JOIN PROFESIONAL PROF ON (ases.numrun_prof=prof.numrun_prof)
    JOIN PROFESION PROSION ON (prosion.cod_profesion=prof.cod_profesion) 
    WHERE EXTRACT(YEAR FROM ASES.inicio_asesoria)=2021 AND
    EXTRACT(MONTH FROM ASES.inicio_asesoria)=06
    group by prosion.nombre_profesion);

/*
cursor cur_resumen(numrun number) is

    (SELECT 
    count(ases.numrun_prof)
     
     from asesoria ases 
     join profesional prof on (prof.numrun_prof=ases.numrun_prof)
     join profesion prosion on (prosion.cod_profesion=prof.cod_profesion)
     
     where EXTRACT(MONTH FROM ases.inicio_asesoria)=:b_mes_proceso
     AND EXTRACT(YEAR FROM ases.inicio_asesoria)=:b_anno_proceso
     AND ases.numrun_prof= numrun
     group by
     
     prosion.nombre_profesion
     /*
     group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     prosion.nombre_profesion
     
     );
*/

 BEGIN
    open cur_general;
    loop
     
     FETCH cur_general INTO
     rec_asesoria.mes,
     rec_asesoria.anno,
     rec_asesoria.run, 
     rec_asesoria.nombre,
     rec_asesoria.profesion,
     rec_asesoria.nro_ases,
     rec_asesoria.honorarios,
     rec_asesoria.codemp,
     rec_asesoria.codmuna,
     rec_asesoria.puntaje,
     rec_asesoria.contrato,
     rec_asesoria.cod_prof,
     rec_asesoria.sueldo;
     exit when cur_general%notfound;
 
 rec_asesoria.asig_mov := 
    CASE
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  10 then ROUND(rec_asesoria.honorarios * v_array(1)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  20 then ROUND(rec_asesoria.honorarios * v_array(2)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  30 then ROUND(rec_asesoria.honorarios * v_array(3)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp =  40 then ROUND(rec_asesoria.honorarios * v_array(4)/100)
    WHEN rec_asesoria.codmuna <> 81 AND rec_asesoria.codemp is not null THEN ROUND(rec_asesoria.honorarios * v_array(5)/100)
    WHEN rec_asesoria.codmuna is null AND rec_asesoria.codemp is null then v_array(6)
    else 0
    end;
    
    rec_asesoria.asig_eval :=
    CASE 
    WHEN rec_asesoria.puntaje BETWEEN 70 AND 120 then ROUND(rec_asesoria.honorarios * v_array_eval(1)/100)
    WHEN rec_asesoria.puntaje BETWEEN 121 AND 249 then ROUND(rec_asesoria.honorarios * v_array_eval(2)/100)
    WHEN rec_asesoria.puntaje BETWEEN 230 AND 339 then ROUND(rec_asesoria.honorarios * v_array_eval(3)/100)
    WHEN rec_asesoria.puntaje BETWEEN 350 AND 470 then ROUND(rec_asesoria.honorarios * v_array_eval(4)/100)
    WHEN rec_asesoria.puntaje BETWEEN 480 AND 600 then ROUND(rec_asesoria.honorarios * v_array_eval(5)/100)
    end;
    
  rec_asesoria.asig_tipo_cont := 
    CASE
    WHEN rec_asesoria.contrato = 4 then ROUND(rec_asesoria.honorarios * v_array_cont(1)/100)
    WHEN rec_asesoria.contrato = 3 then ROUND(rec_asesoria.honorarios * v_array_cont(2)/100)
    WHEN rec_asesoria.contrato = 2 then ROUND(rec_asesoria.honorarios * v_array_cont(3)/100)
    WHEN rec_asesoria.contrato = 1 then ROUND(rec_asesoria.honorarios * v_array_cont(4)/100)
    end;
 
 rec_asesoria.asig_profesion:=
    CASE
    WHEN rec_asesoria.cod_prof = 1 then ROUND(rec_asesoria.sueldo * v_array_prof(1)/100)
    WHEN rec_asesoria.cod_prof = 2 then ROUND(rec_asesoria.sueldo * v_array_prof(2)/100)
    WHEN rec_asesoria.cod_prof = 3 then ROUND(rec_asesoria.sueldo * v_array_prof(3)/100)
    WHEN rec_asesoria.cod_prof = 4 then ROUND(rec_asesoria.sueldo * v_array_prof(4)/100)
    WHEN rec_asesoria.cod_prof = 5 then ROUND(rec_asesoria.sueldo * v_array_prof(5)/100)
    WHEN rec_asesoria.cod_prof = 6 then ROUND(rec_asesoria.sueldo * v_array_prof(6)/100)
    WHEN rec_asesoria.cod_prof = 7 then ROUND(rec_asesoria.sueldo * v_array_prof(7)/100)
    WHEN rec_asesoria.cod_prof = 8 then ROUND(rec_asesoria.sueldo * v_array_prof(8)/100)
    end;

    rec_asesoria.total:= 
    rec_asesoria.asig_mov + rec_asesoria.asig_eval +
    rec_asesoria.asig_tipo_cont +rec_asesoria.asig_profesion;
 /*
 DBMS_OUTPUT.PUT_LINE('mes '||rec_asesoria.mes||' año '||rec_asesoria.anno||
 ' run '||rec_asesoria.run||' nombre '||rec_asesoria.nombre||' profesion '||
 rec_asesoria.profesion||' n° asesorias '||rec_asesoria.nro_ases||' honorarios '||rec_asesoria.honorarios||
 ' codemp '|| rec_asesoria.codemp ||' codmuna ' || rec_asesoria.codmuna||
 ' asig_mov '||rec_asesoria.asig_mov || ' ASIGNACION PUNTAJE '||rec_asesoria.asig_eval || ' CONTRATO '||rec_asesoria.asig_tipo_cont||
 ' asig profesion '|| rec_asesoria.asig_profesion||' total '||rec_asesoria.total);
 */
open cur_resumen(rec_asesoria.run);
loop
FETCH cur_resumen INTO 
rec_resumen.total_asesorias,
  rec_resumen.total_honorarios,
  rec_resumen.profesion; 



rec_resumen.annomes_proceso := :b_anno_proceso ||'0'|| :b_mes_proceso;

rec_resumen.profesion := rec_asesoria.profesion;
--rec_resumen.total_asesorias := select count(numrun_prof) from asesoria;


--rec_resumen.total_asesorias := sum(rec_asesoria.nro_ases);




exit when cur_resumen%notfound;
dbms_output.put_line(rec_resumen.total_asesorias||' '|| rec_resumen.total_honorarios||' '|| rec_resumen.profesion );
end loop;
close cur_resumen;

end loop;
close cur_general;

END;
/

SELECT 
COUNT(ases.inicio_asesoria),
SUM(ASES.HONORARIO),
prosion.nombre_profesion 
FROM ASESORIA ASES
JOIN PROFESIONAL PROF ON (ases.numrun_prof=prof.numrun_prof)
JOIN PROFESION PROSION ON (prosion.cod_profesion=prof.cod_profesion) 
WHERE EXTRACT(YEAR FROM ASES.inicio_asesoria)=2021 AND
EXTRACT(MONTH FROM ASES.inicio_asesoria)=06
group by prosion.nombre_profesion;

--------------------------------------------------------------


--ULTIMO EN CASA



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

    TYPE V_array_type IS VARRAY(6) of number;
   v_array V_array_type := V_array_type(2,4,5,7,9,25000);

    TYPE V_array_type2 IS VARRAY(5) of number;
   v_array_eval V_array_type2 := V_array_type2(4,6,8,10,12);
   
    TYPE V_array_type3 IS VARRAY(4) of number;
   v_array_cont V_array_type3 := V_array_type3(5,5,10,15);

   TYPE V_array_type4 IS VARRAY(8) of number;
   v_array_prof V_array_type4 := V_array_type4(12.3 ,8 ,14.36 ,21.34 ,14.32 ,22.44 ,12.36 ,18.23);
-------------------------------------------------------------------------------------------------------------
    TYPE asesoria_type IS RECORD( -- TYPE padre
    mes number,
    anno number,
    run number,
    nombre varchar2(80),
    profesion varchar2(50),
    nro_ases number,
    honorarios number,
    asig_mov number,
    asig_eval number,
    asig_tipo_cont number,
    asig_profesion number,
    total_asig_prof number,
    codemp number,
    codmuna number, 
    sueldo number,
    cod_prof number,
    porc_prof number,
    puntaje number,
    contrato number,
    total number
    );
    rec_asesorias asesoria_type; --TYPE PADRE

  CURSOR cur_asesorias is -- CURSOR PADRE
  
(SELECT DISTINCT
     EXTRACT(MONTH FROM ases.inicio_asesoria) as mes_proceso,
     EXTRACT(YEAR FROM ases.inicio_asesoria) as anno_proceso,
     ases.numrun_prof as numrun_prof,
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno as nombre_profesional, 
     prosion.nombre_profesion as profesion,
     count(ases.numrun_prof) as nro_ases,
     sum(ases.honorario) as honorarios,
     co.codemp_comuna as codemp,
    co.cod_comuna as codmuna,
    prof.puntaje as puntaje,
    prof.cod_tpcontrato as contrato,
    prosion.cod_profesion as cod_prof,
    prof.sueldo as sueldo
from asesoria ases
     INNER JOIN profesional prof
     on (ases.numrun_prof=prof.numrun_prof)
     INNER JOIN PROFESION prosion ON (prosion.cod_profesion=prof.cod_profesion)
     INNER JOIN COMUNA co on (co.cod_comuna=prof.cod_comuna)
WHERE extract(month from inicio_asesoria)=:b_mes_proceso
     AND extract(YEAR FROM inicio_asesoria)=:b_anno_proceso
group by 
     EXTRACT(MONTH FROM ases.inicio_asesoria),
     EXTRACT(YEAR FROM ases.inicio_asesoria),
     ases.numrun_prof, 
     prof.nombre||' '||prof.appaterno||' '||prof.apmaterno, 
     prosion.nombre_profesion,
     co.codemp_comuna,
     co.cod_comuna, 
     prof.puntaje,
     cod_tpcontrato,
     prosion.cod_profesion,
     prof.sueldo)
    order by ases.numrun_prof;
  --------------------------------------------------------HIJO--------------------------------HIJO  
     TYPE profesional_type IS RECORD( -- TYPE hijo
    annomes_proceso number,
    anno number,
    mes number,
    run number,
    total_asesorias number,
    total_honorarios number,
    total_asigmov number,
    total_asigeval number,
    total_asigtipocont number,
    total_asigprofesion number,
    total_asignaciones number,
    codigo_profesion number);
rec_profesional profesional_type; -- VARIABLE COMPUESTA hijo
--------------------------------------------------------------------------------------CURSOR HIJO
CURSOR cur_profesional(cod_prosion number) is -- CURSOR hijo
-- FILTRAR CON TABLA DUAL MES Y ANNO
(SELECT DISTINCT
prof.numrun_prof
from profesional prof
WHERE cod_profesion=cod_prosion

--GROUP BY cod_prosion
)order by prof.numrun_prof;
    
 -------------------------------------------------BEGIN---------------------------------------------------
 BEGIN
    FOR i IN cur_asesorias
    loop     

     rec_asesorias.mes:= i.mes_proceso;
     rec_asesorias.anno:= i.anno_proceso;
     rec_asesorias.run:= i.numrun_prof;
     rec_asesorias.nombre:= i.nombre_profesional;
     rec_asesorias.profesion:= i.profesion;
     rec_asesorias.nro_ases:= i.nro_ases;
     rec_asesorias.honorarios:= i.honorarios;
     rec_asesorias.codemp:= i.codemp;
     rec_asesorias.codmuna:= i.codmuna;
     rec_asesorias.puntaje:= i.puntaje;
     rec_asesorias.contrato:= i.contrato;
     rec_asesorias.cod_prof:= i.cod_prof; -- CODIGO DE PROFESION PARAMETRO CURSOR HIJO
     rec_asesorias.sueldo:= i.sueldo;
    
 
 rec_asesorias.asig_mov := 
    CASE
    WHEN rec_asesorias.codmuna <> 81 AND rec_asesorias.codemp =  10 then ROUND(rec_asesorias.honorarios * v_array(1)/100)
    WHEN rec_asesorias.codmuna <> 81 AND rec_asesorias.codemp =  20 then ROUND(rec_asesorias.honorarios * v_array(2)/100)
    WHEN rec_asesorias.codmuna <> 81 AND rec_asesorias.codemp =  30 then ROUND(rec_asesorias.honorarios * v_array(3)/100)
    WHEN rec_asesorias.codmuna <> 81 AND rec_asesorias.codemp =  40 then ROUND(rec_asesorias.honorarios * v_array(4)/100)
    WHEN rec_asesorias.codmuna <> 81 AND rec_asesorias.codemp is not null THEN ROUND(rec_asesorias.honorarios * v_array(5)/100)
    WHEN rec_asesorias.codmuna is null AND rec_asesorias.codemp is null then v_array(6)
    else 0
    end;
    
    rec_asesorias.asig_eval :=
    CASE 
    WHEN rec_asesorias.puntaje BETWEEN 70 AND 120 then ROUND(rec_asesorias.honorarios * v_array_eval(1)/100)
    WHEN rec_asesorias.puntaje BETWEEN 121 AND 249 then ROUND(rec_asesorias.honorarios * v_array_eval(2)/100)
    WHEN rec_asesorias.puntaje BETWEEN 230 AND 339 then ROUND(rec_asesorias.honorarios * v_array_eval(3)/100)
    WHEN rec_asesorias.puntaje BETWEEN 350 AND 470 then ROUND(rec_asesorias.honorarios * v_array_eval(4)/100)
    WHEN rec_asesorias.puntaje BETWEEN 480 AND 600 then ROUND(rec_asesorias.honorarios * v_array_eval(5)/100)
    end;
    
  rec_asesorias.asig_tipo_cont := 
    CASE
    WHEN rec_asesorias.contrato = 4 then ROUND(rec_asesorias.honorarios * v_array_cont(1)/100)
    WHEN rec_asesorias.contrato = 3 then ROUND(rec_asesorias.honorarios * v_array_cont(2)/100)
    WHEN rec_asesorias.contrato = 2 then ROUND(rec_asesorias.honorarios * v_array_cont(3)/100)
    WHEN rec_asesorias.contrato = 1 then ROUND(rec_asesorias.honorarios * v_array_cont(4)/100)
    end;
 
 rec_asesorias.asig_profesion:=
    CASE
    WHEN rec_asesorias.cod_prof = 1 then ROUND(rec_asesorias.sueldo * v_array_prof(1)/100)
    WHEN rec_asesorias.cod_prof = 2 then ROUND(rec_asesorias.sueldo * v_array_prof(2)/100)
    WHEN rec_asesorias.cod_prof = 3 then ROUND(rec_asesorias.sueldo * v_array_prof(3)/100)
    WHEN rec_asesorias.cod_prof = 4 then ROUND(rec_asesorias.sueldo * v_array_prof(4)/100)
    WHEN rec_asesorias.cod_prof = 5 then ROUND(rec_asesorias.sueldo * v_array_prof(5)/100)
    WHEN rec_asesorias.cod_prof = 6 then ROUND(rec_asesorias.sueldo * v_array_prof(6)/100)
    WHEN rec_asesorias.cod_prof = 7 then ROUND(rec_asesorias.sueldo * v_array_prof(7)/100)
    WHEN rec_asesorias.cod_prof = 8 then ROUND(rec_asesorias.sueldo * v_array_prof(8)/100)
    end;

    rec_asesorias.total:= 
    rec_asesorias.asig_mov + rec_asesorias.asig_eval +
    rec_asesorias.asig_tipo_cont +rec_asesorias.asig_profesion;
 /*
 DBMS_OUTPUT.PUT_LINE('mes '||rec_asesorias.mes||' año '||rec_asesorias.anno||
 ' run '||rec_asesorias.run||' nombre '||rec_asesorias.nombre||' profesion '||
 rec_asesorias.profesion||' n° asesorias '||rec_asesorias.nro_ases||' honorarios '||rec_asesorias.honorarios||
 ' codemp '|| rec_asesorias.codemp ||' codmuna ' || rec_asesorias.codmuna||
 ' asig_mov '||rec_asesorias.asig_mov || ' ASIGNACION PUNTAJE '||rec_asesorias.asig_eval || ' CONTRATO '||rec_asesorias.asig_tipo_cont||
 ' asig profesion '|| rec_asesorias.asig_profesion||' total '||rec_asesorias.total);
*/
--DBMS_OUTPUT.PUT_LINE(i.cod_prof||' '||rec_asesorias.cod_prof);
for reg in cur_profesional(rec_asesorias.cod_prof) LOOP

  --rec_profesional.codigo_profesion:= reg.cod_prof; -- CODIGO DE PROFESION PARAMETRO CURSOR HIJO 
 --rec_profesional.run := reg.numrun_prof;
 --rec_profesional.codigo_profesion:= reg.cod_prof ;
 --DBMS_OUTPUT.PUT_LINE(' rut hijo '||rec_profesional.run||'codigo profesion '||rec_profesional.codigo_profesion);
DBMS_OUTPUT.PUT_LINE(rec_asesorias.cod_prof||' '||rec_asesorias.run||' '||reg.numrun_prof);
--exit when cur_profesional%rowcount <2;

--DBMS_OUTPUT.PUT_LINE(reg.cod_prof||rec_asesorias.cod_prof||' '||rec_asesorias.total);
end loop;
 
end loop;
END;
/


