DECLARE
   TYPE t_contenido_rec IS RECORD (
      id_contenido   CONTENIDO.id_contenido%TYPE,
      titulo         CONTENIDO.titulo%TYPE,
      tipo           TIPO_CONTENIDO.NOMBRE%TYPE
   );

   r_info t_contenido_rec;

   TYPE t_top_array IS VARRAY(5) OF VARCHAR2(150);

   v_ranking t_top_array := t_top_array();

   CURSOR c_top_contenido IS

      SELECT c.id_contenido, c.titulo, tp.nombre
      FROM CONTENIDO c
      JOIN HISTORIAL_REPRODUCCION h ON c.ID_CONTENIDO = h.CAPITULO_CONTENIDO_ID_CONTENIDO
      JOIN TIPO_CONTENIDO TP ON c.TIPO_CONTENIDO_ID_TIPO_CONTENIDO = TP.ID_TIPO_CONTENIDO
      GROUP BY c.id_contenido, c.titulo, tp.nombre
      ORDER BY COUNT(h.id_historial) DESC;

   v_contador NUMBER := 0;

   e_sin_datos EXCEPTION;
BEGIN

   OPEN c_top_contenido;

   LOOP
      FETCH c_top_contenido INTO r_info;
      EXIT WHEN c_top_contenido%NOTFOUND OR v_contador = 5;

      v_contador := v_contador + 1;
      v_ranking.EXTEND;
      v_ranking(v_contador) := r_info.titulo || ' (' || r_info.tipo || ')';

   END LOOP;

   CLOSE c_top_contenido;

   IF v_ranking.COUNT = 0 THEN
      RAISE e_sin_datos;
   END IF;

   FOR i IN 1..v_ranking.COUNT LOOP

      DBMS_OUTPUT.PUT_LINE('Puesto #' || i || ': ' || v_ranking(i));

   END LOOP;



EXCEPTION

   WHEN e_sin_datos THEN
      DBMS_OUTPUT.PUT_LINE('Aviso: No se encontraron historiales para generar el ranking.');
   WHEN SUBSCRIPT_BEYOND_COUNT THEN
      DBMS_OUTPUT.PUT_LINE('Error de VARRAY: Intentaste asignar un índice fuera del límite definido.');

      IF c_top_contenido%ISOPEN THEN
         CLOSE c_top_contenido;
      END IF;

   WHEN VALUE_ERROR THEN

      DBMS_OUTPUT.PUT_LINE('Error de conversión o tamaño: Revisa la longitud del texto asignado al VARRAY.');
      IF c_top_contenido%ISOPEN THEN
         CLOSE c_top_contenido;
      END IF;

   WHEN OTHERS THEN

      DBMS_OUTPUT.PUT_LINE('Error inesperado [' || SQLCODE || ']: ' || SQLERRM);
      IF c_top_contenido%ISOPEN THEN
         CLOSE c_top_contenido;
      END IF;

END;

