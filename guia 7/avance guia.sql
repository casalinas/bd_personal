SET SERVEROUTPUT ON;

DECLARE

CURSOR cur is (SELECT   c.numrun AS rut,c.dvrun AS dvrut,tc.nro_tarjeta AS nro_tarjeta,c.cod_tipo_cliente AS tipo_cliente, 
                        ttc.nro_transaccion AS nro_trans, ttc.fecha_transaccion AS fecha_trans,
                        ttt.nombre_tptran_tarjeta AS tipo_trans,ttc.monto_transaccion AS monto_trans
                        FROM tarjeta_cliente tc
                        INNER JOIN cliente c
                            ON tc.numrun = c.numrun
                        INNER JOIN transaccion_tarjeta_cliente ttc
                            ON ttc.nro_tarjeta = tc.nro_tarjeta
                        INNER JOIN tipo_transaccion_tarjeta ttt
                            ON ttt.cod_tptran_tarjeta = ttc.cod_tptran_tarjeta
                          WHERE EXTRACT(YEAR FROM ttc.fecha_transaccion)=2021
                          ORDER BY ttc.fecha_transaccion)
v_contador NUMBER:=1;
v_puntos NUMBER:=0;
--VARRAY 
    TYPE vary IS VARRAY(4) OF NUMBER;
     vry_puntos vary := vary(300,550,700,250);
BEGIN
    FOR x IN cur
    LOOP
    DECLARE
    v_monto NUMBER:=x.monto_trans;
    v_tipo NUMBER:=x.tipo_cliente;
    BEGIN 
     IF v_tipo=30 OR v_tipo=40 THEN
        v_puntos:=
            CASE
              WHEN  v_monto BETWEEN 500000 AND 700000 THEN TRUNC(v_monto/100000)*vry_puntos(1)
              WHEN  v_monto BETWEEN 700001 AND 900000 THEN TRUNC(v_monto/100000)*vry_puntos(2)
              WHEN  v_monto >900000 THEN TRUNC(v_monto/100000)*vry_puntos(3)
            END;
     ELSE 
       v_puntos:=TRUNC(v_monto/100000)*(vry_puntos(4));
     END IF;
    END ;
    --Trabajamos el cursor utilizando la variable temporal
        dbms_output.put_line( v_contador||'*  RUT: '||x.rut||'-'||x.dvrut||' nro tarjeta: '||x.nro_tarjeta||' nro_trans: '||x.nro_trans  
                          ||' fecha_trans '||x.fecha_trans||' tipo_trans :'||x.tipo_trans||' monto_trans: '||x.monto_trans||' PUNTOS :'||v_puntos); 
        v_contador:=v_contador+1; 
    END LOOP;
END;

---------------------------------------------------------------------------------------------------------------------------------------


SET SERVEROUTPUT ON;

DECLARE
v_contador NUMBER:=1;
v_puntos NUMBER:=0;
--VARRAY 
    TYPE vary IS VARRAY(4) OF NUMBER;
     vry_puntos vary := vary(300,550,700,250);
--DECLARAR CURSOR
    CURSOR cur_trans IS SELECT  
                        c.numrun AS rut,c.dvrun AS dvrut,tc.nro_tarjeta AS nro_tarjeta,c.cod_tipo_cliente AS tipo_cliente, 
                        ttc.nro_transaccion AS nro_trans, ttc.fecha_transaccion AS fecha_trans,
                        ttt.nombre_tptran_tarjeta AS tipo_trans,ttc.monto_transaccion AS monto_trans
                        FROM tarjeta_cliente tc
                        INNER JOIN cliente c
                            ON tc.numrun = c.numrun
                        INNER JOIN transaccion_tarjeta_cliente ttc
                            ON ttc.nro_tarjeta = tc.nro_tarjeta
                        INNER JOIN tipo_transaccion_tarjeta ttt
                            ON ttt.cod_tptran_tarjeta = ttc.cod_tptran_tarjeta
                          WHERE EXTRACT(YEAR FROM ttc.fecha_transaccion)=2021
                          ORDER BY ttc.fecha_transaccion;
                        
     
     --Variable temporal(vacia), que guarda filas del cursor para despues trabajarla
    reg_trans cur_trans%ROWTYPE;
BEGIN
--EL CURSOR PRIMERO SE ABRE
 OPEN cur_trans;
 --Ciclo para recorrer el cursor
 LOOP
  --Recuperamos cada fila del cursor y lo vamos guardando en la variable temporal
    FETCH cur_trans INTO reg_trans;
    --SIEMPRE PONER LA CONDICION DE SALIDA
    EXIT WHEN cur_trans%notfound;
    DECLARE
    v_monto NUMBER:=reg_trans.monto_trans;
    v_tipo NUMBER:=reg_trans.tipo_cliente;
    BEGIN 
     IF v_tipo=30 OR v_tipo=40 THEN
        v_puntos:=
            CASE
              WHEN  v_monto BETWEEN 500000 AND 700000 THEN TRUNC(v_monto/100000)*vry_puntos(1)
              WHEN  v_monto BETWEEN 700001 AND 900000 THEN TRUNC(v_monto/100000)*vry_puntos(2)
              WHEN  v_monto >900000 THEN TRUNC(v_monto/100000)*vry_puntos(3)
            END;
     ELSE 
       v_puntos:=TRUNC(v_monto/100000)*(vry_puntos(4));
     END IF;
    END ;
    --Trabajamos el cursor utilizando la variable temporal
        dbms_output.put_line( v_contador||'*  RUT: '||reg_trans.rut||'-'||reg_trans.dvrut||' nro tarjeta: '||reg_trans.nro_tarjeta||' nro_trans: '||reg_trans.nro_trans  
                          ||' fecha_trans '||reg_trans.fecha_trans||' tipo_trans :'||reg_trans.tipo_trans||' monto_trans: '||reg_trans.monto_trans||' PUNTOS :'||v_puntos); 
        v_contador:=v_contador+1; 
 END LOOP;
 CLOSE cur_trans;
END;
   /
   
   
   
    -----------------------------------------------------------------------------------------------------------
   -- VERSION MIA
 truncate table DETALLE_APORTE_SBIF;
 truncate table DETALLE_PUNTOS_TARJETA_CATB;
truncate table RESUMEN_PUNTOS_TARJETA_CATB;
 truncate table DETALLE_PUNTOS_TARJETA_CATB;
 truncate table BALANCE_ANUAL_DETALLE_TRANSAC;




  
   variable ini_tramo1 number;
   execute :ini_tramo1 := 500000; 
    
   variable fin_tramo1 number;
   execute :fin_tramo1 := 700000;
     
   variable ini_tramo2 number;
   execute :ini_tramo2 := 700001; 
    
   variable fin_tramo2 number; 
   execute :fin_tramo2 := 900000;
     
    variable tramo3 number;
    execute :tramo3 := 9000001; 

DECLARE 
     TYPE v_array1 IS varray(3) OF NUMBER(3) NOT NULL;
        array_extra v_array1 := v_array1 (300,550,700); 
   
     TYPE v_array2 IS varray(1) OF NUMBER(3) NOT NULL;
      array_fijo v_array2 := v_array2 (250);
        
     
     -- cursor para tarjeta
       CURSOR c1 IS
        SELECT nro_tarjeta, numrun, fecha_solic_tarjeta, dia_pago_mensual,
        cupo_compra, cupo_super_avance, cupo_disp_compra, cupo_disp_sp_avance
        FROM TARJETA_CLIENTE;
       
        
        
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
    dvrun varchar2(1),
    pnombre varchar2(50),
    snombre varchar2(50),
    appaterno varchar2(50),
    apmaterno varchar2(50),
    fecha_nacimiento date,
    fecha_inscripcion date, 
    correo varchar2(100),
    fono_contacto number,
    direccion varchar2(200),
    cod_region number, 
    cod_provincia number, 
    cod_comuna number,
    cod_prof_ofic number,
    cod_tipo_cliente number);
    
     --variables compuestas cursores
    reg_c1 c1%rowtype; --reg c1
    rec_c2 rec_cur2; -- record c2

BEGIN
 

     FOR r1 in c1
        LOOP 
        
   

    for r2 in c2(r1.numrun)
     loop
     
    rec_c2.pnombre := r2.pnombre;
    --reg_c1.numrun 
 dbms_output.put_line(rec_c2.pnombre||' rut '||r1.numrun||' '||r1.NRO_TARJETA);
   end loop;
    
    end loop;
  

 end;