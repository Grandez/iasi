# Políticas

## Introducción

Las políticas definen las reglas generales que deberán respetar todos los módulos del proyecto.

Estas reglas prevalecen sobre las decisiones de implementación concretas.

---

# Responsabilidad única

Cada módulo implementará una única capacidad.

No deberán existir módulos con múltiples responsabilidades.

---

# Reutilización

Toda funcionalidad común deberá implementarse una única vez.

Los módulos utilizarán las bibliotecas comunes siempre que sea posible.

---

# Logging

Todo módulo deberá registrar su actividad utilizando el sistema común de logging.

No se utilizarán llamadas directas a echo salvo durante tareas de depuración.

---

# Colores

Los colores únicamente se utilizarán para facilitar la lectura.

Nunca constituirán el único mecanismo para transmitir información.

La salida deberá seguir siendo comprensible sin color.

---

# Mensajes

Los mensajes deberán ser:

- claros;
- breves;
- homogéneos;
- orientados al usuario.

---

# Errores

Todo error deberá indicar:

- qué ocurrió;
- por qué ocurrió;
- cómo puede resolverse.

---

# Verificación

Toda instalación deberá disponer de un mecanismo de verificación.

Una instalación no podrá considerarse finalizada hasta superar dicha verificación.

---

# Repetibilidad

Todos los módulos deberán poder ejecutarse varias veces sin producir efectos secundarios no deseados.

---

# Configuración

La configuración común residirá en un único lugar.

Los módulos no deberán contener valores duplicados.

---

# Versiones

Las versiones de las herramientas deberán centralizarse.

La actualización de una versión no deberá requerir modificar múltiples módulos.

---

# Repositorios

Siempre que sea posible se utilizarán repositorios oficiales.

Las excepciones deberán documentarse.

---

# Snap

Snap no se utilizará salvo decisión expresa documentada.

---

# Seguridad

Los módulos únicamente solicitarán privilegios elevados cuando resulte estrictamente necesario.

No se ejecutarán procesos privilegiados durante más tiempo del imprescindible.

---

# Dependencias

Toda dependencia deberá declararse explícitamente.

No deberán existir dependencias implícitas.

---

# Directorios

Todos los módulos respetarán la estructura oficial del proyecto.

No crearán directorios fuera de los definidos por la arquitectura.

---

# Documentación

Toda decisión importante deberá quedar documentada.

Toda modificación arquitectónica deberá generar el ADR correspondiente.

---

# IA

Los asistentes de IA podrán proponer implementaciones.

Las decisiones de ingeniería corresponderán siempre al proyecto y deberán respetar estas políticas.