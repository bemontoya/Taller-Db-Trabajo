# Usos y funcionamiento

* **Paquete:** Este código implementa las reglas de control de cuentas para la plataforma mediante un paquete (pkg_gestion_streaming).
 PACKAGE SPEC es la interfaz pública del paquete, define los elementos a los que otros scripts o procedimientos pueden acceder.
 PACKAGE BODY contiene una función privada (fn_limite_plan) que solo puede ser llamada internamente dentro del paquete.
 fn_perfil_apto es la función pública que evalúa el control parental consultando PERFIL si el perfil es infantil (es_infantil = '1') y consulta la clasificación de edad asignada al contenido.
 sp_auditar_perfiles es el procedimiento público que obtiene el plan asignado al usuario desde la tabla USUARIO, cuenta los perfiles vinculados al usuario en la tabla PERFIL y llama la función interna fn_limite_plan para determinar el límite permitido.


* **Trigger:**  Este código evalúa las reglas de negocio de el email del usuario eliminando espacios y mayúsculas haciendo uso de lower
 para convertir automáticamente las letras en minúscula, trim elimina los espacios de el inicio y del final y replace elimina los espacios en blanco dentro del correo.
 Posterior a eso se ejecuta una condición if que evalúa si el correo contiene @ y . mostrando un mensaje de error si esta condición no se cumple.
 Finalmente se ejecuta una parte del código que en el apartado contraseña elimina todos los espacios de la contraseña.

## Funcionamiento de `SP_REPORTE_TOP_CONTENIDOS`

Este procedimiento genera por consola el ranking de los contenidos más reproducidos en un año específico, utilizando un cursor implícito para optimizar memoria y reducir líneas de código.

**1.- Parámetros y Variables**

`p_top_n (IN)`: Límite de registros a mostrar (ej. Top 10).

`p_anio (IN)`: Año que se desea filtrar.

`v_contador`: Variable interna inicializada en 0. Sirve para detectar si la consulta devolvió resultados.

**2.- Validación Inicial**

Antes de consultar la base de datos, verifica que p_top_n sea mayor a cero. Si es nulo, cero o negativo, detiene la ejecución y lanza el error personalizado -20001.

**3.- Consulta y Recorrido (FOR r IN (...) LOOP)**

cursor implícito. Oracle abre, recorre y cierra la consulta automáticamente:

*Cruza las tablas (JOIN)*: Une el historial de reproducciones con el contenido y su productora.

*Filtra (WHERE)*: Extrae el año de fecha_ultima_reproduccion y selecciona solo los registros que coinciden con p_anio.

*Agrupa y Cuenta (GROUP BY / COUNT)*: Suma cuántas reproducciones tiene cada contenido único (id_contenido, titulo, nombre).

*Ordena y Recorta (ORDER BY / FETCH FIRST)*: Ordena de mayor a menor según las reproducciones y corta el resultado exactamente en p_top_n filas.

**4.- Control de Datos Vacíos**

Al terminar el bucle, evalúa IF v_contador = 0. Si nunca entró al ciclo, informa que no existen reproducciones registradas para ese año.

**5.- Manejo de Excepciones (EXCEPTION)**

Si ocurre un fallo inesperado (WHEN OTHERS), imprime el detalle técnico del error (SQLERRM) y ejecuta RAISE para notificar a la base de datos que la ejecución falló.

**6.- Invocar**
```sql
SET SERVEROUTPUT ON;
EXEC SP_REPORTE_TOP_CONTENIDOS(10,2023);
```

## Funcionamiento de `CALCULAR_PRECIO_SUSCRIPCION`

Esta función calcula y devuelve el monto final que debe pagar un usuario por su suscripción, permitiéndole aplicar un porcentaje de descuento opcional.

**1. Parámetros y Variables**

`p_id_usuario (IN)`:Identificador del usuario a consultar.

`p_porcentaje_descuento (IN)`: Porcentaje de descuento a aplicar. Tiene un valor por defecto de `0` (si no se envía al llamar la función, calcula el precio normal).

`v_precio_base` / `v_precio_final`:Variables internas para almacenar el costo original del plan y el resultado tras aplicar el descuento.

**2. Flujo de Ejecución**

Cruza las tablas `USUARIO` Y `PLAN_SUSCRIPCION` para obtener el precio original y guardarlo en `v_precio_base`.
verifica que el descuento este en un rango de `0` a `100`, si se ingresa un valor fuera de este rango lanza un error `-20001`
Calcula el descuento usando: Precio base - (precio base x (descuento/100))

**3. Manejo de Excepciones (`EXCEPTION`)**
`WHEN NO_DATA_FOUND`:Si el `p_id_usuario` no existe o no tiene un plan asignado, la función no falla; simplemente devuelve `NULL`.
`WHEN OTHERS`: Ante cualquier otro error inesperado (incluyendo el error `-20001` del descuento inválido), utiliza `RAISE` para propagar el fallo e informar al sistema.

**4.- Invocacón**
```sql
SELECT 
    email,
    ROUND(CALCULAR_PRECIO_SUSCRIPCION(id_usuario, 15), -1) AS precio_a_pagar
FROM USUARIO;
```
