# Estándar de logging

## Propósito

Este documento define el comportamiento del sistema común de logging del proyecto.

El objetivo es proporcionar una salida homogénea, legible y útil para:

* seguir la ejecución de los módulos;
* detectar errores;
* diagnosticar incidencias;
* medir tiempos;
* conservar trazabilidad;
* revisar ejecuciones posteriores.

Todos los módulos deberán utilizar la biblioteca común de logging.

No se implementarán mecanismos de registro independientes.

## Principios

El sistema de logging deberá ser:

* claro;
* consistente;
* legible;
* reutilizable;
* independiente del módulo;
* útil tanto en consola como en fichero;
* comprensible sin depender del color.

El logging no debe decorar la ejecución.

Debe explicar qué está ocurriendo.

## Canales de salida

El sistema generará dos salidas complementarias:

1. Consola.
2. Fichero de log.

Ambas representarán la misma secuencia de eventos, aunque podrán utilizar formatos visuales diferentes.

La consola estará orientada al seguimiento inmediato.

El fichero estará orientado a la trazabilidad y al diagnóstico posterior.

## Niveles

El sistema utilizará inicialmente cuatro niveles.

| Nivel   | Propósito                                                      |
| ------- | -------------------------------------------------------------- |
| `INFO`  | Informar de una operación normal en curso.                     |
| `OK`    | Confirmar que una operación ha finalizado correctamente.       |
| `WARN`  | Informar de una situación no bloqueante que requiere atención. |
| `ERROR` | Informar de un fallo que impide completar una operación.       |

No se crearán niveles adicionales sin una necesidad demostrada.

Los niveles deberán aparecer siempre como texto.

El color nunca será el único mecanismo para distinguirlos.

## Formato de consola

El formato general será:

```text
HH:MM:SS NIVEL  Mensaje
```

Ejemplo:

```text
14:32:08 INFO   Actualizando índices APT...
14:32:11 OK     Índices actualizados.
14:32:12 WARN   El paquete ya estaba instalado.
14:32:13 ERROR  No se pudo acceder al repositorio.
```

La hora se mostrará en formato de 24 horas.

Los niveles deberán alinearse para facilitar la lectura vertical.

La salida no incluirá corchetes salvo que se adopten posteriormente mediante una decisión explícita.

## Formato de fichero

El fichero de log utilizará un formato más completo:

```text
YYYY-MM-DD HH:MM:SS NIVEL MODULO Mensaje
```

Ejemplo:

```text
2026-08-02 14:32:08 INFO  system-base Actualizando índices APT...
2026-08-02 14:32:11 OK    system-base Índices actualizados.
2026-08-02 14:32:12 WARN  system-base El paquete ya estaba instalado.
2026-08-02 14:32:13 ERROR system-base No se pudo acceder al repositorio.
```

El nombre del módulo deberá incluirse siempre en el fichero.

En consola podrá omitirse cuando el contexto sea evidente.

## Fecha y hora

Todo evento deberá incluir una marca temporal.

En consola se utilizará:

```text
HH:MM:SS
```

En fichero se utilizará:

```text
YYYY-MM-DD HH:MM:SS
```

La hora deberá obtenerse en el momento de registrar el evento.

No se reutilizarán marcas temporales anteriores.

## Colores

Los colores se aplicarán únicamente al nivel.

No se coloreará la línea completa.

La propuesta inicial es:

| Nivel   | Color    |
| ------- | -------- |
| `INFO`  | Azul     |
| `OK`    | Verde    |
| `WARN`  | Amarillo |
| `ERROR` | Rojo     |

Cuando la terminal no soporte color, los niveles deberán mostrarse en negrita si es posible.

Si tampoco existe soporte para negrita, la salida textual seguirá siendo completamente válida.

## Uso de negrita

La negrita podrá utilizarse como alternativa o complemento moderado al color.

No se aplicará a mensajes completos.

Podrá utilizarse en:

* niveles;
* títulos;
* resultados finales;
* valores especialmente relevantes.

## Detección de capacidades

La biblioteca deberá detectar si la salida estándar está conectada a una terminal compatible.

Los colores deberán desactivarse automáticamente cuando:

* la salida se redirija a un fichero;
* la terminal no soporte códigos ANSI;
* se ejecute en un entorno no interactivo;
* se establezca explícitamente una opción sin color.

El fichero de log nunca contendrá códigos ANSI.

## Funciones públicas

La biblioteca común deberá proporcionar, como mínimo:

```bash
log_info
log_ok
log_warn
log_error
```

Ejemplo:

```bash
log_info "Instalando Git..."
log_ok "Git instalado correctamente."
log_warn "Git ya estaba instalado."
log_error "No se pudo instalar Git."
```

También podrá proporcionar una función genérica interna:

```bash
log_message "INFO" "Instalando Git..."
```

Los módulos deberán utilizar preferentemente las funciones específicas.

## Contexto del módulo

Cada módulo deberá identificar su nombre al inicializarse.

Ejemplo conceptual:

```bash
set_log_module "system-base"
```

A partir de ese momento, todos los eventos registrados deberán asociarse a dicho módulo.

El nombre del módulo deberá ser:

* estable;
* breve;
* descriptivo;
* coherente con el nombre del fichero o capacidad.

## Títulos

La biblioteca podrá proporcionar funciones para mostrar títulos de módulo o sección.

Ejemplo:

```text
Sistema base
```

o:

```text
============================================================
Sistema base
============================================================
```

Los títulos deberán utilizarse con moderación.

No se mostrarán separadores antes de cada operación pequeña.

## Inicio de módulo

Todo módulo deberá registrar su inicio.

Ejemplo:

```text
14:32:08 INFO   Iniciando módulo system-base.
```

El inicio podrá incluir información relevante:

* versión del módulo;
* usuario;
* sistema operativo;
* modo de ejecución;
* fichero de log.

## Finalización de módulo

Todo módulo deberá registrar su finalización.

Ejemplo correcto:

```text
14:34:21 OK     Módulo system-base finalizado correctamente.
```

Ejemplo con advertencias:

```text
14:34:21 WARN   Módulo system-base finalizado con advertencias.
```

Ejemplo con error:

```text
14:34:21 ERROR  Módulo system-base interrumpido.
```

## Duración

La biblioteca deberá permitir medir la duración de:

* un módulo;
* una fase;
* una operación relevante.

Ejemplo:

```text
14:34:21 OK     Módulo finalizado en 2 min 13 s.
```

No es necesario medir todas las operaciones pequeñas.

La medición deberá aplicarse cuando aporte valor para el diagnóstico o la evaluación del proceso.

## Mensajes

Los mensajes deberán ser:

* breves;
* concretos;
* orientados a una acción;
* comprensibles sin examinar el código;
* coherentes entre módulos.

Se evitarán mensajes como:

```text
Procesando...
```

Se preferirán mensajes como:

```text
Actualizando índices APT...
```

También se evitarán mensajes genéricos como:

```text
Algo salió mal.
```

Se preferirán mensajes como:

```text
No se pudo descargar la clave del repositorio Docker.
```

## Puntuación

Los mensajes informativos sobre operaciones en curso terminarán normalmente con puntos suspensivos:

```text
Instalando Docker...
```

Los mensajes de resultado terminarán con punto:

```text
Docker instalado correctamente.
```

Los errores y advertencias también terminarán con punto.

## Mensajes de error

Todo mensaje de error deberá indicar, cuando sea posible:

1. Qué operación falló.
2. Qué elemento estaba siendo procesado.
3. Cuál fue la causa.
4. Qué puede hacer el usuario.

Ejemplo:

```text
ERROR  No se pudo descargar la clave del repositorio Docker.
ERROR  Compruebe la conexión a Internet y vuelva a ejecutar el módulo.
```

No se ocultará la salida original de una herramienta cuando sea necesaria para el diagnóstico.

## Salida de comandos externos

Los comandos externos podrán ejecutarse en tres modos.

### Visible

La salida se muestra directamente en consola.

Se utilizará cuando el usuario necesite seguir el proceso.

### Registrada

La salida se guarda en el fichero de log, pero no se muestra completa en consola.

Se utilizará para comandos muy verbosos.

### Silenciosa

La salida se descarta o reduce al mínimo.

Solo se utilizará cuando la información no tenga utilidad diagnóstica.

Los errores nunca deberán descartarse silenciosamente.

## Información sensible

Los logs no deberán contener:

* contraseñas;
* tokens;
* claves privadas;
* secretos;
* contenido sensible;
* credenciales completas;
* valores de autenticación.

Cuando sea necesario registrar un identificador sensible, deberá enmascararse.

Ejemplo:

```text
token=abcd********wxyz
```

## Ubicación de los logs

Los logs deberán almacenarse dentro de la estructura oficial del proyecto.

Propuesta inicial:

```text
logs/
```

Cada ejecución deberá generar un fichero independiente.

Ejemplo:

```text
logs/2026-08-02_143208_system-base.log
```

Para una instalación completa:

```text
logs/2026-08-02_143208_install-all.log
```

## Nombre de fichero

El formato recomendado será:

```text
YYYY-MM-DD_HHMMSS_modulo.log
```

El nombre deberá:

* permitir orden cronológico;
* identificar el módulo;
* evitar espacios;
* ser seguro para el sistema de ficheros.

## Creación del directorio

La biblioteca de logging será responsable de crear el directorio de logs cuando no exista.

Si no puede crearlo:

* deberá informar claramente;
* podrá continuar únicamente si el fichero no es obligatorio;
* deberá mantener la salida por consola;
* no deberá fallar silenciosamente.

## Ejecución completa

Cuando varios módulos formen parte de una ejecución completa, podrán existir:

* un log global;
* logs individuales por módulo.

El log global deberá conservar la secuencia completa.

Los logs individuales facilitarán el diagnóstico de cada componente.

La estrategia definitiva se decidirá durante el diseño de la biblioteca.

## Rotación y limpieza

La primera versión no necesita un sistema complejo de rotación.

Deberá evitarse, no obstante, el crecimiento indefinido.

Podrá establecerse una política simple basada en:

* número máximo de ficheros;
* antigüedad;
* limpieza manual;
* compresión futura.

La eliminación de logs nunca se realizará sin una política explícita.

## Integración con errores

Cuando un comando obligatorio falle, el sistema deberá:

1. Registrar el error.
2. Registrar el código de salida.
3. Registrar el comando o la operación lógica.
4. Finalizar o recuperar según la política del módulo.

Ejemplo:

```text
14:32:13 ERROR  La instalación de git devolvió el código 100.
```

No se registrarán secretos contenidos en argumentos de comandos.

## Códigos de salida

El logging no sustituye a los códigos de salida.

Un módulo que registre un error deberá devolver un código distinto de cero cuando el error impida cumplir su objetivo.

No deberá registrarse `OK` si el código de salida final indica fallo.

## Advertencias

Una advertencia representa una situación relevante que no impide continuar.

Ejemplos:

* componente ya instalado;
* versión diferente a la recomendada;
* reinicio pendiente;
* configuración opcional no aplicada;
* servicio deshabilitado voluntariamente.

Las advertencias deberán incluirse en el resumen final.

## Resumen final

Todo módulo deberá generar un resumen breve.

Ejemplo:

```text
Resultado
--------

Git                OK
OpenSSH Server     OK
net-tools          OK
Reinicio           Recomendado

Duración: 1 min 42 s
Log: logs/2026-08-02_143208_system-base.log
```

El resumen podrá utilizar un formato diferente al flujo normal, siempre que siga siendo legible sin color.

## Registro de versiones

Cuando un componente se instale o verifique correctamente, deberá registrarse su versión cuando esté disponible.

Ejemplo:

```text
14:32:18 OK     Git 2.51.0 instalado.
```

La versión deberá obtenerse del sistema, no suponerse a partir de la versión solicitada.

## Operaciones repetidas

Cuando un módulo detecte que una operación ya está realizada, deberá informar claramente.

Ejemplo:

```text
14:32:18 WARN   Git ya estaba instalado.
14:32:18 INFO   Versión detectada: 2.51.0.
```

No se considerará necesariamente un error.

## Modo detallado

La biblioteca podrá admitir un modo detallado o `verbose`.

En ese modo podrá mostrar:

* comandos ejecutados;
* rutas;
* respuestas externas;
* decisiones internas;
* datos adicionales de diagnóstico.

El modo normal deberá permanecer limpio y legible.

## Modo depuración

Podrá existir un modo `debug` separado del modo detallado.

Su objetivo será facilitar el desarrollo de la propia infraestructura.

Los mensajes de depuración no deberán aparecer en ejecuciones normales.

Si se incorpora, deberá definirse el nivel `DEBUG` como interno y no como parte de los cuatro niveles visibles estándar.

## Modo sin color

El sistema deberá admitir explícitamente ejecución sin color.

Ejemplo conceptual:

```bash
NO_COLOR=1
```

o una opción equivalente.

La implementación concreta se definirá posteriormente.

El comportamiento deberá ser compatible con el estándar informal `NO_COLOR` cuando resulte razonable.

## Pipe y redirección

El sistema deberá comportarse correctamente cuando la salida sea:

* redirigida a fichero;
* enviada mediante pipe;
* ejecutada desde CI;
* capturada por otra herramienta.

En estos casos deberá evitar:

* códigos ANSI;
* caracteres de control;
* spinners;
* actualizaciones dinámicas de línea.

## Compatibilidad

La biblioteca deberá funcionar en la plataforma de referencia definida por el proyecto.

No deberá depender de características específicas de una terminal concreta sin detección previa.

## Pruebas

El sistema de logging deberá probar al menos:

* cada nivel;
* consola con color;
* consola sin color;
* redirección a fichero;
* creación del fichero de log;
* error al crear el directorio;
* mensajes con caracteres especiales;
* ejecución desde un módulo;
* ausencia de códigos ANSI en fichero;
* medición de duración;
* enmascarado de información sensible.

## Código generado por IA

Las implementaciones generadas mediante IA deberán respetar este estándar.

No se aceptarán funciones de logging improvisadas en módulos concretos.

Toda mejora deberá realizarse en la biblioteca común y beneficiar al conjunto del sistema.

## Ejemplo completo

```text
14:32:08 INFO   Iniciando módulo system-base.
14:32:08 INFO   Actualizando índices APT...
14:32:11 OK     Índices actualizados.
14:32:11 INFO   Instalando herramientas de red...
14:32:18 WARN   net-tools ya estaba instalado.
14:32:21 OK     Herramientas de red instaladas.
14:32:21 INFO   Verificando OpenSSH Server...
14:32:23 OK     OpenSSH Server activo.
14:32:23 WARN   Se recomienda reiniciar el sistema.
14:32:23 OK     Módulo system-base finalizado en 15 s.
```

## Criterio final

Un buen sistema de logging permite comprender una ejecución sin necesidad de leer el código.

Debe mostrar qué se intentó hacer, qué ocurrió, cuánto tardó y qué debe hacerse después.
