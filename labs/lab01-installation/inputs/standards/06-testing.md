# Estándar de pruebas

## Propósito

Este documento define la estrategia de pruebas del proyecto.

El objetivo es garantizar que los módulos de instalación sean:

* correctos;
* repetibles;
* verificables;
* seguros;
* mantenibles;
* resistentes a fallos previsibles.

Las pruebas deberán validar tanto la lógica interna como el comportamiento real sobre la plataforma de referencia.

## Principios

Las pruebas deberán:

* detectar errores lo antes posible;
* ejecutarse de forma reproducible;
* estar automatizadas siempre que resulte razonable;
* verificar comportamiento, no únicamente implementación;
* cubrir escenarios correctos y escenarios de fallo;
* formar parte del desarrollo del módulo;
* acompañar a toda funcionalidad relevante.

Una funcionalidad no deberá considerarse terminada únicamente porque funcione una vez en el equipo del desarrollador.

## Alcance

La estrategia incluirá:

1. Análisis estático.
2. Pruebas unitarias.
3. Pruebas de integración.
4. Pruebas de módulo.
5. Pruebas de idempotencia.
6. Pruebas del sistema completo.
7. Pruebas en instalación limpia.
8. Pruebas de regresión.
9. Validación manual cuando sea necesaria.

## Pirámide de pruebas

La mayor parte de las comprobaciones deberán ejecutarse en niveles rápidos y aislados.

```text
                 Pruebas completas
               e instalación limpia
                       /\
                      /  \
                     /    \
              Pruebas de módulo
                   e integración
                 /              \
                /                \
        Pruebas unitarias y análisis
```

Las pruebas completas son necesarias, pero no deberán sustituir a las pruebas pequeñas y rápidas.

## Análisis estático

Todo script Bash deberá analizarse con ShellCheck.

Ejemplo:

```bash
shellcheck scripts/**/*.sh
```

Las advertencias deberán:

* corregirse;
* justificarse;
* o suprimirse de forma localizada.

No se aceptará una supresión global destinada únicamente a obtener una ejecución sin advertencias.

También deberá comprobarse la sintaxis:

```bash
bash -n script.sh
```

Una validación sintáctica correcta no demuestra que el script funcione, pero constituye una condición mínima.

## Formato

Cuando se adopte `shfmt`, deberá comprobarse que los scripts cumplen el formato definido.

Ejemplo:

```bash
shfmt -d scripts/
```

El formateo no constituye una prueba funcional, pero reduce variaciones innecesarias y facilita la revisión.

## Pruebas unitarias

Las funciones reutilizables deberán probarse de forma aislada.

Ejemplos:

* generación de timestamps;
* formateo de mensajes;
* detección de comandos;
* comparación de versiones;
* validación de argumentos;
* construcción de rutas;
* detección de paquetes instalados;
* enmascarado de secretos;
* interpretación de códigos de salida.

Las pruebas unitarias no deberán:

* instalar paquetes reales;
* modificar configuraciones del sistema;
* requerir privilegios;
* depender de conexión a Internet;
* alterar el entorno del desarrollador.

## Framework de pruebas

Se evaluará Bats como framework de referencia para pruebas Bash.

Estructura inicial:

```text
tests/
├── unit/
├── integration/
├── modules/
├── fixtures/
├── helpers/
└── system/
```

Ejemplo conceptual:

```bash
@test "log_info incluye la marca temporal" {
    run log_info "Mensaje de prueba"

    [ "$status" -eq 0 ]
    [[ "$output" =~ ^[0-9]{2}:[0-9]{2}:[0-9]{2} ]]
}
```

La herramienta definitiva deberá documentarse mediante una decisión explícita.

## Aislamiento

Cada prueba deberá poder ejecutarse de forma independiente.

Una prueba no deberá depender del resultado de otra.

Las pruebas deberán restaurar el estado que modifiquen.

Los ficheros temporales se crearán mediante mecanismos seguros y se eliminarán al finalizar.

Ejemplo:

```bash
setup() {
    TEST_DIR="$(mktemp -d)"
}

teardown() {
    rm -rf -- "$TEST_DIR"
}
```

## Dobles de prueba

Las dependencias externas podrán sustituirse mediante:

* mocks;
* stubs;
* fakes;
* comandos simulados;
* fixtures.

Ejemplos de dependencias que podrán simularse:

* `curl`;
* `apt-get`;
* `systemctl`;
* `sudo`;
* `git`;
* servicios remotos;
* respuestas HTTP;
* consultas de versión.

Los dobles deberán reproducir únicamente el comportamiento necesario para la prueba.

No deberán convertirse en implementaciones paralelas del sistema real.

## Manipulación de `PATH`

Para probar comandos externos podrá utilizarse un directorio temporal incluido al inicio de `PATH`.

Ejemplo conceptual:

```bash
TEST_BIN="$TEST_DIR/bin"
mkdir -p "$TEST_BIN"
export PATH="$TEST_BIN:$PATH"
```

Dentro del directorio podrán crearse ejecutables simulados:

```bash
cat >"$TEST_BIN/curl" <<'EOF'
#!/usr/bin/env bash
exit 22
EOF

chmod +x "$TEST_BIN/curl"
```

Esto permitirá probar errores sin depender de servicios reales.

## Fixtures

Los datos de prueba reutilizables deberán almacenarse en:

```text
tests/fixtures/
```

Ejemplos:

* configuraciones válidas;
* configuraciones inválidas;
* respuestas de comandos;
* ficheros de repositorios;
* checksums;
* salidas de versiones;
* logs esperados.

Las fixtures deberán ser pequeñas, comprensibles y estables.

## Pruebas de logging

El sistema de logging deberá comprobar al menos:

* nivel `INFO`;
* nivel `OK`;
* nivel `WARN`;
* nivel `ERROR`;
* formato de hora;
* formato de fecha;
* alineación;
* salida con color;
* salida sin color;
* ausencia de ANSI en fichero;
* nombre del módulo;
* creación del directorio;
* creación del fichero;
* redirección;
* mensajes con caracteres especiales;
* enmascarado de secretos;
* duración de operaciones.

Ejemplo:

```bash
@test "el fichero de log no contiene secuencias ANSI" {
    run execute_logging_test

    [ "$status" -eq 0 ]
    ! grep -Eq $'\033\\[[0-9;]*m' "$LOG_FILE"
}
```

## Pruebas de consola

La interfaz de consola deberá probar:

* cabecera;
* títulos;
* alineación;
* resumen;
* resultado final;
* terminal con color;
* terminal sin color;
* salida redirigida;
* modo no interactivo;
* anchura reducida;
* mensajes de error;
* confirmaciones;
* cancelación por el usuario.

La estética deberá validarse principalmente mediante pruebas manuales o snapshots cuando resulte práctico.

## Pruebas de argumentos

Todo script público deberá probar:

* ausencia de argumentos obligatorios;
* argumentos válidos;
* argumentos desconocidos;
* opciones incompatibles;
* `--help`;
* `--version`;
* `--verbose`;
* `--debug`;
* `--no-color`;
* `--dry-run`, cuando exista.

Los errores de uso deberán devolver el código de salida definido para argumentos inválidos.

## Pruebas de códigos de salida

Las pruebas deberán validar expresamente los códigos de salida.

Ejemplo:

```bash
@test "devuelve 3 cuando falta una dependencia" {
    run execute_module_without_dependency

    [ "$status" -eq 3 ]
}
```

No deberá considerarse suficiente comprobar únicamente el texto mostrado.

## Pruebas de errores

Cada operación relevante deberá probar sus fallos previsibles.

Ejemplos:

* falta de conexión;
* URL inválida;
* checksum incorrecto;
* permiso denegado;
* paquete inexistente;
* repositorio no disponible;
* comando ausente;
* servicio que no inicia;
* configuración inválida;
* disco sin espacio;
* fichero no escribible;
* versión no soportada.

La prueba deberá comprobar:

* mensaje;
* nivel;
* código de salida;
* estado final;
* ausencia de modificaciones parciales cuando proceda.

## Pruebas de idempotencia

Todo módulo deberá probarse mediante al menos dos ejecuciones consecutivas.

La segunda ejecución deberá:

* finalizar correctamente;
* detectar el estado existente;
* no duplicar entradas;
* no reinstalar innecesariamente;
* no corromper configuraciones;
* mantener el resultado esperado;
* emitir mensajes coherentes.

Ejemplo conceptual:

```bash
run install_component
[ "$status" -eq 0 ]

run install_component
[ "$status" -eq 0 ]

[ "$(count_configuration_entries)" -eq 1 ]
```

La idempotencia deberá comprobarse también después de una ejecución parcialmente fallida cuando sea razonable.

## Pruebas de instalación parcial

Cuando un módulo falle durante su ejecución, deberá validarse:

* qué cambios llegaron a aplicarse;
* si puede repetirse con seguridad;
* si limpia recursos temporales;
* si conserva información de diagnóstico;
* si evita declarar éxito;
* si no deja configuraciones inconsistentes.

## Pruebas de verificación

Cada módulo de instalación deberá disponer de pruebas específicas para su verificación.

La verificación deberá probar:

* componente instalado y operativo;
* componente ausente;
* componente instalado pero no operativo;
* versión correcta;
* versión distinta;
* servicio activo;
* servicio inactivo;
* configuración válida;
* configuración incompleta.

La función de verificación no deberá modificar el sistema.

## Pruebas de módulos

Cada módulo deberá cubrir al menos:

1. Instalación desde sistema limpio.
2. Componente ya instalado.
3. Versión existente compatible.
4. Versión existente incompatible.
5. Dependencia ausente.
6. Fallo de descarga.
7. Fallo de permisos.
8. Verificación correcta.
9. Verificación fallida.
10. Segunda ejecución.

## Pruebas de dependencias

Los módulos deberán probar que:

* detectan dependencias ausentes;
* informan claramente;
* no continúan de forma insegura;
* aceptan dependencias válidas;
* no dependen del orden accidental de ejecución.

Cuando el sistema pueda instalar automáticamente una dependencia, deberá probarse también ese flujo.

## Pruebas de repositorios

Los módulos que incorporen repositorios deberán comprobar:

* repositorio ausente;
* repositorio ya configurado;
* clave ausente;
* clave ya instalada;
* clave inválida;
* distribución no soportada;
* arquitectura no soportada;
* fichero duplicado;
* actualización de índices;
* repetición segura.

## Pruebas de descargas

La biblioteca de descarga deberá cubrir:

* descarga correcta;
* redirección HTTP;
* error HTTP;
* timeout;
* interrupción;
* reintentos;
* fichero parcial;
* checksum correcto;
* checksum incorrecto;
* firma válida;
* firma inválida;
* URL no permitida.

Las pruebas unitarias utilizarán servidores simulados o fixtures cuando sea posible.

## Pruebas de servicios

Los módulos que gestionen servicios deberán comprobar:

* instalación;
* activación;
* arranque;
* servicio ya activo;
* servicio deshabilitado;
* fallo de arranque;
* reinicio;
* verificación posterior;
* necesidad de reinicio del sistema o de sesión.

## Pruebas de usuarios y grupos

Deberán probarse:

* usuario ya incluido en el grupo;
* usuario ausente del grupo;
* grupo inexistente;
* usuario inválido;
* modificación correcta;
* mensaje de cierre de sesión;
* repetición sin duplicidades.

## Pruebas de privilegios

Los módulos deberán probar:

* usuario normal con `sudo`;
* usuario sin `sudo`;
* ejecución accidental como `root`;
* credenciales de `sudo` caducadas;
* operación no privilegiada;
* operación privilegiada;
* cancelación de la solicitud de contraseña.

Las pruebas automatizadas no deberán solicitar contraseñas reales.

## Pruebas de seguridad

Las pruebas deberán comprobar, cuando corresponda:

* ausencia de secretos en logs;
* rechazo de entradas inseguras;
* protección frente a inyección;
* no utilización de `eval`;
* permisos de archivos;
* uso de HTTPS;
* validación de checksums;
* mínimo privilegio;
* seguridad de ficheros temporales;
* ausencia de rutas no controladas.

## Pruebas de configuración

Deberán cubrirse:

* configuración válida;
* fichero ausente;
* valor obligatorio ausente;
* valor desconocido;
* versión inválida;
* ruta inválida;
* valor por defecto;
* sobrescritura explícita;
* conflicto entre opciones.

## Pruebas de modo `dry-run`

Cuando exista, deberá verificarse que:

* no modifica el sistema;
* muestra las acciones previstas;
* respeta las mismas validaciones;
* detecta errores previos;
* no descarga ni instala;
* devuelve códigos coherentes.

El modo `dry-run` no deberá limitarse a mostrar siempre un resultado favorable.

## Pruebas de modo no interactivo

El sistema deberá probarse sin terminal interactiva.

Ejemplos:

```bash
script.sh </dev/null
```

y mediante redirecciones o ejecución desde CI.

Deberá comprobarse que:

* no queda bloqueado esperando entrada;
* no muestra animaciones;
* no utiliza colores;
* emplea valores por defecto seguros;
* falla claramente cuando requiere una decisión humana.

## Pruebas de interrupción

Los scripts deberán probar su comportamiento ante:

* `SIGINT`;
* `SIGTERM`;
* cancelación del usuario;
* interrupción de descarga;
* interrupción durante una modificación.

Deberán:

* limpiar recursos temporales;
* registrar la interrupción;
* devolver un código adecuado;
* evitar declarar éxito.

## Pruebas de rendimiento

El rendimiento no es el objetivo principal, pero deberán detectarse ineficiencias claras.

Podrán medirse:

* duración total;
* tiempo por módulo;
* actualizaciones APT repetidas;
* descargas duplicadas;
* verificaciones excesivas;
* tiempo de segunda ejecución.

La segunda ejecución debería ser sensiblemente más rápida cuando el sistema ya se encuentra preparado.

## Pruebas de compatibilidad

La plataforma principal será la versión de Kubuntu definida por el proyecto.

Cuando resulte posible se probarán también:

* versión LTS anterior;
* instalación mínima;
* sistema actualizado;
* sistema parcialmente configurado;
* diferentes resoluciones de terminal;
* diferentes configuraciones regionales.

El soporte real deberá corresponderse con las plataformas probadas.

## Entorno de pruebas

Las pruebas destructivas o de instalación real deberán ejecutarse en entornos aislados.

Opciones:

* máquina virtual;
* snapshot de VirtualBox;
* contenedor, cuando reproduzca adecuadamente el comportamiento;
* máquina temporal;
* runner de CI;
* sistema dedicado.

No se ejecutarán pruebas destructivas directamente sobre el equipo principal sin medidas de recuperación.

## Máquinas virtuales

VirtualBox será adecuado para validar el flujo completo sobre Kubuntu.

Se recomienda mantener snapshots como:

```text
clean-install
system-updated
base-installed
development-installed
```

Antes de una prueba completa deberá restaurarse el snapshot correspondiente.

El resultado no deberá depender de residuos de ejecuciones anteriores.

## Limitaciones de los contenedores

Los contenedores podrán utilizarse para:

* funciones;
* APT básico;
* análisis estático;
* comprobaciones de archivos;
* parte de las pruebas de integración.

No deberán considerarse equivalentes a una máquina completa para probar:

* `systemd`;
* reinicios;
* sesiones;
* grupos;
* escritorio;
* RStudio Desktop;
* VirtualBox Guest Additions;
* servicios dependientes del arranque.

## Pruebas del sistema completo

La instalación completa deberá comprobar:

* ejecución desde una instalación limpia;
* orden de módulos;
* dependencias;
* logging global;
* logs individuales;
* resumen final;
* códigos de salida;
* versiones;
* advertencias;
* duración;
* repetición completa;
* recuperación tras fallo.

## Matriz de pruebas

Cada módulo deberá mantener una matriz mínima.

Ejemplo:

| Escenario                | Esperado               |
| ------------------------ | ---------------------- |
| Sistema limpio           | Instala y verifica     |
| Ya instalado             | Detecta y no duplica   |
| Sin red                  | Falla con diagnóstico  |
| Sin permisos             | Falla sin modificar    |
| Segunda ejecución        | Finaliza correctamente |
| Verificación negativa    | Devuelve error         |
| Modo sin color           | No genera ANSI         |
| Ejecución no interactiva | No se bloquea          |

## Pruebas de regresión

Todo defecto corregido deberá incorporar una prueba que falle antes de la corrección y pase después.

No deberá corregirse únicamente el síntoma sin proteger el comportamiento futuro.

## Cobertura

No se perseguirá un porcentaje de cobertura como objetivo aislado.

La cobertura deberá utilizarse para identificar:

* caminos no probados;
* gestión de errores ausente;
* funciones difíciles de probar;
* acoplamiento excesivo.

La calidad de los escenarios tendrá prioridad sobre una cifra elevada.

## Datos de prueba

Los datos deberán ser:

* mínimos;
* comprensibles;
* deterministas;
* independientes de fechas o servicios variables;
* libres de secretos;
* adecuados para versionarse.

Cuando una prueba dependa de fecha u hora, deberá poder fijarse o simularse.

## Determinismo

Las pruebas deberán producir el mismo resultado en condiciones equivalentes.

Se controlarán:

* tiempo;
* zona horaria;
* configuración regional;
* orden de archivos;
* variables de entorno;
* respuestas externas;
* versiones.

No deberán existir pruebas que fallen aleatoriamente sin causa identificable.

## Nombres de pruebas

Los nombres deberán describir el comportamiento esperado.

Ejemplos:

```text
test_install_package_when_missing
test_install_package_when_already_installed
test_verify_service_when_inactive
test_log_file_contains_no_ansi_codes
```

Deberán evitarse:

```text
test1
test_ok
test_install
test_error
```

## Estructura Arrange, Act, Assert

Las pruebas deberán mantener una estructura clara:

1. Preparar.
2. Ejecutar.
3. Comprobar.

Ejemplo conceptual:

```bash
@test "no duplica el repositorio existente" {
    create_existing_repository

    run configure_repository

    [ "$status" -eq 0 ]
    [ "$(count_repository_entries)" -eq 1 ]
}
```

## Mensajes de fallo

Una prueba fallida deberá aportar información suficiente para identificar:

* escenario;
* valor esperado;
* valor obtenido;
* fichero o módulo;
* salida relevante.

Las pruebas no deberán ocultar toda la salida necesaria para investigar el fallo.

## Integración continua

El proyecto deberá aspirar a ejecutar automáticamente:

* `bash -n`;
* ShellCheck;
* formato;
* pruebas unitarias;
* pruebas de integración no destructivas;
* validación documental.

Las pruebas completas sobre máquina virtual podrán ejecutarse con menor frecuencia o de forma manual controlada.

## Niveles de ejecución

Podrán definirse perfiles:

```text
quick
standard
full
```

### Quick

* sintaxis;
* ShellCheck;
* formato;
* pruebas unitarias.

### Standard

* todo lo anterior;
* integración;
* módulos simulados;
* validaciones.

### Full

* todo lo anterior;
* instalación real;
* máquina limpia;
* idempotencia completa;
* pruebas del sistema.

## Evidencias

Las pruebas completas deberán generar evidencias cuando aporten valor:

* logs;
* versiones;
* resumen;
* capturas;
* resultados;
* fecha;
* entorno;
* commit probado.

Estas evidencias podrán utilizarse posteriormente en los Labs y en la documentación.

## Relación con requerimientos

Las pruebas deberán poder relacionarse con requerimientos y especificaciones.

Ejemplo:

```text
RF-003  Verificación de instalaciones
RNF-004 Idempotencia
```

Una especificación deberá indicar qué pruebas demuestran su cumplimiento.

## Criterios de aceptación

Toda funcionalidad deberá disponer de criterios de aceptación verificables.

Un criterio no deberá limitarse a expresiones como:

```text
Funciona correctamente.
```

Deberá expresar un resultado observable.

Ejemplo:

```text
Dada una instalación limpia de Kubuntu, cuando se ejecuta el módulo
de Git, entonces Git queda disponible, su versión se registra y una
segunda ejecución no modifica el sistema.
```

## Código generado por IA

Las pruebas generadas por IA deberán revisarse con el mismo rigor que el código.

Se comprobará que:

* prueban comportamiento real;
* no validan únicamente mocks;
* no reproducen la implementación;
* incluyen escenarios negativos;
* verifican códigos de salida;
* cubren idempotencia;
* no ocultan fallos;
* no generan falsos positivos.

Una prueba que siempre pasa es más peligrosa que no tener prueba.

## Responsabilidad

La IA podrá proponer escenarios y generar pruebas.

La selección de los comportamientos relevantes y la aceptación del resultado corresponderán al equipo de ingeniería.

## Excepciones

Toda funcionalidad sin pruebas automatizadas deberá justificar:

* por qué no puede automatizarse;
* qué validación manual se realizará;
* qué riesgo permanece;
* cómo se documentará la evidencia.

## Criterio final

Una instalación no está terminada cuando el script deja de mostrar errores.

Está terminada cuando puede demostrarse, de forma repetible, que produjo el estado esperado, que puede ejecutarse de nuevo con seguridad y que falla de manera comprensible cuando las condiciones no son correctas.
