--PAQUETE (spec + body)
--Agrupa las reglas de control de cuentas de la plataforma:
--  Publico: sp_auditar_perfiles -> revisa que una cuenta no supere los perfiles permitidos por su plan
--  Publico: fn_perfil_apto      -> control parental: un perfil infantil solo ve contenido 'L' o '7+'
--  Privado: fn_limite_plan      -> perfiles maximos por plan (solo se usa dentro del body)
--
--Segun los datos de la base:
--  Planes: 1 'Básico con Anuncios' | 2 'Básico' | 3 'Estándar' | 4 'Premium'
--  CLASIF_EDAD.nombre: 'L', '7+', '13+', '16+', '18+', 'TV-MA'
--  PERFIL.es_infantil: '1' = perfil infantil, '0' = perfil normal

--1 SPEC
CREATE OR REPLACE PACKAGE pkg_gestion_streaming
AS

    g_total_auditorias NUMBER := 0;

    PROCEDURE sp_auditar_perfiles( p_id_usuario IN NUMBER );

    FUNCTION fn_perfil_apto( p_id_perfil IN NUMBER, p_id_contenido IN NUMBER ) RETURN VARCHAR2;

END pkg_gestion_streaming;
/


--2 BODY
CREATE OR REPLACE PACKAGE BODY pkg_gestion_streaming
AS

    --Funcion privada (va primero porque no esta declarada en el spec)
    FUNCTION fn_limite_plan( p_id_plan IN NUMBER ) RETURN NUMBER
    AS
        v_nombre PLAN_SUSCRIPCION.NOMBRE%TYPE;
        v_limite NUMBER := 1;
    BEGIN
        SELECT nombre INTO v_nombre FROM PLAN_SUSCRIPCION WHERE id_plan_suscripcion = p_id_plan;

        IF v_nombre = 'Básico con Anuncios' THEN
            v_limite := 1;
        ELSIF v_nombre = 'Básico' THEN
            v_limite := 2;
        ELSIF v_nombre = 'Estándar' THEN
            v_limite := 4;
        ELSIF v_nombre = 'Premium' THEN
            v_limite := 5;
        END IF;

        RETURN v_limite;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20004, 'El plan de suscripcion no existe');
    END fn_limite_plan;


    --Funcion publica: retorna 'S' si el perfil puede ver el contenido y 'N' si no
    FUNCTION fn_perfil_apto( p_id_perfil IN NUMBER, p_id_contenido IN NUMBER ) RETURN VARCHAR2
    AS
        v_es_infantil PERFIL.ES_INFANTIL%TYPE;
        v_id_clasif CONTENIDO.CLASIF_EDAD_id_clasif_edad%TYPE;
        v_clasif CLASIF_EDAD.NOMBRE%TYPE;
        v_apto VARCHAR2(1) := 'S';
    BEGIN
        SELECT es_infantil INTO v_es_infantil FROM PERFIL WHERE id_perfil = p_id_perfil;

        SELECT CLASIF_EDAD_id_clasif_edad INTO v_id_clasif FROM CONTENIDO WHERE id_contenido = p_id_contenido;

        SELECT nombre INTO v_clasif FROM CLASIF_EDAD WHERE id_clasif_edad = v_id_clasif;

        IF v_es_infantil = '1' AND v_clasif <> 'L' AND v_clasif <> '7+' THEN
            v_apto := 'N';
        END IF;

        RETURN v_apto;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20005, 'El perfil o el contenido no existe');
    END fn_perfil_apto;


    --Procedimiento publico: compara los perfiles creados con el limite del plan
    PROCEDURE sp_auditar_perfiles( p_id_usuario IN NUMBER )
    AS
        v_id_plan USUARIO.PLAN_SUSCRIPCION_id_plan_suscripcion%TYPE;
        v_total_perfiles NUMBER;
        v_limite NUMBER;
    BEGIN
        SELECT PLAN_SUSCRIPCION_id_plan_suscripcion INTO v_id_plan FROM USUARIO WHERE id_usuario = p_id_usuario;

        SELECT COUNT(*) INTO v_total_perfiles FROM PERFIL WHERE USUARIO_id_usuario = p_id_usuario;

        v_limite := fn_limite_plan(v_id_plan);

        IF v_total_perfiles > v_limite THEN
            DBMS_OUTPUT.PUT_LINE('ALERTA: el usuario ' || p_id_usuario || ' tiene ' || v_total_perfiles || ' perfiles y su plan permite ' || v_limite);
        ELSE
            DBMS_OUTPUT.PUT_LINE('El usuario ' || p_id_usuario || ' cumple su plan (' || v_total_perfiles || ' de ' || v_limite || ' perfiles)');
        END IF;

        g_total_auditorias := g_total_auditorias + 1;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('El usuario ' || p_id_usuario || ' no existe');
    END sp_auditar_perfiles;

END pkg_gestion_streaming;
/


--PRUEBAS

--Prueba 1: usuario 1 (plan Básico, tiene 1 perfil) -> cumple
--Prueba 2: usuario 999 no existe
--Prueba 3: perfil 5 es infantil: contenido 1 es '7+' -> S | contenido 5 es 'TV-MA' -> N
--          perfil 1 es normal: contenido 5 -> S
DECLARE
    v_apto VARCHAR2(1);
BEGIN
    PKG_GESTION_STREAMING.SP_AUDITAR_PERFILES(1);
    PKG_GESTION_STREAMING.SP_AUDITAR_PERFILES(999);

    v_apto := PKG_GESTION_STREAMING.FN_PERFIL_APTO(5, 1);
    DBMS_OUTPUT.PUT_LINE('Perfil infantil 5 / contenido 1 (7+): ' || v_apto);

    v_apto := PKG_GESTION_STREAMING.FN_PERFIL_APTO(5, 5);
    DBMS_OUTPUT.PUT_LINE('Perfil infantil 5 / contenido 5 (TV-MA): ' || v_apto);

    v_apto := PKG_GESTION_STREAMING.FN_PERFIL_APTO(1, 5);
    DBMS_OUTPUT.PUT_LINE('Perfil normal 1 / contenido 5 (TV-MA): ' || v_apto);

    DBMS_OUTPUT.PUT_LINE('Total de auditorias realizadas: ' || PKG_GESTION_STREAMING.g_total_auditorias);
END;
/


--Prueba 4: en los datos cada usuario tiene 1 solo perfil, asi que nadie excede su plan.
--Se crean 2 perfiles extra al usuario 4 (plan 'Básico con Anuncios', permite 1) para ver la alerta.
INSERT INTO PERFIL (id_perfil, nombre_perfil, avatar_url, es_infantil, USUARIO_id_usuario)
VALUES (51, 'Perfil extra 1', 'http://avatar/51.png', '0', 4);

INSERT INTO PERFIL (id_perfil, nombre_perfil, avatar_url, es_infantil, USUARIO_id_usuario)
VALUES (52, 'Perfil extra 2', 'http://avatar/52.png', '0', 4);

BEGIN
    PKG_GESTION_STREAMING.SP_AUDITAR_PERFILES(4);
END;
/

--Se deshacen los perfiles de prueba
ROLLBACK;
