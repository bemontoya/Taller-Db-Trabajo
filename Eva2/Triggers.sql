SELECT * FROM USUARIO; 

INSERT INTO USUARIO (id_usuario, email, contrasena, fecha_registro, metodo_pago, PLAN_SUSCRIPCION_ID_PLAN_SUSCRIPCION)
VALUES (999, 'be mon toya ', 'clave123', SYSDATE, 'Tarjeta', 1);

SELECT id_usuario, email, contrasena
FROM USUARIO
WHERE id_usuario = 999;

DELETE FROM USUARIO WHERE id_usuario = 999;

COMMIT;

CREATE OR REPLACE TRIGGER tgr_validacion_datos_usuario
BEFORE INSERT OR UPDATE ON USUARIO 
BEGIN

  :NEW.email := LOWER(TRIM(REPLACE(:NEW.email, ' ', '')));


  IF :NEW.email NOT LIKE '%@%.%' THEN
    RAISE_APPLICATION_ERROR(-20001, 'ERROR DE FORMATO: El correo electrónico ingresado no es válido.');
  END IF;

  :NEW.contrasena := TRIM(:NEW.contrasena);

END tgr_validacion_datos_usuario;

/

INSERT INTO USUARIO (id_usuario, email, contrasena, fecha_registro, metodo_pago, PLAN_SUSCRIPCION_id_plan_suscripcion)
VALUES (999, ' correo sin at ni punto ', ' clave123 ', SYSDATE, 'Tarjeta', 1);

INSERT INTO USUARIO (id_usuario, email, contrasena, fecha_registro, metodo_pago, PLAN_SUSCRIPCION_id_plan_suscripcion)
VALUES (1000, ' USER . TEST @ MAIL . COM ', ' miClave123 ', SYSDATE, 'Tarjeta', 1);

SELECT id_usuario, email, contrasena
FROM USUARIO
WHERE id_usuario = 1000;

DELETE FROM USUARIO WHERE id_usuario = 1000;
COMMIT;

