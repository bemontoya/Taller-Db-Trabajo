DECLARE
  CURSOR CORROBORADOR_DE_PERFIL IS
    SELECT 
     U.ID_USUARIO, 
     U.EMAIL, 
     COUNT(P.USUARIO_ID_USUARIO) AS PERFILES
    FROM USUARIO U
      JOIN PLAN_SUSCRIPCION PS ON U.PLAN_SUSCRIPCION_ID_PLAN_SUSCRIPCION = PS.ID_PLAN_SUSCRIPCION
      JOIN PERFIL P ON U.ID_USUARIO = P.USUARIO_ID_USUARIO
    WHERE PS.ID_PLAN_SUSCRIPCION IN (1, 5, 6, 7, 9, 12, 20)
    GROUP BY U.ID_USUARIO, U.EMAIL, PS.NOMBRE;

  e_exceso_perfiles EXCEPTION;

BEGIN
  DBMS_OUTPUT.PUT_LINE('#### Tester de perfiles erroneos ####');
  DBMS_OUTPUT.PUT_LINE('------------------------------------------------');

  FOR USUARIOS IN CORROBORADOR_DE_PERFIL LOOP
    DBMS_OUTPUT.PUT_LINE('Usuario de correo: ' || USUARIOS.EMAIL);

    IF USUARIOS.PERFILES > 1 THEN
      RAISE e_exceso_perfiles;

    ELSE
      DBMS_OUTPUT.PUT_LINE('Estado de usuario: Correcto.');
      DBMS_OUTPUT.PUT_LINE('------------------------------------------------');

    END IF;
  END LOOP;

EXCEPTION
  WHEN e_exceso_perfiles THEN
    DBMS_OUTPUT.PUT_LINE('ALERTA: Se detectó un usuario que posee más perfiles de los que su plan permite.');
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: No se encontró información requerida.');
  WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE('Error: Conflicto de tamaño de datos o tipo de valor.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error inesperado en la base de datos: ' || SQLERRM);
END;

