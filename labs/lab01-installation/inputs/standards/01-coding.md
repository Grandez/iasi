# Estándares de codificación

## Propósito

Este documento define los estándares generales de codificación del proyecto.

Su objetivo es garantizar que todo el código, independientemente de quién lo escriba, mantenga un nivel homogéneo de claridad, calidad y mantenibilidad.

Estas reglas se aplican tanto al código desarrollado manualmente como al generado o modificado mediante asistentes de IA.

Los estándares específicos del lenguaje se documentarán por separado.

## Principios generales

El código deberá priorizar:

1. Claridad.
2. Corrección.
3. Mantenibilidad.
4. Simplicidad.
5. Reutilización.
6. Rendimiento.

El rendimiento solo prevalecerá sobre la claridad cuando exista una necesidad demostrada y documentada.

## Legibilidad

El código deberá poder comprenderse sin necesidad de reconstruir mentalmente su funcionamiento.

Se evitarán:

* construcciones innecesariamente complejas;
* expresiones excesivamente compactas;
* abreviaturas ambiguas;
* efectos secundarios ocultos;
* optimizaciones prematuras;
* comportamientos implícitos difíciles de identificar.

Cuando existan varias soluciones correctas, se elegirá la más sencilla de comprender y mantener.

## Responsabilidad única

Cada módulo, fichero y función deberá tener una responsabilidad clara.

Una función no deberá:

* instalar varios componentes independientes;
* mezclar instalación y verificación sin una razón explícita;
* modificar configuraciones ajenas a su propósito;
* realizar tareas que pertenezcan a otra capa del sistema.

Cuando una función necesite una descripción extensa para explicar lo que hace, deberá considerarse su división.

## Tamaño y complejidad

Las funciones deberán ser pequeñas y estar orientadas a una operación concreta.

No se establece inicialmente un límite rígido de líneas. La división se realizará atendiendo a:

* número de responsabilidades;
* número de decisiones;
* dificultad de prueba;
* dificultad de lectura;
* posibilidad de reutilización.

La complejidad accidental deberá extraerse a funciones auxiliares con nombres descriptivos.

## Reutilización

La lógica compartida deberá implementarse una única vez.

Antes de crear una nueva función se comprobará si ya existe una capacidad equivalente en las bibliotecas comunes.

No se duplicará código para evitar una dependencia legítima.

La reutilización no deberá forzarse cuando produzca abstracciones artificiales o difíciles de comprender.

## Nombres

Los nombres deberán expresar intención.

Se utilizarán:

* sustantivos para datos y entidades;
* verbos para acciones;
* nombres completos frente a abreviaturas ambiguas;
* terminología coherente con el glosario y las especificaciones.

Ejemplos adecuados:

```text
install_package
verify_command
download_file
log_error
package_version
```

Ejemplos que deberán evitarse:

```text
do_it
run_x
tmp2
proc
mgr
data1
```

Las convenciones concretas de mayúsculas, minúsculas y separadores se definirán en el estándar de cada lenguaje.

## Funciones

Toda función deberá:

* realizar una operación reconocible;
* tener un nombre que describa su intención;
* recibir explícitamente los datos que necesita;
* devolver un resultado o código de estado comprensible;
* evitar dependencias ocultas;
* minimizar la modificación de estado global.

Los argumentos deberán validarse cuando su contenido pueda comprometer la ejecución.

Las funciones no deberán asumir silenciosamente que una dependencia, fichero o comando existe.

## Parámetros y configuración

Los valores configurables no deberán quedar dispersos por el código.

Se centralizarán cuando representen:

* versiones;
* rutas;
* nombres de paquetes;
* direcciones de descarga;
* opciones de instalación;
* valores comunes a varios módulos.

No se introducirán valores mágicos sin nombre o explicación.

Ejemplo que debe evitarse:

```text
sleep 7
```

Ejemplo preferido:

```text
RETRY_DELAY_SECONDS=7
```

## Estado global

El uso de estado global deberá reducirse al mínimo.

Las constantes y configuraciones compartidas podrán ser globales cuando su alcance esté claramente definido.

Las variables temporales y de trabajo deberán ser locales a la función o módulo que las utiliza.

Ningún módulo deberá modificar silenciosamente valores globales definidos por otro módulo.

## Gestión de errores

Los errores deberán:

* detectarse lo antes posible;
* propagarse correctamente;
* generar un mensaje comprensible;
* producir un código de salida adecuado;
* evitar que el sistema continúe en un estado inconsistente.

No se ignorarán errores sin una justificación explícita.

Cuando un error pueda recuperarse, el comportamiento deberá estar documentado y quedar reflejado en el registro.

Los mensajes de error deberán indicar, siempre que sea posible:

* qué operación falló;
* cuál fue la causa;
* qué elemento estaba siendo procesado;
* qué acción puede realizar el usuario.

## Códigos de salida

La finalización correcta deberá devolver código `0`.

Los fallos deberán devolver un código distinto de `0`.

Los códigos específicos podrán definirse cuando permitan distinguir categorías de error de forma útil.

Un módulo no deberá devolver éxito si una operación obligatoria ha fallado.

## Logging

Todo mensaje operativo deberá utilizar la biblioteca común de logging.

No se escribirán mensajes directamente en consola salvo:

* durante el desarrollo puntual;
* en la propia implementación de la biblioteca de logging;
* cuando exista una excepción expresamente documentada.

El formato, los niveles, los colores, la salida a consola y la persistencia en fichero se definirán en `logging.md` y `console.md`.

## Comentarios

Los comentarios deberán explicar:

* por qué se toma una decisión;
* por qué una solución aparentemente extraña es necesaria;
* qué restricción externa condiciona el código;
* qué riesgo debe evitarse.

No deberán limitarse a repetir lo que el código ya expresa.

Ejemplo que debe evitarse:

```text
Incrementar contador en uno.
```

Ejemplo útil:

```text
Se limita el número de intentos para evitar un bloqueo indefinido
cuando el repositorio remoto no está disponible.
```

El código deberá ser suficientemente claro para no depender de comentarios explicativos en cada línea.

## Documentación de funciones

Las funciones públicas y reutilizables deberán documentar:

* propósito;
* parámetros;
* resultado;
* códigos de salida;
* efectos secundarios;
* dependencias relevantes.

Las funciones privadas sencillas podrán prescindir de documentación formal cuando su nombre y estructura sean suficientes para comprenderlas.

## Dependencias

Toda dependencia deberá ser:

* necesaria;
* explícita;
* verificable;
* mantenida;
* compatible con las restricciones del proyecto.

No se añadirá una dependencia externa para resolver una operación trivial que pueda implementarse de forma clara y segura con las capacidades ya disponibles.

Las dependencias entre módulos deberán declararse y no deducirse únicamente del orden de ejecución.

## Idempotencia

Las operaciones deberán diseñarse para poder repetirse con seguridad.

Antes de modificar el sistema, el código deberá comprobar el estado existente cuando resulte razonable.

Una segunda ejecución deberá:

* reconocer componentes ya instalados;
* evitar duplicar configuraciones;
* no corromper archivos existentes;
* no provocar fallos innecesarios;
* informar claramente de la situación encontrada.

## Verificación

Toda operación relevante deberá poder verificarse.

Instalar un paquete no demuestra que la capacidad esté disponible.

La verificación podrá incluir:

* existencia de comandos;
* consulta de versiones;
* estado de servicios;
* comprobación de configuración;
* ejecución de una prueba mínima;
* validación de permisos.

La lógica de instalación y la lógica de verificación deberán poder ejecutarse separadamente.

## Seguridad

El código deberá aplicar el principio de mínimo privilegio.

Se evitará:

* ejecutar el módulo completo como `root`;
* mantener privilegios elevados más tiempo del necesario;
* descargar y ejecutar contenido sin validación;
* incluir secretos en el código;
* exponer información sensible en logs;
* modificar configuraciones del usuario sin consentimiento.

Toda descarga deberá proceder de una fuente definida por las políticas del proyecto.

## Entrada de datos

Las entradas externas deberán considerarse no confiables.

Se validarán especialmente:

* argumentos;
* variables de configuración;
* rutas;
* nombres de paquetes;
* URLs;
* contenido descargado;
* valores proporcionados por el usuario.

No se construirán comandos mediante concatenación insegura de entradas externas.

## Salida y efectos secundarios

Todo efecto secundario deberá ser evidente.

El código deberá indicar cuándo:

* instala software;
* modifica un fichero;
* habilita un servicio;
* cambia permisos;
* añade un repositorio;
* altera la configuración del usuario.

Siempre que sea posible, se informará antes de realizar cambios especialmente relevantes.

## Ficheros y rutas

Las rutas deberán construirse mediante mecanismos adecuados al lenguaje.

No deberán depender accidentalmente del directorio de trabajo, salvo que esa dependencia forme parte de un contrato explícito.

Los módulos no escribirán fuera de los directorios previstos sin una necesidad documentada.

La modificación de archivos existentes deberá realizarse de forma segura y, cuando proceda, con copia de respaldo.

## Compatibilidad

El código deberá respetar la plataforma y versiones definidas por el proyecto.

No se introducirán soluciones específicas de otra distribución o versión sin:

* detección previa;
* aislamiento;
* documentación;
* una necesidad real.

## Formato

Todo el código deberá seguir un formato homogéneo.

Cuando exista una herramienta automática estable para el lenguaje utilizado, se considerará su incorporación.

El formato no deberá depender de preferencias personales de cada colaborador.

## Análisis estático

Siempre que resulte razonable, el código será validado mediante herramientas de análisis estático.

Las advertencias deberán:

* corregirse;
* justificarse;
* o suprimirse de manera localizada y documentada.

No se desactivarán reglas globalmente para ocultar problemas puntuales.

## Pruebas

Las funciones y módulos deberán diseñarse para ser comprobables.

Las pruebas deberán cubrir al menos:

* ejecución correcta;
* repetición de la operación;
* componente ya instalado;
* dependencia ausente;
* fallo de descarga;
* fallo de permisos;
* parámetros inválidos;
* verificación negativa.

Los detalles se definirán en `testing.md`.

## Código generado por IA

El código generado por una IA estará sujeto a los mismos estándares que el código humano.

Antes de aceptarlo deberá revisarse:

* su correspondencia con la especificación;
* su seguridad;
* sus dependencias;
* su manejo de errores;
* su idempotencia;
* su legibilidad;
* sus pruebas;
* su coherencia con la arquitectura.

No se aceptará código únicamente porque funcione en una ejecución inicial.

La autoría asistida por IA no modifica la responsabilidad sobre el resultado.

## Cambios

Todo cambio deberá ser coherente con:

* los requerimientos;
* la arquitectura;
* las restricciones;
* los estándares;
* las especificaciones vigentes.

Cuando una modificación contradiga una decisión existente, deberá actualizarse la documentación correspondiente y, si procede, registrarse mediante un ADR.

## Excepciones

Estos estándares podrán incumplirse únicamente cuando exista una razón técnica justificada.

Toda excepción deberá:

* ser explícita;
* limitarse al ámbito mínimo;
* documentar su motivación;
* explicar sus consecuencias;
* indicar si es temporal o permanente.

## Criterio final

El código correcto no es únicamente el que funciona.

Debe poder ser comprendido, verificado, repetido, mantenido y modificado con seguridad por otra persona o por otro asistente de IA.
