-- CASO 1
CREATE OR REPLACE TRIGGER trg_comisiones
AFTER INSERT OR UPDATE OF monto_boleta OR DELETE ON boleta
FOR EACH ROW
BEGIN
  -- Verifica si se trata de una inserciòn
  IF INSERTING THEN
    INSERT INTO comision_venta
    VALUES(:NEW.nro_boleta, ROUND(:NEW.monto_boleta*0.15)); 
  END IF;
  -- Verifica si se trata de una actualziaciòn
  IF UPDATING('monto_boleta') THEN
    -- Verificar si existe aumento en el monto
    IF :NEW.monto_boleta > :OLD.monto_boleta THEN
      UPDATE comision_venta
      SET valor_comision = ROUND(:NEW.monto_boleta*0.15)
      WHERE nro_boleta = :NEW.nro_boleta;
    END IF;
  END IF;
  -- Verifica si se trata de una eliminaciòn
  IF DELETING THEN
      DELETE FROM comision_venta
      WHERE nro_boleta = :OLD.nro_boleta;
  END IF;
END;

-- BLOQUE ANONIMO PARA PROBAR EL TRIGGER
BEGIN
  -- Inserta
  INSERT INTO boleta VALUES(28,'26/06/2021',258999, 3000, 12456905);
  -- Actualizacion 1
  UPDATE boleta SET monto_boleta = 558590 
  WHERE nro_boleta = 24;
  -- Actualziacion 2
  UPDATE boleta SET monto_boleta = 60000 
  WHERE nro_boleta = 27;
  
  -- Borrado
  DELETE FROM boleta WHERE nro_boleta = 22;
END;
-- CASO 2