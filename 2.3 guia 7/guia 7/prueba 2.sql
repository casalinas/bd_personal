
--variableiables bind--


variableIABLE b_fecha_proceso variableCHAR2(10);
variableIABLE b_valor_limite NUMBER;

executeUTE :b_valor_limite := 410000;

executeUTE :b_fecha_proceso := '10/06/2021';



--variableray--


--se crean variableray para los porcentajes de movilizacion y traslado--
CREATE OR REPLACE TYPE tipo_ptc_mov IS variableRAY(5) OF NUMBER(2,2) NOT NULL;
/
--se crean variableray para monto fijo de traslado--
CREATE OR REPLACE TYPE tipo_monto_fijo IS variableRAY(1) OF NUMBER NOT NULL;
/
SET SERVEROUTPUT ON;


--objetivo poblar la tabla detalle_asignacion_mes--

DECLARE

    CURSOR c1 IS
        SELECT cod_profesion, nombre_profesion 
        FROM profesion 
        ORDER BY nombre_profesion ASC;
        
--cursor principal--
    CURSOR c2(p_profesionid NUMBER) IS 
        SELECT numrun_prof, nombre || ' ' || appaterno AS "nombre", cod_comuna, 
        puntaje, cod_tpcontrato, sueldo
        FROM profesional 
        WHERE cod_profesion = p_profesionid
        ORDER BY nombre || ' ' || appaterno ASC;
        
--registros--
    reg_c1 c1%rowtype;
    reg_c2 c2%rowtype;
    reg_detalle detalle_asignacion_mes%rowtype;
    reg_resumen resumen_mes_profesion%rowtype;
    reg_errores errores_p%rowtype;

--variableray para porcentajes de movilizacion--
    t_ptc_mov tipo_ptc_mov := tipo_ptc_mov(0.02,0.04,0.05,0.07,0.09);
    
--variableray para monto fijo--
    t_monto tipo_monto_fijo := tipo_monto_fijo(25000);
    
--variableiables--
    v_empid comuna.codemp_comuna%TYPE;
    v_ptc_mov NUMBER(2,2);
    v_ptc_eval NUMBER(2,2);
    v_ptc_tp NUMBER(2,2);
    v_ptc_p NUMBER(10,10);
    
--excepcion usuario--
    ex_valor_limite EXCEPTION;
    PRAGMA exception_init(ex_valor_limite, -20001);
    
BEGIN

--truncamiento de tabla tiempo de ejecucion--
    executeUTE IMMEDIATE 'TRUNCATE TABLE DETALLE_ASIGNACION_MES';
    executeUTE IMMEDIATE 'TRUNCATE TABLE RESUMEN_MES_PROFESION';
    executeUTE IMMEDIATE 'TRUNCATE TABLE ERRORES_P';
    executeUTE IMMEDIATE 'DROP SEQUENCE SQ_ERROR';
    executeUTE IMMEDIATE 'CREATE SEQUENCE SQ_ERROR';
    COMMIT;

--recorremos las profesiones--
    FOR reg_c1 IN c1
    LOOP
        
    BEGIN            
--segundo cursor recorre los profesionales--
        FOR reg_c2 IN c2(reg_c1.cod_profesion)
        LOOP
            BEGIN
--procesamiento de los profesionales--
    reg_detalle.mes_proceso := to_number(to_char(TO_DATE(:b_fecha_proceso),'MM'));
    reg_detalle.anno_proceso  := to_number(to_char(TO_DATE(:b_fecha_proceso),'YYYY'));
    reg_detalle.numrun_prof := reg_c2.numrun_prof;
    reg_detalle.nombre_profesional := reg_c2."nombre";
                    
--obtenemos la profesion--
    reg_detalle.profesion := reg_c1.nombre_profesion;

                
--contamos la cantidad de asesorias--
    SELECT nvl(COUNT(inicio_asesoria),0)  INTO reg_detalle.nro_asesorias
    FROM asesoria WHERE numrun_prof = reg_c2.numrun_prof AND to_char(inicio_asesoria, 'MM/YYYY') = to_char(TO_DATE(:b_fecha_proceso),'MM/YYYY');
                    
--sumamos los honorarios--
    SELECT nvl(SUM(honorario),0) INTO reg_detalle.honorarios
    FROM asesoria WHERE numrun_prof = reg_c2.numrun_prof AND  to_char(inicio_asesoria, 'MM/YYYY') = to_char(TO_DATE(:b_fecha_proceso),'MM/YYYY');
        
--comuna distinta a la providencia--
    IF reg_c2.cod_comuna <> 81 THEN
                    
    BEGIN
                
--rescatamos el codigo empresarial--
    SELECT codemp_comuna INTO v_empid 
    FROM comuna
    WHERE cod_comuna = reg_c2.cod_comuna;
                        
--evaluamos el codigo empresarial--
    v_ptc_mov :=  CASE v_empid
    WHEN 10 THEN t_ptc_mov(1)
    WHEN 20 THEN t_ptc_mov(2)
    WHEN 30 THEN t_ptc_mov(3)
    WHEN 40 THEN t_ptc_mov(4)
    ELSE 
    t_ptc_mov(5)
    END;
                                        
--calculamos a partir de sus honorarios--
    reg_detalle.asig_mov := round(reg_detalle.honorarios * v_ptc_mov,0);
                    
--en caso de no encontrar un codigo empresarial para la comuna mencionada le otorgamos $25.000--                   
    EXCEPTION
    WHEN no_data_found THEN

--asignacion a monto fijo--
    reg_detalle.asig_mov := t_monto(1);
        END;        
                        
        ELSE 
        reg_detalle.asig_mov := 0;
        END IF;
                    
                    
    BEGIN
                        
--tabla de tramo evaluacion--
    SELECT porcentaje/100 INTO v_ptc_eval FROM evaluacion WHERE reg_c2.puntaje BETWEEN eva_punt_min AND eva_punt_max;
    reg_detalle.asig_eval := round(reg_detalle.honorarios * v_ptc_eval,0);
                    
    EXCEPTION
    WHEN no_data_found THEN
    reg_errores.error_id := sq_error.NEXTVAL;
    reg_errores.ora_msg :=  sqlerrm;
    reg_errores.usr_msg := 'No se encontró el porcentaje de evaluacion para el run '|| reg_c2.numrun_prof ||'.' ;
        INSERT INTO errores_p VALUES reg_errores;
        reg_detalle.asig_eval := 0;
                
         WHEN too_many_rows THEN
           reg_errores.error_id := sq_error.NEXTVAL;
           reg_errores.ora_msg :=  sqlerrm;
           reg_errores.usr_msg := 'Se encontró más de un porcentaje de evaluacion para el run '|| reg_c2.numrun_prof ||'.' ;
           INSERT INTO errores_p VALUES reg_errores;
            reg_detalle.asig_eval := 0;
END;

    BEGIN
--incentivo tipo contrato--
       SELECT incentivo / 100 INTO v_ptc_tp
          FROM tipo_contrato 
             WHERE cod_tpcontrato = reg_c2.cod_tpcontrato;
                        
--calculo--
    reg_detalle.asig_tipocont := round(reg_detalle.honorarios * v_ptc_tp,0);
    
      EXCEPTION
          WHEN no_data_found THEN
            reg_errores.error_id := sq_error.NEXTVAL;
            reg_errores.ora_msg :=  sqlerrm;
            reg_errores.usr_msg := 'No se encontró el porcentaje de tipo contrato para el run '|| reg_c2.numrun_prof ||'.' ;
            INSERT INTO errores_p VALUES reg_errores;
            reg_detalle.asig_tipocont := 0;        
       END;
                    
         BEGIN
--asignacion segun profesion--
         SELECT asignacion/100 INTO v_ptc_p
           FROM profesion 
           WHERE cod_profesion = reg_c1.cod_profesion;
                        
--calculos--
  reg_detalle.asig_profesion := round(reg_c2.sueldo * v_ptc_p,0);
                        
  EXCEPTION
  WHEN no_data_found THEN
    reg_detalle.asig_profesion := 0;
    END;
                    
    BEGIN
--suma total a asignaciones--

reg_detalle.total_asignaciones_profesional :=  reg_detalle.asig_mov + reg_detalle.asig_eval + reg_detalle.asig_tipocont + reg_detalle.asig_profesion;
IF reg_detalle.total_asignaciones_profesional >  :b_valor_limite THEN
raise_application_error(-20001,'Monto total de las asignaciones para el run Nro. ' || reg_c2.numrun_prof || ' sobrepasó el límite permitido.');

END IF;
    EXCEPTION
     WHEN ex_valor_limite THEN
        dbms_output.put_line('LIMITE SUPERADO');
         reg_errores.error_id := sq_error.NEXTVAL;
         reg_errores.ora_msg :=  sqlerrm;
         reg_errores.usr_msg := 'Se reemplazó el monto total de la asignaciones calculadas de  $' || reg_detalle.total_asignaciones_profesional || ' por el monto límite de $ ' ||:b_valor_limite||'.' ;
         reg_detalle.total_asignaciones_profesional := :b_valor_limite;
                    INSERT INTO errores_p VALUES reg_errores;
                 END;
                 INSERT INTO detalle_asignacion_mes VALUES reg_detalle;
                 COMMIT;
                    
EXCEPTION
 WHEN OTHERS THEN
     dbms_output.put_line('ERROR EN EL 2DO CURSOR' || sqlerrm);
            END;
            END LOOP;
            
--segunda parte resumen_mes_profesion--
        reg_resumen.annomes_proceso := to_number(to_char(TO_DATE(:b_fecha_proceso),'YYYYMM'));
        reg_resumen.profesion := reg_c1.nombre_profesion;
            
            
     
--contamos asesorias--
        SELECT nvl(SUM(nro_asesorias),0) INTO reg_resumen.total_asesorias FROM detalle_asignacion_mes WHERE profesion = reg_c1.nombre_profesion;
            
--sumamos honorarios--
        SELECT nvl(SUM(honorarios),0) INTO reg_resumen.total_honorarios FROM detalle_asignacion_mes WHERE profesion = reg_c1.nombre_profesion;
            
--sumamos asignaciones por cada movilizacion--
        SELECT nvl(SUM(asig_mov),0) INTO reg_resumen.total_asigmov FROM detalle_asignacion_mes WHERE profesion = reg_c1.nombre_profesion;
            
--sumamos asignaciones por cada evaluacion--
        SELECT nvl(SUM(asig_eval),0) INTO reg_resumen.total_asigeval FROM detalle_asignacion_mes WHERE profesion = reg_c1.nombre_profesion;
            
--sumamos asignaciones por los tipo de contrato--
        SELECT nvl(SUM(asig_tipocont),0) INTO reg_resumen.total_asigtipocont FROM detalle_asignacion_mes WHERE profesion = reg_c1.nombre_profesion;
            
--sumamos asignaciones por cada profesion--
        SELECT nvl(SUM(asig_profesion),0) INTO reg_resumen.total_asigprofesion FROM detalle_asignacion_mes WHERE profesion = reg_c1.nombre_profesion;
            
--sumamos el total de asignaciones--
        SELECT nvl(SUM(total_asignaciones_profesional),0) INTO reg_resumen.total_asignaciones FROM detalle_asignacion_mes WHERE profesion = reg_c1.nombre_profesion;           
            
--insertamos los registros en la tabla resumen--
        INSERT INTO resumen_mes_profesion VALUES reg_resumen;
        COMMIT; 
            
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error en las iteraciones' || sqlerrm);
END;
        
END LOOP;
    
END;
/



-------------------------------




   
   
   
   variable ini_tramo1 number;
   execute :ini_tramo1 := 500000; --300 cada 100.000
    
   variable fin_tramo1 number ;
   execute :fin_tramo1 := 700000;
     
   variable ini_tramo2 number ;
   execute :ini_tramo2 := 700001; --550 cada 100.000
    
   variable fin_tramo2 number; 
   execute :fin_tramo2 := 900000;
     
    variable tramo3 number;
    execute :tramo3 := 9000001; --700 cada 100.000

DECLARE 
    CREATE OR REPLACE TYPE v_array1 IS variableRAY(3) OF NUMBER(3) NOT NULL;
        variableray_extra v_array1 := v_array1 (300,550,700); 
   
    CREATE OR REPLACE TYPE v_array2 IS variableRAY(1) OF NUMBER(3) NOT NULL;
      variableray_fijo v_array2 := v_array2 (250);
          
    
     
     
     
     -- cursor para tarjeta
       CURSOR c1 IS
        SELECT nro_tarjeta, numrun, fecha_solic_tarjeta, dia_pago_mensual,
        cupo_compra, cupo_super_avance, cupo_disp_compra, cupo_disp_sp_avance
        FROM TARJETA_CLIENTE;
        --registro tipo cursor
         reg_c1 c1%rowtype;
        
        
--cursor principal para clientes
    CURSOR c2(cli_run NUMBER) IS 
        SELECT numrun, dvrun, pnombre, snombre, appaterno, apmaterno,
        fecha_nacimiento, fecha_inscripcion, correo, fono_contacto,
        direccion, cod_region, cod_provincia, cod_comuna, cod_prof_ofic,
        cod_tipo_cliente
        FROM CLIENTE 
        WHERE numrun = cli_run;
        
        -- registros

 
  TYPE rec_cur2 IS RECORD(
    numrun number,
    dvrun variablechar2(1),
    pnombre variablechar2(50),
    snombre variablechar2(50),
    appaterno variablechar2(50),
    apmaterno variablechar2(50),
    fecha_nacimiento date,
    fecha_inscripcion date, 
    correo variablechar2(100),
    fono_contacto number,
    direccion variablechar2(200),
    cod_region number, 
    cod_provincia number, 
    cod_comuna number,
    cod_prof_ofic number,
    cod_tipo_cliente number);
    
    rec_c2 rec_cur2;
 
 

BEGIN
executeUTE IMMEDIATE 'truncate table DETALLE_APORTE_SBIF';
executeUTE IMMEDIATE 'truncate table DETALLE_PUNTOS_TARJETA_CATB';
executeUTE IMMEDIATE 'truncate table RESUMEN_PUNTOS_TARJETA_CATB';
executeUTE IMMEDIATE 'truncate table DETALLE_PUNTOS_TARJETA_CATB';
executeUTE IMMEDIATE 'truncate table BALANCE_ANUAL_DETALLE_TRANSAC';
COMMIT;

    FOR reg_c1 in c1
    LOOP 
    
    BEGIN
    for rec_c2 in c2(reg_c1.numrun)
     
    
    
    
    end;
    END LOOP;
END;