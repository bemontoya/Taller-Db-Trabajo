CREATE OR REPLACE PROCEDURE SP_REPORTE_TOP_CONTENIDOS (
    p_top_n IN NUMBER,
    p_anio  IN NUMBER
) 
IS
    v_contador NUMBER := 0;
BEGIN
    IF p_top_n IS NULL OR p_top_n <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El parámetro p_top_n debe ser mayor a cero.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('===================================================================');
    DBMS_OUTPUT.PUT_LINE(' REPORTE ESTRATÉGICO: TOP ' || p_top_n || ' CONTENIDOS MÁS VISTOS DEL AÑO ' || p_anio);
    DBMS_OUTPUT.PUT_LINE('===================================================================');

    FOR r IN (
        SELECT 
            c.titulo,
            p.nombre AS productora,
            COUNT(h.id_historial) AS total_reproducciones
        FROM HISTORIAL_REPRODUCCION h
        JOIN CONTENIDO c ON h.CAPITULO_CONTENIDO_id_contenido = c.id_contenido
        JOIN PRODUCTORA p ON c.PRODUCTORA_id_productora = p.id_productora
        WHERE EXTRACT(YEAR FROM h.fecha_ultima_reproduccion) = p_anio
        GROUP BY 
            c.id_contenido,
            c.titulo, 
            p.nombre
        ORDER BY total_reproducciones DESC
        FETCH FIRST p_top_n ROWS ONLY
    ) LOOP
        v_contador := v_contador + 1;
        DBMS_OUTPUT.PUT_LINE(
            'PUESTO ' || v_contador || 
            ' | REPRODUCCIONES: ' || r.total_reproducciones || 
            ' | PRODUCTORA: ' || r.productora || 
            ' | TÍTULO: ' || r.titulo
        );
    END LOOP;

    IF v_contador = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Información no disponible: No hay reproducciones registradas para el año ' || p_anio || '.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Fallo crítico durante el procesamiento analítico: ' || SQLERRM);
        RAISE;
END SP_REPORTE_TOP_CONTENIDOS;
/

SET SERVEROUTPUT ON;
EXEC SP_REPORTE_TOP_CONTENIDOS(10,2023);
