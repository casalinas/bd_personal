
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