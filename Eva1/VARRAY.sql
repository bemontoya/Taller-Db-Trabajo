SET SERVEROUTPUT ON;
DECLARE
  TYPE t_clasificaciones IS VARRAY(5) OF VARCHAR2(10);

  v_permitidas t_clasificaciones := t_clasificaciones('TE', 'TE+7', '14+', '18+', 'MA');
  v_nombre_clasif VARCHAR2(50) := 'TE'; 
  v_encontrado BOOLEAN := FALSE;

BEGIN
  DBMS_OUTPUT.PUT_LINE('--- PROBANDO CON: "' || v_nombre_clasif || '" ---');

  IF v_nombre_clasif IS NULL OR TRIM(v_nombre_clasif) IS NULL THEN
    RAISE VALUE_ERROR;
  END IF;

  FOR i IN 1..v_permitidas.COUNT LOOP
    IF UPPER(TRIM(v_nombre_clasif)) = v_permitidas(i) THEN
      v_encontrado := TRUE;
      EXIT;
    END IF;
  END LOOP;

  IF NOT v_encontrado THEN
    RAISE NO_DATA_FOUND;
  END IF;

  DBMS_OUTPUT.PUT_LINE('La clasificación ' || UPPER(v_nombre_clasif) || ' es válida y permitida.');

EXCEPTION

  WHEN VALUE_ERROR THEN
    DBMS_OUTPUT.PUT_LINE('Error: El valor está vacío o es nulo.');

  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: La clasificación ' || v_nombre_clasif || ' no existe en la lista.');

  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error inesperado.');

END;

