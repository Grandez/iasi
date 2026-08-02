# Estándar de Shell

## Propósito

Este documento define las convenciones de implementación para los scripts Shell del proyecto.

La plataforma objetivo utiliza Bash como intérprete de referencia.

El objetivo es garantizar que todos los scripts sean:

* seguros;
* legibles;
* predecibles;
* mantenibles;
* verificables;
* compatibles con la plataforma definida.

Este estándar complementa los documentos generales de codificación, nomenclatura, logging y consola.

## Intérprete

Todos los scripts ejecutables deberán utilizar:

```bash
#!/usr/bin/env bash
```

No se utilizará:

```bash
#!/bin/sh
```

cuando el script dependa de características específicas de Bash.

Los scripts deberán ejecutarse mediante Bash y no asumir compatibilidad con otros intérpretes.

## Modo estricto

Los scripts ejecutables deberán comenzar, salvo excepción justificada, con:

```bash
set -Eeuo pipefail
```

Significado:

* `-E`: propaga las trampas de error a funciones y subshells.
* `-e`: interrumpe la ejecución ante errores no controlados.
* `-u`: considera error el uso de variables no definidas.
* `-o pipefail`: hace fallar una tubería cuando falla cualquiera de sus comandos.

El uso de modo estricto no sustituye a la gestión explícita de errores.

Los casos donde un fallo sea esperado deberán controlarse de forma consciente.

## Separador de campos

Cuando resulte necesario reducir riesgos asociados a la expansión de palabras, podrá utilizarse:

```bash
IFS=$'\n\t'
```

No deberá modificarse globalmente sin una razón clara.

Siempre que sea posible se preferirá el uso correcto de arrays y comillas.

## Estructura básica

Todo script ejecutable deberá seguir una estructura reconocible:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

main() {
    # Flujo principal.
}

main "$@"
```

La lógica principal deberá residir en funciones.

Se evitará ejecutar operaciones complejas directamente en el ámbito global.

## Función `main`

Los scripts ejecutables deberán disponer de una función `main`.

`main` será responsable de:

* validar argumentos;
* inicializar el módulo;
* coordinar las operaciones;
* ejecutar verificaciones;
* generar el resultado final;
* devolver el código de salida correspondiente.

Ejemplo:

```bash
main() {
    validate_arguments "$@"
    initialize_module
    install_component
    verify_component
    finalize_module
}

main "$@"
```

## Ámbito global

En el ámbito global solo deberán aparecer:

* configuración;
* constantes;
* carga de bibliotecas;
* definición de funciones;
* instalación de trampas;
* llamada final a `main`.

No deberán ejecutarse instalaciones, descargas o modificaciones del sistema antes de entrar en `main`.

## Variables locales

Las variables declaradas dentro de funciones deberán utilizar `local`.

Ejemplo:

```bash
install_package() {
    local package_name="$1"
    local exit_code
}
```

No se utilizarán variables globales para almacenar datos temporales.

## Variables de solo lectura

Las constantes y valores que no deban modificarse podrán declararse mediante:

```bash
readonly DEFAULT_LOG_DIR="logs"
```

o:

```bash
declare -r DEFAULT_LOG_DIR="logs"
```

Las constantes deberán seguir el estándar de nomenclatura definido en `naming.md`.

## Comillas

Las expansiones de variables deberán ir entre comillas dobles salvo cuando exista una razón explícita para no hacerlo.

Correcto:

```bash
mkdir -p "$target_dir"
cp "$source_file" "$target_dir/"
```

Debe evitarse:

```bash
mkdir -p $target_dir
cp $source_file $target_dir/
```

Las comillas simples se utilizarán cuando el contenido deba interpretarse literalmente.

## Sustitución de comandos

Se utilizará:

```bash
current_version="$(command --version)"
```

No se utilizará la sintaxis antigua:

```bash
current_version=`command --version`
```

La sustitución moderna es más legible y permite anidamiento.

## Comparaciones

Para condiciones Bash se utilizará preferentemente:

```bash
[[ ... ]]
```

Ejemplo:

```bash
if [[ -f "$config_file" ]]; then
    ...
fi
```

No se utilizará `[` salvo cuando exista una necesidad concreta de portabilidad POSIX.

## Operadores lógicos

Dentro de `[[ ... ]]` se utilizarán:

```bash
&&
||
```

Ejemplo:

```bash
if [[ -n "$value" && -f "$file" ]]; then
    ...
fi
```

Las condiciones complejas deberán dividirse cuando su lectura resulte difícil.

## Comparaciones de cadenas

Se utilizarán:

```bash
[[ "$value" == "expected" ]]
[[ "$value" != "expected" ]]
[[ -z "$value" ]]
[[ -n "$value" ]]
```

No se omitirán las comillas en expansiones de variables.

## Comparaciones numéricas

Dentro de `(( ... ))` podrán utilizarse operadores aritméticos.

Ejemplo:

```bash
if (( retry_count >= MAX_RETRIES )); then
    ...
fi
```

También podrán utilizarse operadores como `-eq`, `-ne`, `-lt`, `-le`, `-gt` y `-ge` cuando mejoren la claridad.

## Arrays

Cuando exista una colección de elementos se utilizarán arrays Bash.

Ejemplo:

```bash
packages=(
    ca-certificates
    curl
    git
    wget
)
```

Instalación:

```bash
apt_install "${packages[@]}"
```

No se almacenarán listas en cadenas separadas por espacios.

Debe evitarse:

```bash
packages="curl git wget"
```

## Arrays asociativos

Podrán utilizarse arrays asociativos cuando representen relaciones clave-valor y mejoren claramente el diseño.

Ejemplo:

```bash
declare -A component_versions=(
    [git]="2.51.0"
    [docker]="29.0.0"
)
```

No se utilizarán como sustituto de una estructura de configuración más adecuada cuando el volumen de datos crezca.

## Argumentos

Los argumentos posicionales deberán validarse antes de utilizarlos.

Ejemplo:

```bash
if (( $# < 1 )); then
    log_error "Falta el nombre del paquete."
    return 2
fi
```

Las funciones deberán asignar argumentos a variables con nombres descriptivos:

```bash
local package_name="$1"
```

No deberán utilizar repetidamente `$1`, `$2` o `$3` en el cuerpo de una función larga.

## Opciones de línea de comandos

Los scripts que acepten opciones deberán mantener una interfaz coherente.

Opciones previstas:

```text
--help
--verbose
--debug
--no-color
--dry-run
--version
```

La incorporación de opciones adicionales deberá respetar el estándar de nomenclatura.

Cuando el análisis de argumentos crezca, se centralizará en una función específica.

## Ayuda

Todo script ejecutable público deberá admitir:

```bash
--help
```

La ayuda deberá incluir:

* propósito;
* sintaxis;
* argumentos;
* opciones;
* ejemplos;
* códigos de salida relevantes.

## Códigos de salida

Se utilizará:

```text
0
```

para éxito.

Los fallos deberán devolver valores distintos de cero.

Se reservarán códigos coherentes para categorías habituales cuando aporten valor.

Ejemplo inicial:

| Código | Significado                |
| -----: | -------------------------- |
|    `0` | Ejecución correcta         |
|    `1` | Error general              |
|    `2` | Uso o argumentos inválidos |
|    `3` | Dependencia ausente        |
|    `4` | Plataforma no soportada    |
|    `5` | Error de permisos          |
|   `10` | Error de instalación       |
|   `11` | Error de verificación      |

La tabla definitiva deberá centralizarse y documentarse.

## `return` y `exit`

Las funciones deberán utilizar `return`.

Los scripts deberán utilizar `exit` únicamente en:

* `main`;
* trampas globales;
* errores irrecuperables de inicialización.

Una biblioteca cargada mediante `source` no deberá ejecutar `exit`, porque finalizaría el proceso llamador.

## Bibliotecas

Las bibliotecas Bash deberán:

* contener únicamente funciones, constantes y configuración;
* no ejecutar operaciones al cargarse;
* no llamar a `exit`;
* no modificar el sistema;
* documentar sus dependencias.

La carga deberá realizarse de forma explícita:

```bash
source "$LIB_DIR/logging.sh"
source "$LIB_DIR/packages.sh"
```

## Resolución de rutas

Los scripts no deberán depender accidentalmente del directorio actual.

La raíz del propio script podrá calcularse mediante:

```bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
```

Las rutas internas deberán construirse a partir de una referencia conocida.

Ejemplo:

```bash
readonly PROJECT_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
readonly LIB_DIR="$PROJECT_ROOT/lib"
```

La detección de rutas deberá centralizarse cuando sea compartida por varios módulos.

## Uso de `source`

La carga de bibliotecas deberá comprobar que el fichero existe.

Ejemplo:

```bash
if [[ ! -r "$logging_library" ]]; then
    printf 'No se puede leer la biblioteca: %s\n' "$logging_library" >&2
    exit 3
fi

source "$logging_library"
```

Antes de cargar la biblioteca de logging podrá utilizarse `printf` para informar de errores de inicialización.

## `printf` frente a `echo`

Se utilizará preferentemente `printf`.

Ejemplo:

```bash
printf '%s\n' "$message"
```

`echo` presenta diferencias de comportamiento entre implementaciones y puede interpretar opciones o secuencias especiales.

Los módulos no deberán utilizar directamente ni `printf` ni `echo` para mensajes operativos una vez inicializada la biblioteca de logging.

## Logging

Todos los mensajes operativos deberán pasar por las funciones comunes:

```bash
log_info
log_ok
log_warn
log_error
```

No se implementarán colores, timestamps o formatos directamente en cada módulo.

## Manejo de errores

Los errores esperados deberán controlarse explícitamente.

Ejemplo:

```bash
if ! download_file "$url" "$target"; then
    log_error "No se pudo descargar el fichero."
    return 10
fi
```

No se dependerá exclusivamente de `set -e`.

## Comandos cuyo fallo es esperado

Cuando un comando pueda fallar como parte de una comprobación, deberá utilizarse dentro de una condición.

Correcto:

```bash
if command -v git >/dev/null 2>&1; then
    ...
fi
```

Debe evitarse:

```bash
command -v git
```

si el fallo esperado pudiera interrumpir el script por `set -e`.

## Tuberías

Las tuberías deberán utilizarse con cuidado.

Gracias a `pipefail`, un fallo interno deberá propagarse.

Ejemplo:

```bash
if ! output="$(command_a | command_b)"; then
    log_error "La tubería falló."
    return 1
fi
```

No deberán ocultarse errores mediante tuberías innecesarias.

## Redirecciones

Las redirecciones deberán ser explícitas.

Ejemplos:

```bash
command >"$output_file"
command 2>"$error_file"
command >>"$log_file" 2>&1
```

Los nombres de fichero siempre deberán ir entre comillas.

## Ficheros temporales

Se utilizará `mktemp`.

Ejemplo:

```bash
temporary_file="$(mktemp)"
```

Los ficheros temporales deberán eliminarse mediante una trampa.

```bash
cleanup() {
    rm -f -- "$temporary_file"
}

trap cleanup EXIT
```

No se utilizarán nombres temporales predecibles en `/tmp`.

## Trampas

Los scripts deberán considerar trampas para:

* errores;
* salida;
* interrupción;
* terminación.

Ejemplo:

```bash
trap 'handle_error "$?" "$LINENO"' ERR
trap cleanup EXIT
trap 'handle_interrupt' INT TERM
```

Las trampas deberán ser simples y no ocultar el error original.

## Limpieza

Todo recurso temporal deberá limpiarse cuando finalice el script.

Esto incluye:

* ficheros temporales;
* directorios temporales;
* bloqueos;
* montajes temporales;
* procesos auxiliares.

La limpieza no deberá eliminar artefactos necesarios para el diagnóstico.

## Comandos externos

Antes de utilizar un comando externo obligatorio deberá comprobarse su existencia.

Ejemplo:

```bash
require_command curl
```

Las comprobaciones comunes deberán centralizarse en una biblioteca.

## Ejecución de comandos

Los comandos deberán ejecutarse directamente, no mediante cadenas construidas y `eval`.

Correcto:

```bash
command_args=(
    apt-get
    install
    -y
    "$package_name"
)

"${command_args[@]}"
```

Debe evitarse:

```bash
command_string="apt-get install -y $package_name"
eval "$command_string"
```

`eval` no se utilizará salvo una necesidad excepcional y documentada.

## Seguridad de entradas

Las entradas externas deberán validarse antes de incorporarse a:

* comandos;
* rutas;
* URLs;
* nombres de paquetes;
* configuraciones.

No se aceptarán valores arbitrarios cuando exista un conjunto limitado de opciones válidas.

## Uso de `sudo`

Los scripts no deberán ejecutarse íntegramente como `root`.

Cada operación privilegiada deberá invocar `sudo` únicamente cuando resulte necesario.

Ejemplo:

```bash
sudo apt-get update
sudo install -m 0644 "$source_file" "$target_file"
```

La biblioteca podrá proporcionar una función para comprobar anticipadamente la disponibilidad de `sudo`.

## Ejecución como `root`

Los scripts orientados a usuario deberán detectar la ejecución como `root`.

Comportamiento recomendado:

```bash
if (( EUID == 0 )); then
    log_error "Este script no debe ejecutarse como root."
    return 5
fi
```

Las excepciones deberán estar documentadas.

## Renovación de credenciales `sudo`

En ejecuciones largas podrá mantenerse activa la autorización de `sudo` de manera controlada.

La implementación deberá:

* ser opcional;
* finalizar al terminar el script;
* no ocultar solicitudes de contraseña;
* estar documentada.

## APT

Los scripts automatizados deberán utilizar una interfaz adecuada para scripting.

Para automatización se preferirá:

```bash
apt-get
```

frente a:

```bash
apt
```

`apt` está orientado principalmente a uso interactivo y su interfaz puede cambiar.

Las decisiones concretas de instalación se documentarán en el estándar de paquetes.

## Instalación no interactiva

Las instalaciones automatizadas deberán evitar bloqueos por preguntas interactivas.

Podrá utilizarse:

```bash
DEBIAN_FRONTEND=noninteractive
```

solo para el ámbito del comando necesario.

Ejemplo:

```bash
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}"
```

No se exportará globalmente sin necesidad.

## Actualización de índices

La actualización de índices APT deberá centralizarse para evitar repetirla innecesariamente.

Los módulos no deberán ejecutar cada uno:

```bash
sudo apt-get update
```

sin coordinación.

La infraestructura podrá registrar cuándo se actualizó por última vez durante la ejecución.

## Repositorios

La incorporación de repositorios deberá:

* utilizar fuentes oficiales;
* instalar claves de forma segura;
* evitar `apt-key`;
* crear ficheros específicos en `sources.list.d`;
* verificar arquitectura y distribución;
* ser idempotente.

## Descargas

Las descargas deberán:

* utilizar HTTPS;
* fallar ante errores HTTP;
* incluir reintentos razonables;
* guardar en ficheros temporales;
* validar integridad cuando exista checksum o firma.

Ejemplo conceptual con `curl`:

```bash
curl \
    --fail \
    --location \
    --retry 3 \
    --show-error \
    --silent \
    --output "$target_file" \
    "$url"
```

La lógica deberá centralizarse en una biblioteca.

## `curl` y `wget`

Se elegirá una herramienta principal para descargas automatizadas.

La otra podrá instalarse como utilidad del sistema, pero no deberá existir una mezcla arbitraria entre módulos.

La elección definitiva deberá documentarse.

## Escritura de ficheros

Para crear ficheros con privilegios se evitará:

```bash
sudo echo "contenido" > /etc/example.conf
```

porque la redirección no se ejecuta bajo `sudo`.

Se utilizará:

```bash
printf '%s\n' "contenido" | sudo tee /etc/example.conf >/dev/null
```

o preferentemente:

```bash
sudo install -m 0644 "$temporary_file" /etc/example.conf
```

## Heredocs

Los heredocs podrán utilizarse para generar configuraciones legibles.

Ejemplo:

```bash
cat <<'EOF' >"$temporary_file"
setting=value
EOF
```

Se utilizará un delimitador entre comillas cuando no deba existir expansión de variables.

## Modificación de configuraciones

Antes de modificar un fichero existente deberá evaluarse:

* si ya contiene la configuración;
* si la modificación es idempotente;
* si debe crearse una copia de seguridad;
* si pertenece al usuario o al sistema.

No se añadirán líneas repetidas mediante `>>` sin comprobación previa.

## Servicios

La gestión de servicios utilizará `systemctl` en la plataforma de referencia.

Ejemplo:

```bash
sudo systemctl enable --now ssh
```

La instalación deberá verificar posteriormente:

```bash
systemctl is-active --quiet ssh
```

y, cuando proceda:

```bash
systemctl is-enabled --quiet ssh
```

## Usuarios y grupos

Antes de añadir un usuario a un grupo deberá comprobarse el estado actual.

Ejemplo:

```bash
if ! id -nG "$USER" | grep -qw docker; then
    sudo usermod -aG docker "$USER"
fi
```

La comprobación deberá evitar falsos positivos.

Los cambios que requieran cerrar sesión deberán comunicarse.

## Permisos

Los permisos deberán establecerse explícitamente cuando sea relevante.

Se evitará:

```bash
chmod 777
```

salvo un caso excepcional, justificado y documentado.

Se aplicará el principio de mínimo privilegio.

## Umask

Los scripts que creen ficheros sensibles podrán establecer temporalmente una `umask` restrictiva.

Ejemplo:

```bash
umask 077
```

No deberá modificarse globalmente sin considerar sus efectos.

## Idempotencia

Todo script deberá comprobar el estado antes de modificarlo.

Ejemplos:

* verificar si un paquete está instalado;
* verificar si existe un repositorio;
* verificar si una línea ya está presente;
* verificar si un servicio está habilitado;
* comprobar la versión existente.

Una segunda ejecución deberá producir un resultado estable y comprensible.

## Verificación

Todo módulo de instalación deberá invocar o asociar una verificación.

La verificación no deberá limitarse únicamente a comprobar un código de salida de APT.

Deberá confirmar la capacidad instalada.

Ejemplos:

```bash
git --version
docker --version
systemctl is-active docker
```

## Modo `dry-run`

Cuando se implemente, el modo `dry-run` deberá mostrar qué operaciones se realizarían sin modificar el sistema.

Todas las funciones con efectos secundarios deberán respetarlo.

La implementación no deberá limitarse a saltarse arbitrariamente algunas órdenes.

## Salida detallada

Los comandos verbosos deberán integrarse con los modos normal, verbose y debug.

En modo normal:

* se mostrará el progreso relevante;
* la salida extensa se enviará al log.

En modo verbose:

* podrá mostrarse información adicional.

En modo debug:

* podrán mostrarse comandos y decisiones internas.

## Formateo

La indentación será de cuatro espacios.

No se utilizarán tabuladores para indentar.

Las líneas deberán mantenerse razonablemente breves.

Cuando un comando tenga varios argumentos, se dividirá:

```bash
curl \
    --fail \
    --location \
    --retry 3 \
    --output "$target_file" \
    "$url"
```

Los arrays se escribirán con un elemento por línea cuando mejoren la lectura.

## Punto y coma

No se agruparán varias órdenes en una misma línea mediante `;` salvo en expresiones pequeñas y claras.

Debe evitarse:

```bash
do_one; do_two; do_three
```

Se preferirá una orden por línea.

## Funciones compactas

No se utilizarán funciones de una sola línea cuando reduzcan la legibilidad.

Debe evitarse:

```bash
is_installed() { command -v "$1" >/dev/null 2>&1; }
```

Se preferirá:

```bash
is_installed() {
    command -v "$1" >/dev/null 2>&1
}
```

## `case`

Para conjuntos discretos de opciones se preferirá `case`.

Ejemplo:

```bash
case "$log_level" in
    INFO|OK|WARN|ERROR)
        ;;
    *)
        return 2
        ;;
esac
```

## Bucles

Los bucles deberán iterar sobre arrays correctamente.

Ejemplo:

```bash
for package_name in "${packages[@]}"; do
    install_package "$package_name"
done
```

Debe evitarse iterar sobre la salida de `ls`.

Incorrecto:

```bash
for file in $(ls "$directory"); do
    ...
done
```

Se utilizarán globbing, arrays o `find` con tratamiento seguro.

## Lectura de líneas

Para leer ficheros línea a línea se utilizará:

```bash
while IFS= read -r line; do
    ...
done <"$input_file"
```

Se evitará perder barras invertidas o espacios.

## `find`

Cuando se procesen nombres de fichero potencialmente complejos deberá utilizarse separación nula.

Ejemplo:

```bash
while IFS= read -r -d '' file_path; do
    ...
done < <(find "$directory" -type f -print0)
```

## Expansión de glob

Los patrones deberán utilizarse conscientemente.

Cuando la ausencia de coincidencias pueda producir resultados incorrectos, se considerará:

```bash
shopt -s nullglob
```

El cambio deberá limitarse al ámbito necesario o documentarse.

## Compatibilidad de versión

El proyecto deberá definir una versión mínima de Bash compatible con Kubuntu de referencia.

No se utilizarán características posteriores sin:

* comprobar la versión;
* justificar la necesidad;
* actualizar la restricción del proyecto.

## ShellCheck

Todos los scripts deberán analizarse mediante ShellCheck.

Las advertencias deberán corregirse.

Las supresiones se permitirán únicamente cuando:

* exista una razón clara;
* se apliquen de forma localizada;
* incluyan una explicación.

Ejemplo:

```bash
# shellcheck disable=SC1091
source "$library_file"
```

No se desactivarán reglas globalmente para silenciar problemas.

## Formateador

Se evaluará el uso de `shfmt` para garantizar un formato uniforme.

Si se adopta, su configuración deberá formar parte del repositorio.

El formateo automático no sustituye a la revisión de legibilidad.

## Pruebas

Las funciones Bash deberán diseñarse para poder probarse de manera aislada.

Se evaluará el uso de una herramienta como Bats para pruebas automatizadas.

Las pruebas deberán cubrir:

* ejecución correcta;
* errores;
* idempotencia;
* argumentos inválidos;
* dependencias ausentes;
* fallos de permisos;
* comportamiento sin color;
* modo no interactivo;
* limpieza de recursos.

## Código generado por IA

Todo código Bash generado mediante IA deberá revisarse especialmente para detectar:

* expansiones sin comillas;
* uso innecesario de `eval`;
* errores ocultos por `set -e`;
* tuberías inseguras;
* uso incorrecto de `sudo`;
* modificaciones no idempotentes;
* descargas sin validación;
* pérdida de códigos de salida;
* dependencias implícitas;
* incompatibilidades con ShellCheck.

No se aceptará un script únicamente porque funcione una vez en el sistema del desarrollador.

## Excepciones

Toda excepción a este estándar deberá:

* estar justificada;
* limitarse al mínimo;
* documentarse junto al código;
* indicar los riesgos;
* incluir pruebas específicas cuando proceda.

## Criterio final

Un buen script Bash no es una secuencia de comandos que consigue terminar.

Es un componente de software que puede ejecutarse, repetirse, diagnosticarse, verificarse y mantenerse con seguridad.
