--preg.1
--caso1 con for
set serveroutput on;
DECLARE
   -- cursor que recupera los viñateros o productores
   CURSOR c1 IS
   SELECT *
   FROM productor
   where id_productor in (select id_productor
                          from producto);
   -- cursor que recupera productos de cada viñatero
   -- recibe como parámetro la id del productor
   CURSOR c2 (n NUMBER) IS
   SELECT *
   FROM producto
   WHERE id_productor = n;
   counter number := 0;
BEGIN
   FOR r1 IN c1 LOOP
      dbms_output.put_line('####### LISTA DE VINOS DE LA VIÑA ' || '"' || UPPER(r1.nom_productor || '"'));
      dbms_output.put_line(CHR(13));   
      dbms_output.put_line(lpad('-',65,'-'));
      dbms_output.put_line('  ID  NOMBRE PRODUCTO      STOCK  PRECIO ACTUAL   NUEVO PRECIO');
      dbms_output.put_line(lpad('-',65,'-'));
      counter := 0;
      FOR r2 IN c2 (r1.id_productor) LOOP
         counter := counter + 1;       
             dbms_output.put_line(r2.id_producto
                || ' ' || RPAD(r2.nom_producto, 20,' ')
                || ' ' || TO_CHAR(r2.stock,'999')
                || ' ' || rpad(TO_CHAR(r2.precio, '$9G999G999'),15, ' ')
                || ' ' || TO_CHAR(r2.precio * 1.07, '$9G999G999'));
      END LOOP;      
      dbms_output.put_line(lpad('-',65,'-'));      
      dbms_output.put_line('Total de productos en tienda: ' || counter);      
      dbms_output.put_line(CHR(12));
   END LOOP;
 END;

--preg.1
--caso 1 con loop
set serveroutput on;
declare
  --cursor que recupera los viñateros o productores
  cursor c1 is
    select * from productor
    where id_productor in (select id_productor from producto);
  r1 c1%ROWTYPE;
    
  --cursor que recupera productos de cada viñatero
  --recibe como parámetro la id del productor
  cursor c2 (n in number) is
    select * from producto
    where id_productor = n;
  r2 c2%ROWTYPE; 
  counter number := 0;
  n number;
begin
  open c1;
  loop
    fetch c1 into r1;
    EXIT WHEN c1%NOTFOUND;
      dbms_output.put_line('####### LISTA DE VINOS DE LA VIÑA ' || '"' || UPPER(r1.nom_productor || '"'));
      dbms_output.put_line(CHR(13));   
      dbms_output.put_line(lpad('-',65,'-'));
      dbms_output.put_line('  ID  NOMBRE PRODUCTO      STOCK  PRECIO ACTUAL   NUEVO PRECIO');
      dbms_output.put_line(lpad('-',65,'-'));
      counter := 0;
      
      open c2(r1.id_productor);
      loop
      fetch c2 into r2;
      EXIT WHEN c2%NOTFOUND;
        counter := counter + 1;       
        dbms_output.put_line(r2.id_producto
                || ' ' || RPAD(r2.nom_producto, 20,' ')
                || ' ' || TO_CHAR(r2.stock,'999')
                || ' ' || rpad(TO_CHAR(r2.precio, '$9G999G999'),15, ' ')
                || ' ' || TO_CHAR(r2.precio * 1.07, '$9G999G999'));
      end loop;
      close c2;
      dbms_output.put_line(lpad('-',65,'-'));      
      dbms_output.put_line('Total de productos en tienda: ' || counter);      
      dbms_output.put_line(CHR(12));
  end loop;
end;

--preg.1
--caso 1 while
set serveroutput on;
declare
  --cursor que recupera los viñateros o productores
  cursor c1 is
    select * from productor
    where id_productor in (select id_productor from producto);
  r1 c1%ROWTYPE;
    
  --cursor que recupera productos de cada viñatero
  --recibe como parámetro la id del productor
  cursor c2 (n in number) is
    select * from producto
    where id_productor = n;
  
  type reg_r2 is record
  (id_producto number(6),
  nom_producto varchar2(100),
  crianza varchar2(200),
  maridaje varchar2(300),
  temperatura number(2),
  stock number(4),
  precio number(7),
  id_linea number(2),
  id_cepa number(2),
  id_productor number(4));
  r2 reg_r2;
  
  counter number := 0;
  n number;
begin
  open c1;
  fetch c1 into r1;
  while c1%FOUND
  loop
    dbms_output.put_line('####### LISTA DE VINOS DE LA VIÑA ' || '"' || UPPER(r1.nom_productor || '"'));
    dbms_output.put_line(CHR(13));   
    dbms_output.put_line(lpad('-',65,'-'));
    dbms_output.put_line('  ID  NOMBRE PRODUCTO      STOCK  PRECIO ACTUAL   NUEVO PRECIO');
    dbms_output.put_line(lpad('-',65,'-'));
    counter := 0;
      
    open c2(r1.id_productor);
    fetch c2 into r2;
    while c2%FOUND
    loop
      counter := counter + 1;       
      dbms_output.put_line(r2.id_producto
                || ' ' || RPAD(r2.nom_producto, 20,' ')
                || ' ' || TO_CHAR(r2.stock,'999')
                || ' ' || rpad(TO_CHAR(r2.precio, '$9G999G999'),15, ' ')
                || ' ' || TO_CHAR(r2.precio * 1.07, '$9G999G999'));
      fetch c2 into r2;
    end loop;
    close c2;
    dbms_output.put_line(lpad('-',65,'-'));      
    dbms_output.put_line('Total de productos en tienda: ' || counter);      
    dbms_output.put_line(CHR(12));
    fetch c1 into r1;
  end loop;
end;

--
--preg.2
--
VARIABLE b_fecha VARCHAR2(6);
EXEC :b_fecha := '052021';
VARIABLE b_impuestolimite NUMBER;
EXEC :b_impuestolimite := 90000;
DECLARE
  -- Cursor que recupera las lineas de producto
  CURSOR c_linea IS 
  SELECT nom_linea
  FROM linea
  ORDER BY nom_linea;
  
  -- cursor que recupera las ventas de productos de una linea determinada en un dia especifico
  -- en el periodo de tiempo (mes) especificado
  CURSOR c_ven (p_linea VARCHAR2) IS
  SELECT v.fec_venta, COUNT(*) pedidos,
         NVL(SUM(p.precio * dv.cantidad),0) total 
  FROM venta v JOIN detalle_venta dv ON v.id_venta = dv.id_venta
  JOIN producto p ON p.id_producto = dv.id_producto
  JOIN linea l ON l.id_linea = p.id_linea
  WHERE TO_CHAR(v.fec_venta, 'MMYYYY') = :b_fecha
  AND l.nom_linea = p_linea
  GROUP BY v.fec_venta
  ORDER BY v.fec_venta;
  
  -- Declaracion de variables escalares
  v_pct NUMBER;
  v_pctcomis NUMBER;
  v_msg VARCHAR2(300);
  v_msgusr VARCHAR2(300);
  
  v_impuestos NUMBER := 0;
  v_desctos_linea NUMBER:= 0;
  v_monto_comisiones  NUMBER := 0;  
  v_monto_delivery  NUMBER := 0;  
  v_monto_descuentos  NUMBER := 0;  
  v_monto_ventas NUMBER := 0;

  -- Acumuladores
  v_tot_numventas NUMBER := 0;
  v_tot_monto_ventas NUMBER := 0;
  v_tot_impuestos NUMBER := 0;
  v_tot_desctos_linea NUMBER:= 0;
  v_tot_comisiones  NUMBER := 0;  
  v_tot_delivery  NUMBER := 0;  
  v_tot_descuentos  NUMBER := 0;  
  v_tot_ventas NUMBER := 0;

  -- varray
  TYPE t_descuentos IS VARRAY(6) OF NUMBER;
  v_desctos t_descuentos := t_descuentos(0.19,0.17,0.15,0.13,0.11,1500);
  
  -- Excepcion para el error de usuario
  e_impuesto_limite EXCEPTION;
BEGIN
  -- borrado de los datos en las tablas
  EXECUTE IMMEDIATE 'TRUNCATE TABLE error_proceso';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_linea';
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_error';
  EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_error';
  
  -- bucle de cursor que recorre las lineas de producto
  FOR r_linea IN c_linea LOOP

     -- Ponemos a cero los acumuladores
     v_tot_numventas := 0;
     v_tot_monto_ventas := 0;
     v_tot_impuestos := 0;
     v_tot_desctos_linea := 0;
     v_tot_comisiones := 0;  
     v_tot_delivery := 0;  
     v_tot_descuentos := 0;  
     v_tot_ventas := 0;
     
     -- Bucle que recorre las ventas diarias del mes que corresponden a una linea determinada 
     FOR r_ven IN c_ven (r_linea.nom_linea) LOOP
       
         -- Recupera porcentaje de impuesto que pagan las ventas desde la tabla impuesto
         BEGIN
             SELECT pctimpuesto / 100
             INTO v_pct
             FROM impuesto
             WHERE r_ven.total BETWEEN mto_venta_inf AND mto_venta_sup;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                v_msg  := SQLERRM;
                v_pct := 0; 
                v_msgusr := 'No se encontro porcentaje de impuesto para el monto de los pedidos del dia ' || TO_CHAR(r_ven.fec_venta, 'dd/mm/yyyy');
                INSERT INTO error_proceso
                VALUES (seq_error.NEXTVAL, v_msg, v_msgusr);
             WHEN TOO_MANY_ROWS THEN    
                v_msg  := SQLERRM;
                v_pct := 0; 
                v_msgusr := 'Se encontro mas de un porcentaje de impuesto para el monto de los pedidos del dia ' || TO_CHAR(r_ven.fec_venta, 'dd/mm/yyyy');
                INSERT INTO error_proceso
                VALUES (seq_error.NEXTVAL, v_msg, v_msgusr);
         END;
         -- Calcula los impuestos de acuerdo con % recuperado 
         v_impuestos := ROUND(r_ven.total * v_pct);
        
         -- Determina los descuentos por linea usando los porcentajes disponibles mediante el varray
         v_desctos_linea := CASE INITCAP(r_linea.nom_linea)
                  WHEN 'Reserva Especial' THEN ROUND(r_ven.total * (v_desctos(1))) 
                  WHEN 'Reserva' THEN ROUND(r_ven.total * (v_desctos(2))) 
                  WHEN 'Gran Reserva' THEN ROUND(r_ven.total * (v_desctos(3))) 
                  WHEN 'Selección' THEN ROUND(r_ven.total * (v_desctos(4))) 
                  ELSE ROUND(r_ven.total * (v_desctos(5))) 
                END;
     
         -- Creamos el escenario para interceptar el error de usuario
         -- el monto de los impuestos calculados no puede exceder de los $90.000 
         BEGIN
            IF v_impuestos > :b_impuestolimite THEN
               -- levantamos la excepcion
               RAISE e_impuesto_limite; 
            END IF;
         EXCEPTION
            WHEN e_impuesto_limite THEN
                v_msg := 'ORA-20001 Monto de impuesto sobrepasa el limite permitido';
                INSERT INTO error_proceso
                VALUES (seq_error.NEXTVAL, v_msg,
                       'Se reemplaza el monto de impuesto calculada de '
                       || TO_CHAR(v_impuestos, '$999G999') || ' por el monto limite de $'
                       || TO_CHAR(:b_impuestolimite, '$99G999'));
                v_impuestos := :b_impuestolimite;                     
           END;

        -- Determina el monto diario que se gasta en delivery
        v_monto_delivery := v_desctos(6) * r_ven.pedidos;  

        -- Determina el monto total de los descuentos
        v_monto_descuentos := v_impuestos + v_desctos_linea + v_monto_delivery;  

        -- Determina el monto final de la venta diaria
        v_monto_ventas := r_ven.total - v_monto_descuentos;
                     
         -- Acumula en las variables sumadoras
         v_tot_numventas := v_tot_numventas  + r_ven.pedidos;
         v_tot_monto_ventas := v_tot_monto_ventas  + r_ven.total;
         v_tot_impuestos := v_tot_impuestos  + v_impuestos;
         v_tot_desctos_linea := v_tot_desctos_linea  + v_desctos_linea;
         v_tot_comisiones := v_tot_comisiones  + v_monto_comisiones;
         v_tot_delivery := v_tot_delivery  + v_monto_delivery;
         v_tot_descuentos := v_tot_descuentos  + v_monto_descuentos;
         v_tot_ventas := v_tot_ventas  + v_monto_ventas;
         
     END LOOP;
     --   Inserta en la tabla de resumen
     INSERT INTO resumen_linea
     VALUES (r_linea.nom_linea, v_tot_numventas, v_tot_monto_ventas,v_tot_impuestos, v_tot_desctos_linea,
              v_tot_delivery, v_tot_descuentos, v_tot_ventas);
  END LOOP;
  -- Confirma los cambios 
  COMMIT;
END;

--select * from resumen_linea;
