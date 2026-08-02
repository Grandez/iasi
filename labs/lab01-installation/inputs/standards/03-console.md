# Estándar de consola

## Propósito

Este documento define cómo interactúa el sistema con el usuario durante la ejecución.

El objetivo es proporcionar una experiencia homogénea, clara y predecible en todos los módulos.

La consola constituye la interfaz principal del sistema y deberá transmitir confianza, simplicidad y claridad.

---

# Principios

La consola deberá ser:

* clara;
* limpia;
* consistente;
* poco intrusiva;
* orientada al usuario;
* útil para el diagnóstico.

La salida deberá poder seguirse cómodamente incluso durante ejecuciones largas.

---

# Filosofía

La consola no pretende impresionar.

Pretende informar.

Cada línea debe aportar información útil.

Se evitará el ruido visual y la repetición innecesaria.

---

# Organización

Toda ejecución seguirá una estructura similar:

1. Cabecera.
2. Información del sistema.
3. Ejecución de módulos.
4. Resumen.
5. Resultado final.

---

# Cabecera

Toda ejecución podrá comenzar con una cabecera similar a:

```text
============================================================
IASI - Kubuntu Environment Installer
============================================================

Versión ......... 1.0.0
Fecha ........... 2026-08-02
Usuario ......... javier
Sistema ......... Kubuntu 26.04 LTS
```

La cabecera aparecerá una única vez.

---

# Separadores

Los separadores deberán utilizarse únicamente para dividir bloques importantes.

Nunca entre operaciones individuales.

Ejemplo:

```text
------------------------------------------------------------
Instalación de Docker
------------------------------------------------------------
```

---

# Títulos

Los títulos deberán ser breves.

Ejemplos:

```text
Sistema base

Docker

Java

OpenSpec

Verificación
```

---

# Espaciado

Se dejará una línea en blanco entre bloques.

No se utilizarán múltiples líneas vacías consecutivas.

---

# Anchura

La salida deberá mantenerse legible en terminales de 80 columnas.

No deberán generarse líneas excesivamente largas salvo cuando resulte inevitable.

---

# Alineación

Las etiquetas deberán alinearse siempre que ello mejore la lectura.

Ejemplo:

```text
Sistema .......... Kubuntu 26.04
Usuario .......... javier
Arquitectura ..... x86_64
```

---

# Progreso

Las operaciones largas deberán informar de su progreso.

Ejemplo:

```text
Actualizando índices APT...
```

No es necesario mostrar porcentajes cuando no puedan calcularse correctamente.

---

# Spinners

Los indicadores animados podrán utilizarse únicamente cuando:

* mejoren la experiencia;
* no dificulten la captura del log;
* puedan desactivarse automáticamente.

No deberán utilizarse en:

* CI/CD;
* redirecciones;
* modo sin color.

---

# Barras de progreso

Solo se utilizarán cuando exista información fiable sobre el progreso real.

Nunca deberán simular un avance inexistente.

---

# Entrada del usuario

El sistema solicitará interacción únicamente cuando resulte imprescindible.

Siempre que sea posible:

* ofrecerá valores por defecto;
* explicará las opciones;
* validará la respuesta.

---

# Confirmaciones

Las operaciones destructivas requerirán confirmación.

Ejemplo:

```text
¿Desea eliminar el directorio anterior? [s/N]
```

La opción segura será siempre la predeterminada.

---

# Información técnica

La información técnica detallada no deberá mostrarse continuamente.

Solo aparecerá cuando:

* exista un error;
* el usuario active modo verbose;
* sea imprescindible para comprender el problema.

---

# Verbose

El modo detallado podrá mostrar:

* comandos ejecutados;
* rutas;
* URLs;
* decisiones internas;
* tiempos.

La salida normal permanecerá limpia.

---

# Debug

El modo debug estará reservado para el desarrollo de la infraestructura.

No deberá utilizarse durante una ejecución normal.

---

# Colores

Los colores seguirán el estándar definido en `logging.md`.

La consola seguirá siendo completamente legible sin color.

---

# Emojis

No se utilizarán emojis.

Los niveles de logging y el formato visual ya proporcionan suficiente información.

---

# Iconos

No se utilizarán símbolos especiales salvo cuando aporten una mejora clara y puedan mostrarse correctamente en cualquier terminal.

La compatibilidad tendrá prioridad sobre la estética.

---

# Mensajes

Los mensajes deberán:

* ser breves;
* estar escritos en lenguaje natural;
* evitar tecnicismos innecesarios;
* indicar claramente la acción realizada.

---

# Idioma

Todo el proyecto utilizará un único idioma.

La internacionalización podrá incorporarse en el futuro.

---

# Errores

Cuando ocurra un error la consola deberá mostrar:

* qué operación falló;
* el motivo;
* una posible acción correctiva;
* la ubicación del fichero de log.

---

# Advertencias

Las advertencias deberán aparecer en el momento en que se detecten.

No deberán ocultarse hasta el final de la ejecución.

---

# Resumen

Toda ejecución finalizará con un resumen.

Ejemplo:

```text
============================================================
Resumen
============================================================

Sistema base ........ OK
Docker .............. OK
Node.js ............. OK
OpenSpec ............ OK
Quarto .............. OK

Advertencias ........ 1
Errores ............. 0

Duración ............ 2 min 43 s

Log ................. logs/2026-08-02_143208_install-all.log
```

---

# Resultado final

La última línea deberá indicar claramente el estado global.

Ejemplos:

```text
Instalación completada correctamente.
```

```text
Instalación completada con advertencias.
```

```text
La instalación no pudo completarse.
```

No deberá existir ambigüedad sobre el resultado final.

---

# Interrupción

Si el usuario cancela la ejecución, la consola deberá indicarlo explícitamente.

Ejemplo:

```text
Ejecución cancelada por el usuario.
```

---

# Redirección

Cuando la salida se redirija a un fichero:

* no deberán utilizarse colores;
* no deberán utilizarse animaciones;
* el formato deberá seguir siendo legible.

---

# Accesibilidad

La información nunca dependerá exclusivamente del color.

La estructura visual deberá mantenerse mediante:

* alineación;
* espaciado;
* texto;
* niveles.

---

# Consistencia

Todos los módulos deberán presentar exactamente la misma experiencia de usuario.

El usuario no debería poder distinguir qué desarrollador o qué IA implementó un módulo únicamente observando la consola.

---

# Criterio final

La consola representa la interfaz del proyecto.

Debe transmitir la misma sensación que el resto de la arquitectura: orden, claridad, simplicidad y confianza.
