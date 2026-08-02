# Estándar de nomenclatura

## Propósito

Este documento define las convenciones de nombres utilizadas en el proyecto.

El objetivo es que cualquier persona o asistente de IA pueda comprender la función de un elemento únicamente observando su nombre.

La nomenclatura deberá ser:

* coherente;
* descriptiva;
* estable;
* predecible;
* fácil de buscar;
* independiente de preferencias personales.

## Principios generales

Los nombres deberán expresar intención.

Se evitarán:

* abreviaturas ambiguas;
* nombres genéricos;
* sufijos numéricos sin significado;
* términos diferentes para el mismo concepto;
* nombres excesivamente largos;
* referencias a detalles de implementación que puedan cambiar.

Cuando exista un término en el glosario del proyecto, deberá utilizarse siempre ese término.

## Idioma

El código y los nombres técnicos utilizarán inglés.

La documentación explicativa podrá redactarse en castellano.

Ejemplos:

```text
install_package
verify_service
log_error
system_base
```

No se mezclarán idiomas dentro del mismo identificador.

Ejemplos que deben evitarse:

```text
instalar_package
verify_servicio
log_error_instalacion
```

## Directorios

Los nombres de directorios utilizarán minúsculas y guiones cuando contengan varias palabras.

Ejemplos:

```text
system-base/
development-tools/
shared-libraries/
```

Se evitarán:

```text
SystemBase/
system_base/
systemBase/
```

Las excepciones vendrán determinadas por convenciones externas ampliamente aceptadas, como:

```text
R/
.github/
```

## Ficheros

Los nombres de ficheros utilizarán minúsculas y guiones.

Ejemplos:

```text
system-base.sh
install-docker.sh
logging.md
quality-attributes.md
```

Los nombres deberán describir el contenido o la capacidad principal.

Se evitarán nombres genéricos como:

```text
utils.sh
misc.sh
common2.sh
test-final.sh
```

Cuando un fichero represente una capacidad concreta, deberá incluirla en el nombre.

## Scripts ejecutables

Los scripts ejecutables deberán comenzar con un verbo.

Ejemplos:

```text
install-docker.sh
verify-docker.sh
update-system.sh
render-book.R
```

Los scripts coordinadores podrán utilizar nombres como:

```text
install-all.sh
verify-all.sh
```

No se utilizarán nombres ambiguos como:

```text
docker.sh
system.sh
run.sh
```

## Bibliotecas

Las bibliotecas deberán nombrarse por la capacidad que ofrecen.

Ejemplos:

```text
logging.sh
packages.sh
downloads.sh
validation.sh
```

No deberán nombrarse por términos vacíos como:

```text
helpers.sh
misc.sh
stuff.sh
```

Solo se utilizará `common` cuando el contenido sea realmente transversal y no exista una categoría más precisa.

## Funciones

Las funciones utilizarán minúsculas y guion bajo.

Deberán comenzar con un verbo cuando representen una acción.

Ejemplos:

```text
install_package
verify_command
download_file
create_directory
log_error
```

Las funciones que consulten estado podrán utilizar prefijos como:

```text
is_
has_
can_
get_
find_
```

Ejemplos:

```text
is_package_installed
has_command
get_package_version
find_project_root
```

Las funciones booleanas deberán expresar claramente una condición.

Se evitarán nombres como:

```text
check
do_install
process
handle
run_it
```

## Variables

Las variables locales utilizarán minúsculas y guion bajo.

Ejemplos:

```text
package_name
log_file
install_dir
exit_code
```

Los nombres deberán expresar el contenido, no el tipo.

Se evitarán:

```text
str_name
arr_packages
tmp
x
data
```

Las variables de una sola letra solo podrán utilizarse en ámbitos muy pequeños y convencionales.

## Constantes

Las constantes utilizarán mayúsculas y guion bajo.

Ejemplos:

```text
DEFAULT_LOG_DIR
MAX_RETRIES
RETRY_DELAY_SECONDS
```

Toda constante deberá tener un propósito estable y claramente definido.

## Variables de entorno

Las variables de entorno, cuando existan, utilizarán mayúsculas y guion bajo.

Ejemplos:

```text
NO_COLOR
IASI_LOG_LEVEL
IASI_CONFIG_FILE
```

Las variables específicas del proyecto deberán utilizar el prefijo `IASI_` cuando exista riesgo de colisión.

No se crearán variables de entorno cuando una opción local o un parámetro resulte suficiente.

## Parámetros

Los parámetros deberán utilizar nombres descriptivos.

Ejemplos:

```text
package_name
target_version
config_file
```

No se utilizarán parámetros genéricos como:

```text
arg1
value
item
data
```

salvo en funciones muy genéricas donde el significado resulte evidente.

## Módulos

Los módulos utilizarán nombres breves y estables.

Ejemplos:

```text
system-base
docker
nodejs
openspec
ollama
r
rstudio
quarto
```

El nombre del módulo deberá coincidir, siempre que sea posible, en:

* directorios;
* ficheros;
* logs;
* configuración;
* verificación;
* documentación.

Ejemplo:

```text
install/docker.sh
verify/docker.sh
logs/..._docker.log
```

## Requerimientos

Los requerimientos funcionales utilizarán el prefijo:

```text
RF-
```

Ejemplo:

```text
RF-001
RF-002
```

Los requerimientos no funcionales utilizarán:

```text
RNF-
```

Ejemplo:

```text
RNF-001
RNF-002
```

Los identificadores deberán ser estables.

No se reutilizará un identificador eliminado para otro requerimiento.

## ADR

Los ADR utilizarán numeración secuencial.

Ejemplo:

```text
000-template.qmd
001-project-structure.qmd
002-adopt-openspec.qmd
```

El título deberá describir la decisión.

No se cambiará el número de un ADR una vez aceptado.

## Especificaciones

Las especificaciones deberán utilizar nombres basados en capacidades.

Ejemplos:

```text
logging
module-contract
system-base
verification
```

Los cambios deberán comenzar con un verbo.

Ejemplos:

```text
add-logging-library
create-system-base-module
update-version-policy
```

## Logs

Los ficheros de log utilizarán:

```text
YYYY-MM-DD_HHMMSS_module.log
```

Ejemplo:

```text
2026-08-02_143208_system-base.log
```

No incluirán espacios ni caracteres problemáticos.

## Versiones

Las variables o campos relacionados con versiones deberán indicar claramente el componente.

Ejemplos:

```text
docker_version
nodejs_version
quarto_version
```

Se evitará una variable genérica como:

```text
version
```

cuando exista más de un componente en el mismo ámbito.

## Códigos de error

Si se definen constantes para códigos de error, deberán utilizar nombres descriptivos.

Ejemplos:

```text
ERROR_DOWNLOAD_FAILED
ERROR_PERMISSION_DENIED
ERROR_UNSUPPORTED_SYSTEM
```

El número asociado no deberá aparecer disperso por el código.

## Pruebas

Los nombres de pruebas deberán describir el comportamiento esperado.

Ejemplos:

```text
test_install_package_when_missing
test_install_package_when_already_installed
test_log_file_contains_no_ansi_codes
```

Se evitarán:

```text
test1
test_install
test_ok
```

## Nombres reservados

No deberán utilizarse nombres que colisionen con:

* comandos del sistema;
* palabras reservadas del lenguaje;
* funciones comunes de Bash;
* variables especiales;
* herramientas externas relevantes.

Cuando exista duda, se preferirá un nombre más específico.

## Consistencia conceptual

Un mismo concepto deberá mantener el mismo nombre en todo el proyecto.

Por ejemplo, si se adopta `module`, no se alternará con:

```text
component
plugin
unit
package
```

salvo que representen conceptos diferentes.

La consistencia conceptual tendrá prioridad sobre preferencias estilísticas aisladas.

## Renombrado

Un cambio de nombre deberá considerarse cuando:

* el nombre sea ambiguo;
* el alcance haya cambiado;
* exista una inconsistencia;
* el término elegido ya no represente correctamente el concepto.

Los renombrados relevantes deberán actualizar:

* código;
* documentación;
* especificaciones;
* pruebas;
* logs;
* ADR, cuando corresponda.

## Código generado por IA

Los asistentes de IA deberán respetar estas convenciones.

No se aceptarán nombres genéricos, inconsistentes o derivados mecánicamente de prompts.

La revisión deberá comprobar especialmente:

* coherencia terminológica;
* claridad;
* estabilidad;
* coincidencia entre módulos y artefactos relacionados.

## Excepciones

Las excepciones deberán estar justificadas por:

* una convención externa;
* compatibilidad;
* restricciones del lenguaje;
* integración con una herramienta.

Toda excepción deberá limitarse al ámbito mínimo necesario.

## Criterio final

Un buen nombre reduce la necesidad de documentación adicional.

El nombre debe permitir comprender qué representa un elemento, qué responsabilidad tiene y cómo se relaciona con el resto del sistema.
