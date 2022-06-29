-- Crear el package
CREATE OR REPLACE PACKAGE pkg_remuneraciones
AS
  -- Variables
  PORCENTAJE_MOV NUMBER;
  VALOR_CARGA_FAM NUMBER;
  VALOR_MOV_EXTRA_1 NUMBER;
  VALOR_MOV_EXTRA_2 NUMBER;
  VALOR_COLACION NUMBER;
  -- Funciòn pùblica
  FUNCTION fn_bonificacion(p_years NUMBER, p_sueldo NUMBER) RETURN NUMBER;
END;

-- Body package 
CREATE OR REPLACE PACKAGE BODY pkg_remuneraciones
IS
  FUNCTION fn_bonificacion(p_years NUMBER, p_sueldo NUMBER) 
  RETURN NUMBER
  IS
    v_sql VARCHAR2(250);
    v_porcentaje porc_bonif_annos_contrato.porc_bonif%TYPE;
    v_msg_oracle VARCHAR2(500);
  BEGIN
    v_sql := 'SELECT porc_bonif FROM porc_bonif_annos_contrato WHERE :1 BETWEEN annos_inferior AND annos_superior ';
    EXECUTE IMMEDIATE v_sql
    INTO v_porcentaje
    USING p_years;
    
    RETURN ROUND(p_sueldo*v_porcentaje);
  EXCEPTION WHEN NO_DATA_FOUND THEN
    v_msg_oracle := SQLERRM;
    INSERT INTO error_proceso_remun
    VALUES(seq_error.NEXTVAL, 'Error FN_BONIFICACION al obtener porcentaje de años contratados con el valor ' 
      || p_years || ' años', v_msg_oracle);
    RETURN 0;
  END;
END;

-- Crear la FA 1
-- A petición del público vamos a construir 2 versiones una con NDS y otra sin NDS (no está en el reequerimiento, pero servirá)
CREATE OR REPLACE FUNCTION fn_asig_carga(p_rut NUMBER)
RETURN NUMBER
IS
  v_sql VARCHAR2(150);
  v_total_cargas NUMBER := 0;
BEGIN
  v_sql := 'SELECT COUNT(numrut_carga) FROM carga_familiar WHERE numrut_emp = :1';
  EXECUTE IMMEDIATE v_sql
  INTO v_total_cargas
  USING p_rut;
  RETURN v_total_cargas*pkg_remuneraciones.VALOR_CARGA_FAM;
END;

-- VERSION SIN NDS
CREATE OR REPLACE FUNCTION fn_asig_carga_X(p_rut NUMBER)
RETURN NUMBER
IS
  v_total_cargas NUMBER;
BEGIN
  SELECT COUNT(numrut_carga)
  INTO v_total_cargas
  FROM carga_familiar 
  WHERE numrut_emp = p_rut;
  RETURN v_total_cargas*pkg_remuneraciones.VALOR_CARGA_FAM;
END;
-- Crear la FA 2
CREATE OR REPLACE FUNCTION fn_comision_vtas(p_rut NUMBER, p_periodo VARCHAR2)
RETURN NUMBER
IS
  v_sql VARCHAR2(500);
  v_comision NUMBER;
BEGIN
  v_sql := 'SELECT NVL(SUM(valor_comision),0) FROM comision_venta cv JOIN boleta b ON(b.nro_boleta = cv.nro_boleta) WHERE numrut_emp = :1 AND TO_CHAR(fecha_boleta,''MM/YYYY'') = :2';
  EXECUTE IMMEDIATE v_sql
  INTO v_comision
  USING p_rut, p_periodo;
  
  RETURN v_comision;
END;
-- Crear el SP
CREATE OR REPLACE PROCEDURE sp_informe(p_fecha VARCHAR2, p_porcentaje_mov NUMBER,
p_valor_1 NUMBER, p_valor_2 NUMBER, v_carga NUMBER, v_colacion NUMBER)
IS
  CURSOR c_empleados IS
    SELECT numrut_emp, sueldo_base_emp, id_comuna, id_categoria_emp,
      TRUNC(MONTHS_BETWEEN(p_fecha, fecing_emp)/12) AS antiguedad
    FROM empleado
    ORDER BY 1;
  v_nombre_comuna comuna.nombre_comuna%TYPE;
  v_categoria categoria_empleado.desc_categoria_emp%TYPE;
  v_mov_extra NUMBER;
  v_cargas NUMBER;
  v_comision NUMBER;
  v_bonif_years NUMBER;
  
  v_movilizacion NUMBER;
  v_total NUMBER;
BEGIN
    pkg_remuneraciones.PORCENTAJE_MOV := p_porcentaje_mov;
    pkg_remuneraciones.VALOR_CARGA_FAM := v_carga;
    pkg_remuneraciones.VALOR_MOV_EXTRA_1 := p_valor_1;
    pkg_remuneraciones.VALOR_MOV_EXTRA_2 := p_valor_2;
    pkg_remuneraciones.VALOR_COLACION := v_colacion;
    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE haber_calc_mes';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE error_proceso_remun';
    FOR reg_empleado IN c_empleados LOOP
      -- Obtener el nombre de la comuna
      SELECT nombre_comuna
      INTO v_nombre_comuna
      FROM comuna
      WHERE id_comuna = reg_empleado.id_comuna;
      -- Obtener la tcategoria
      SELECT desc_categoria_emp
      INTO v_categoria
      FROM categoria_empleado
      WHERE id_categoria_emp = reg_empleado.id_categoria_emp;
      -- Calcular el valor de las cargas
      v_cargas := fn_asig_carga(reg_empleado.numrut_emp);
      -- Calcular el valor de la comisión
      v_comision := fn_comision_vtas(reg_empleado.numrut_emp, TO_CHAR(TO_DATE(p_fecha), 'MM-YYYY'));
      -- Calcular valor movilizacion
      v_mov_extra := 0;
      IF UPPER(v_categoria) <> 'VENDEDOR' THEN
        -- Comprobar la comuna
        IF INITCAP(v_nombre_comuna) IN('La Pintana', 'Cerro Navia', 'Peñalolén') THEN
          v_mov_extra := PKG_REMUNERACIONES.VALOR_MOV_EXTRA_1;
        ELSIF   INITCAP(v_nombre_comuna) IN('Melipilla', 'María Pinto', 'Curacaví', 'Talagante', 'Isla de Maipo', 'Paine') THEN
          v_mov_extra := PKG_REMUNERACIONES.VALOR_MOV_EXTRA_2;
        END IF;
      END IF;
      v_movilizacion := ROUND((reg_empleado.sueldo_base_emp + v_comision + v_cargas)*pkg_remuneraciones.PORCENTAJE_MOV/100);
      v_movilizacion := v_movilizacion + v_mov_extra;
      -- Calcular el valor de la asignacion por años
      v_bonif_years := pkg_remuneraciones.fn_bonificacion(reg_empleado.antiguedad, reg_empleado.sueldo_base_emp + v_movilizacion);
      
      v_total := reg_empleado.sueldo_base_emp + v_bonif_years + v_movilizacion + v_comision + v_cargas + pkg_remuneraciones.VALOR_COLACION;
      -- Insertar resultado en la tabla
      INSERT INTO haber_calc_mes
      VALUES(reg_empleado.numrut_emp, TO_CHAR(TO_DATE(p_fecha),'MM'), 
            TO_CHAR(TO_DATE(p_fecha),'YYYY'),
                    reg_empleado.antiguedad, reg_empleado.sueldo_base_emp, v_bonif_years, v_cargas, v_movilizacion, 
                    pkg_remuneraciones.VALOR_COLACION, v_comision, v_total); 
  END LOOP;
END;

-- Prueba del informe
BEGIN
  sp_informe('30-06-2021',25, 25000, 40000,4500, 40000);
END;

SET SERVEROUTPUT ON;
BEGIN
dbms_output.put_line(fn_comision_vtas(12113369, '06-2021'));
dbms_output.put_line(TO_CHAR(TO_DATE('30-06-2021'),'MM-YYYY'));
END;