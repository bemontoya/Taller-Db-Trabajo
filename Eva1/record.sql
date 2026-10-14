DECLARE
  TYPE t_resumen_usuario IS RECORD (
    email USUARIO.EMAIL%TYPE,
    nombre_plan PLAN_SUSCRIPCION.NOMBRE%TYPE,
    total_perfiles NUMBER
  );
  r_usuario t_resumen_usuario;
  v_id_usuario NUMBER := 1;
BEGIN
  SELECT u.email, p.nombre, COUNT(pr.id_perfil)
  INTO r_usuario.email, r_usuario.nombre_plan, r_usuario.total_perfiles
  FROM USUARIO u
  JOIN PLAN_SUSCRIPCION p ON u.PLAN_SUSCRIPCION_ID_PLAN_SUSCRIPCION = P.ID_PLAN_SUSCRIPCION
  LEFT JOIN PERFIL pr ON u.ID_USUARIO = pr.USUARIO_ID_USUARIO
  WHERE u.ID_USUARIO = v_id_usuario
  GROUP BY u.email, p.nombre;

  DBMS_OUTPUT.PUT_LINE('Email: ' || r_usuario.email);
  DBMS_OUTPUT.PUT_LINE('Plan: ' || r_usuario.nombre_plan);
  DBMS_OUTPUT.PUT_LINE('Total Perfiles: ' || r_usuario.total_perfiles);
EXCEPTION

  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('El usuario consultado no existe');
    
END;  