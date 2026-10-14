CREATE OR REPLACE FUNCTION CALCULAR_PRECIO_SUSCRIPCION (
    p_id_usuario           IN NUMBER,
    p_porcentaje_descuento IN NUMBER DEFAULT 0
) RETURN NUMBER 
IS
    v_precio_base  NUMBER;
    v_precio_final NUMBER;
BEGIN
    SELECT ps.precio
    INTO v_precio_base
    FROM USUARIO u
    JOIN PLAN_SUSCRIPCION ps ON u.PLAN_SUSCRIPCION_id_plan_suscripcion = ps.id_plan_suscripcion
    WHERE u.id_usuario = p_id_usuario;

    IF p_porcentaje_descuento < 0 OR p_porcentaje_descuento > 100 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Regla inválida: El porcentaje de descuento debe estar entre 0 y 100.');
    END IF;

    v_precio_final := v_precio_base - (v_precio_base * (p_porcentaje_descuento / 100));

    RETURN v_precio_final;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; 
    WHEN OTHERS THEN
        RAISE;
END CALCULAR_PRECIO_SUSCRIPCION;
/
SELECT 
    email,
    ROUND(CALCULAR_PRECIO_SUSCRIPCION(id_usuario, 15),-1) AS precio_a_pagar
FROM USUARIO;
