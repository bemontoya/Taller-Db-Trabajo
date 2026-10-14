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
