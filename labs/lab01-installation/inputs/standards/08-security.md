# Estándar de seguridad

## Propósito

Este documento define los requisitos y prácticas de seguridad aplicables al proyecto.

El sistema modifica un entorno operativo, instala software, configura repositorios, gestiona servicios y ejecuta operaciones con privilegios elevados.

Por ese motivo, la seguridad no deberá tratarse como una revisión posterior.

Deberá formar parte del diseño, la implementación, las pruebas y la documentación de cada módulo.

## Principios

El proyecto aplicará los siguientes principios:

* mínimo privilegio;
* defensa en profundidad;
* validación de entradas;
* fuentes confiables;
* integridad verificable;
* trazabilidad;
* reducción de superficie de ataque;
* comportamiento seguro por defecto;
* ausencia de secretos en código y logs;
* recuperación ante fallos.

La automatización no deberá reducir la visibilidad sobre las operaciones sensibles.

## Modelo de confianza

Las siguientes entradas deberán considerarse no confiables hasta ser validadas:

* argumentos de línea de comandos;
* variables de entorno;
* ficheros de configuración;
* rutas;
* nombres de paquetes;
* URLs;
* contenido descargado;
* respuestas de servicios remotos;
* valores obtenidos del sistema;
* datos proporcionados por el usuario;
* código generado por asistentes de IA.

El hecho de que una entrada proceda del propio proyecto no elimina la necesidad de validarla cuando pueda haber sido modificada.

## Mínimo privilegio

Los scripts deberán ejecutarse normalmente con una cuenta de usuario.

No deberán requerir que toda la ejecución se realice como `root`.

Las operaciones privilegiadas utilizarán `sudo` únicamente durante el tiempo imprescindible.

Ejemplo:

```bash
sudo apt-get update
sudo install -m 0644 "$source_file" "$target_file"
```

Se evitará:

```bash
sudo ./install-all.sh
```

salvo que exista una decisión explícita, documentada y justificada.

## Ejecución como `root`

Los scripts orientados a usuario deberán detectar la ejecución directa como `root`.

Comportamiento recomendado:

```bash
if (( EUID == 0 )); then
    log_error "Este script no debe ejecutarse como root."
    return 5
fi
```

Las excepciones deberán indicar:

* motivo;
* alcance;
* riesgos;
* controles compensatorios;
* pruebas específicas.

## Uso de `sudo`

El uso de `sudo` deberá ser:

* explícito;
* localizado;
* visible;
* justificable;
* limitado a operaciones que realmente lo requieran.

No deberá utilizarse para:

* leer archivos accesibles al usuario;
* descargar contenido a directorios del usuario;
* crear archivos temporales;
* ejecutar verificaciones no privilegiadas;
* mostrar información;
* manipular datos que no requieran permisos elevados.

## Credenciales de `sudo`

Los scripts no deberán:

* solicitar, almacenar o registrar contraseñas;
* recibir contraseñas como argumento;
* incluir contraseñas en variables;
* automatizar la introducción de credenciales;
* modificar políticas de `sudoers` sin una decisión específica.

En ejecuciones largas podrá mantenerse activa la sesión de `sudo` únicamente mediante una implementación controlada y documentada.

El proceso auxiliar deberá finalizar al terminar el script.

## Operaciones destructivas

Las operaciones destructivas deberán identificarse claramente.

Ejemplos:

* eliminación de directorios;
* sobrescritura de configuraciones;
* desinstalación de paquetes;
* eliminación de repositorios;
* limpieza de datos;
* modificación de permisos;
* cambio de propietarios;
* detención o deshabilitación de servicios.

Cuando exista riesgo de pérdida de información, el sistema deberá:

* informar antes;
* solicitar confirmación;
* utilizar una opción segura por defecto;
* generar copia de respaldo cuando proceda;
* registrar la operación.

## Entradas de usuario

Las entradas deberán validarse según el dominio esperado.

Si una opción admite un conjunto limitado de valores, se utilizará una lista permitida.

Ejemplo:

```bash
case "$install_mode" in
    minimal|standard|full)
        ;;
    *)
        log_error "Modo de instalación no válido: $install_mode"
        return 2
        ;;
esac
```

No se aceptarán valores arbitrarios cuando no sean necesarios.

## Construcción de comandos

Los comandos deberán construirse mediante argumentos separados y arrays.

Ejemplo seguro:

```bash
command_args=(
    apt-get
    install
    -y
    "$package_name"
)

sudo "${command_args[@]}"
```

Se evitará construir comandos como cadenas.

No se utilizará `eval` salvo una necesidad excepcional, limitada y documentada.

Debe evitarse:

```bash
command_string="apt-get install -y $package_name"
eval "$command_string"
```

## Validación de nombres de paquetes

Los nombres de paquetes recibidos externamente deberán validarse.

Solo deberán aceptarse formatos compatibles con el gestor de paquetes y, cuando sea posible, valores definidos en la configuración del proyecto.

Los módulos no deberán instalar paquetes arbitrarios proporcionados por una fuente no confiable.

## Validación de rutas

Las rutas deberán:

* normalizarse cuando proceda;
* comprobarse antes de utilizarse;
* permanecer dentro de los directorios permitidos;
* evitar traversal;
* tratar espacios y caracteres especiales correctamente;
* escribirse siempre entre comillas.

Antes de eliminar o sobrescribir una ruta deberá comprobarse que no corresponde a:

* `/`;
* `$HOME`;
* directorios críticos;
* rutas vacías;
* enlaces simbólicos inesperados;
* ubicaciones fuera del ámbito previsto.

Ejemplo de protección:

```bash
if [[ -z "$target_dir" || "$target_dir" == "/" ]]; then
    log_error "Directorio de destino no seguro."
    return 2
fi
```

## Enlaces simbólicos

Antes de escribir en rutas sensibles deberá evaluarse si existe un enlace simbólico.

Los scripts no deberán seguir enlaces simbólicos inesperados cuando puedan provocar escritura fuera del destino previsto.

Las operaciones críticas deberán utilizar mecanismos que reduzcan riesgos de sustitución de archivos.

## Ficheros temporales

Los ficheros temporales deberán crearse mediante `mktemp`.

Ejemplo:

```bash
temporary_file="$(mktemp)"
```

No se utilizarán nombres predecibles.

Los ficheros temporales deberán:

* tener permisos adecuados;
* limpiarse al finalizar;
* no contener secretos innecesariamente;
* residir en ubicaciones seguras;
* evitar colisiones.

Cuando contengan información sensible deberá utilizarse una `umask` restrictiva.

```bash
umask 077
```

## Descargas

Toda descarga deberá realizarse mediante HTTPS.

Las funciones de descarga deberán:

* fallar ante errores HTTP;
* seguir redirecciones de forma controlada;
* aplicar reintentos limitados;
* evitar salidas parciales no detectadas;
* guardar inicialmente en un fichero temporal;
* validar integridad cuando exista información disponible.

Ejemplo conceptual:

```bash
curl \
    --fail \
    --location \
    --retry 3 \
    --show-error \
    --silent \
    --output "$temporary_file" \
    "$url"
```

## Fuentes permitidas

Las descargas deberán proceder de:

* sitios oficiales;
* repositorios oficiales;
* distribuidores reconocidos;
* ubicaciones aprobadas por el proyecto.

Las excepciones deberán documentar:

* motivo;
* propietario de la fuente;
* método de validación;
* riesgo;
* alternativa considerada.

## Integridad

Siempre que el proveedor publique checksums o firmas, deberán verificarse.

Ejemplo conceptual:

```bash
printf '%s  %s\n' "$expected_sha256" "$downloaded_file" |
    sha256sum --check -
```

La verificación deberá producir un fallo si:

* el checksum no coincide;
* falta el fichero;
* el formato es inválido;
* no puede completarse la comprobación.

No se continuará con una instalación cuando falle la integridad.

## Firmas criptográficas

Cuando exista firma oficial, se preferirá verificarla además del checksum.

Las claves utilizadas deberán:

* obtenerse de una fuente oficial;
* almacenarse en ubicaciones adecuadas;
* identificarse mediante fingerprint;
* utilizarse únicamente para el repositorio previsto;
* actualizarse de forma controlada.

No deberá confiarse en una clave únicamente porque la descarga se completó correctamente.

## Repositorios APT

La incorporación de repositorios deberá:

* evitar `apt-key`;
* utilizar keyrings específicos;
* definir `signed-by`;
* limitar la confianza al repositorio correspondiente;
* utilizar HTTPS;
* validar distribución y arquitectura;
* ser idempotente.

Ejemplo conceptual:

```text
deb [arch=amd64 signed-by=/etc/apt/keyrings/vendor.gpg] \
https://example.org/repository stable main
```

No se añadirán repositorios genéricos con confianza global.

## Claves de repositorio

Las claves deberán almacenarse preferentemente en:

```text
/etc/apt/keyrings/
```

Los ficheros deberán tener permisos adecuados.

El nombre deberá identificar claramente al proveedor.

Ejemplo:

```text
/etc/apt/keyrings/docker.gpg
```

La instalación deberá comprobar el fingerprint cuando sea posible.

## Paquetes

Siempre que exista un paquete oficial adecuado, se preferirá frente a:

* scripts remotos;
* binarios no verificados;
* instaladores de terceros;
* compilación innecesaria desde fuentes externas.

No se utilizarán comandos del tipo:

```bash
curl https://example.org/install.sh | sudo bash
```

sin descargar, inspeccionar, validar y justificar previamente el contenido.

## Scripts remotos

Los scripts remotos no deberán ejecutarse directamente desde una tubería.

Debe evitarse:

```bash
curl -fsSL "$url" | bash
```

El proceso correcto deberá ser:

1. Descargar.
2. Validar origen.
3. Verificar integridad o firma.
4. Revisar o fijar versión.
5. Ejecutar desde un fichero local controlado.
6. Registrar la operación.

## Versiones

Las instalaciones deberán evitar depender ciegamente de `latest` cuando la reproducibilidad o la seguridad lo desaconsejen.

Las versiones deberán centralizarse.

Cuando se utilice una versión flotante deberá documentarse:

* motivo;
* riesgo;
* mecanismo de verificación;
* estrategia de actualización.

## Actualizaciones

La actualización de componentes deberá tratarse como una operación explícita.

No se actualizarán silenciosamente componentes ajenos al objetivo del módulo.

Las actualizaciones que puedan introducir incompatibilidades deberán:

* informarse;
* documentarse;
* verificarse;
* permitir recuperación cuando sea razonable.

## Servicios

Los servicios instalados deberán:

* habilitarse únicamente cuando sean necesarios;
* escuchar solo en interfaces requeridas;
* evitar exposición externa por defecto;
* ejecutarse con usuarios y permisos adecuados;
* verificar su estado después de configurarse.

No se abrirán puertos automáticamente sin una decisión explícita.

## Puertos y red

Los módulos que habiliten servicios de red deberán documentar:

* puerto;
* protocolo;
* interfaz;
* ámbito de acceso;
* autenticación;
* riesgo;
* forma de desactivación.

La configuración predeterminada deberá limitar el acceso al mínimo necesario.

Cuando sea suficiente, se utilizará `localhost`.

## Firewall

El proyecto no modificará reglas de firewall salvo que el módulo lo requiera expresamente.

Toda modificación deberá:

* estar especificada;
* ser mínima;
* ser reversible;
* documentar puertos;
* comprobar reglas existentes;
* evitar bloquear acceso legítimo.

## Usuarios y grupos

La creación o modificación de usuarios y grupos deberá:

* utilizar nombres definidos;
* evitar privilegios excesivos;
* comprobar existencia;
* ser idempotente;
* registrar cambios;
* informar de efectos posteriores.

Añadir un usuario a grupos privilegiados deberá considerarse una operación sensible.

Ejemplo:

```text
docker
sudo
libvirt
```

La documentación deberá explicar las implicaciones.

## Permisos

Los permisos deberán asignarse explícitamente.

Se aplicará el mínimo necesario.

No se utilizará:

```bash
chmod 777
```

salvo una excepción extraordinaria y documentada.

Los permisos recomendados deberán expresarse de forma precisa.

Ejemplos:

```text
0644
0755
0600
0700
```

## Propietarios

Los cambios de propietario deberán limitarse a las rutas necesarias.

No se aplicarán operaciones recursivas sobre directorios amplios sin validar previamente el destino.

Debe evitarse:

```bash
sudo chown -R "$USER:$USER" "$HOME"
```

Las operaciones recursivas deberán recibir controles adicionales.

## Secretos

No deberán incluirse secretos en:

* código;
* configuración versionada;
* argumentos;
* ejemplos;
* logs;
* mensajes;
* fixtures;
* documentación;
* capturas de pantalla.

Los secretos deberán obtenerse mediante mecanismos apropiados al entorno.

Cuando un secreto no sea necesario para el proyecto, no deberá recopilarse.

## Variables de entorno

Las variables de entorno podrán utilizarse para proporcionar secretos durante la ejecución, pero deberán tratarse con cautela.

No deberán:

* mostrarse en logs;
* incluirse en mensajes de error;
* persistirse automáticamente;
* copiarse a archivos inseguros.

Cuando exista una opción más segura, deberá considerarse.

## Ficheros de configuración sensibles

Los ficheros que contengan credenciales deberán:

* excluirse de Git;
* utilizar permisos restrictivos;
* disponer de plantilla sin secretos;
* documentar cómo crearlos;
* evitar valores reales en ejemplos.

Ejemplo:

```text
config.example
config.local
```

## Logs

Los logs no deberán contener:

* contraseñas;
* tokens;
* claves privadas;
* cabeceras de autenticación;
* cookies;
* secretos;
* URLs con credenciales;
* contenido sensible.

Cuando sea necesario registrar identificadores, deberán enmascararse.

Ejemplo:

```text
token=abcd********wxyz
```

## Comandos registrados

Antes de registrar un comando deberá comprobarse si contiene secretos.

No se mostrarán argumentos sensibles completos.

Podrá registrarse una representación segura de la operación.

Ejemplo:

```text
Ejecutando autenticación contra el repositorio.
```

en lugar de mostrar el comando completo con token.

## Errores

Los mensajes de error deberán proporcionar información útil sin revelar datos sensibles.

No deberán exponer:

* credenciales;
* contenido completo de ficheros;
* datos personales;
* secretos de configuración;
* respuestas remotas sensibles.

## Código generado por IA

El código generado por IA deberá considerarse no confiable hasta ser revisado.

Se verificará especialmente:

* uso de `eval`;
* concatenación insegura;
* descargas directas;
* ejecución remota;
* permisos excesivos;
* uso innecesario de `sudo`;
* tratamiento de secretos;
* validación de entradas;
* escritura de rutas;
* limpieza;
* integridad;
* exposición de servicios;
* dependencias inventadas.

La fluidez o apariencia profesional del código no demuestra su seguridad.

## Dependencias

Toda dependencia deberá evaluarse considerando:

* mantenimiento;
* procedencia;
* licencia;
* vulnerabilidades conocidas;
* comunidad;
* necesidad real;
* permisos;
* scripts de instalación;
* cadena de suministro.

No se añadirá una dependencia únicamente para evitar unas pocas líneas de código sencillo y seguro.

## Cadena de suministro

El proyecto deberá reducir los riesgos de cadena de suministro mediante:

* fuentes oficiales;
* versiones controladas;
* checksums;
* firmas;
* dependencias mínimas;
* revisión de scripts de instalación;
* documentación del origen;
* actualización consciente.

Las herramientas que ejecuten scripts durante su instalación deberán tratarse con especial cautela.

## npm y scripts de instalación

Las instalaciones mediante npm deberán revisar si el paquete necesita ejecutar scripts.

Cuando se requiera autorización explícita, deberá identificarse claramente el paquete permitido.

Ejemplo:

```bash
npm install --global \
    --allow-scripts=@fission-ai/openspec \
    @fission-ai/openspec@latest
```

No se autorizará globalmente la ejecución de scripts para todos los paquetes sin una decisión justificada.

## Python y gestores equivalentes

Las instalaciones mediante gestores como `pip`, `pipx`, `uv` o equivalentes deberán:

* utilizar fuentes confiables;
* evitar ejecución como `root`;
* aislar entornos cuando proceda;
* fijar versiones cuando sea necesario;
* registrar origen y versión;
* evitar mezclar instalaciones del sistema y del usuario sin criterio.

## R y paquetes

La instalación de paquetes R deberá:

* utilizar repositorios definidos;
* registrar versiones;
* evitar modificaciones globales innecesarias;
* considerar bibliotecas de usuario;
* documentar paquetes con compilación nativa;
* validar dependencias del sistema.

## Docker

La instalación y uso de Docker deberá considerar que pertenecer al grupo `docker` proporciona privilegios equivalentes a `root` en muchos escenarios.

Esta implicación deberá:

* documentarse;
* comunicarse al usuario;
* tratarse como decisión sensible;
* probarse;
* evitarse cuando exista una alternativa adecuada.

Los contenedores no deberán ejecutarse con privilegios elevados salvo necesidad justificada.

## Imágenes de contenedor

Las imágenes deberán:

* proceder de registros confiables;
* utilizar etiquetas controladas;
* evitar `latest` cuando comprometa reproducibilidad;
* reducir privilegios;
* minimizar paquetes;
* actualizarse ante vulnerabilidades;
* documentar su origen.

Cuando sea posible, se considerará fijar digest.

## Configuración del sistema

Antes de modificar configuraciones del sistema deberá:

* comprobarse el estado actual;
* conservarse el contenido previo cuando proceda;
* evitarse duplicación;
* validarse el nuevo fichero;
* aplicarse de forma atómica;
* permitir recuperación.

## Escritura atómica

Para configuraciones críticas se preferirá:

1. Crear un fichero temporal.
2. Validarlo.
3. Aplicar permisos.
4. Sustituir el destino mediante una operación controlada.

No deberá escribirse directamente sobre un fichero crítico cuando un fallo pueda dejarlo incompleto.

## Copias de seguridad

Las modificaciones relevantes podrán crear copias de seguridad.

El formato deberá permitir identificar:

* fichero original;
* fecha;
* módulo responsable.

Ejemplo:

```text
sshd_config.2026-08-02_143208.bak
```

Las copias no deberán contener secretos en ubicaciones inseguras.

## Recuperación

Los módulos deberán considerar cómo recuperar el sistema tras un fallo.

Cuando una operación no sea reversible, deberá documentarse.

La recuperación podrá incluir:

* restaurar configuración;
* eliminar repositorio añadido;
* desinstalar paquete;
* detener servicio;
* devolver permisos;
* limpiar ficheros temporales.

## Fallos parciales

Cuando una operación falle después de modificar el sistema, el módulo deberá:

* registrar el punto de fallo;
* evitar declarar éxito;
* limpiar recursos temporales;
* dejar información suficiente;
* permitir repetición segura;
* intentar recuperación cuando sea apropiado.

## Idempotencia y seguridad

La idempotencia constituye también una medida de seguridad.

Una segunda ejecución no deberá:

* duplicar repositorios;
* repetir claves;
* alterar permisos acumulativamente;
* añadir líneas repetidas;
* recrear usuarios incorrectamente;
* abrir nuevos puertos;
* sobrescribir configuraciones válidas.

## Modo `dry-run`

El modo `dry-run`, cuando exista, deberá mostrar operaciones sensibles sin ejecutarlas.

Deberá indicar claramente:

* uso de `sudo`;
* cambios de archivos;
* instalación de paquetes;
* habilitación de servicios;
* modificación de usuarios;
* apertura de puertos.

No deberá mostrar secretos.

## Confirmaciones

Las operaciones de riesgo elevado deberán requerir confirmación cuando se ejecuten de forma interactiva.

La respuesta predeterminada deberá ser segura.

Ejemplo:

```text
¿Desea sobrescribir la configuración existente? [s/N]
```

En modo no interactivo, las operaciones destructivas deberán fallar o requerir una opción explícita.

## Automatización no interactiva

El modo no interactivo deberá evitar decisiones implícitas inseguras.

Las opciones que acepten cambios destructivos deberán ser explícitas.

Ejemplo conceptual:

```text
--force
--replace-existing
--remove-conflicting-package
```

No se utilizará una única opción genérica para autorizar cualquier acción peligrosa.

## Señales e interrupciones

Los scripts deberán responder adecuadamente a interrupciones.

Ante `SIGINT` o `SIGTERM` deberán:

* detener operaciones de forma segura;
* limpiar temporales;
* registrar la interrupción;
* evitar mensajes de éxito;
* preservar evidencias útiles.

## Bloqueos

Cuando dos ejecuciones simultáneas puedan interferir, deberá considerarse un mecanismo de bloqueo.

Ejemplo:

```bash
flock
```

El bloqueo deberá:

* identificar el proceso;
* liberarse al finalizar;
* evitar esperas indefinidas;
* informar al usuario.

## Concurrencia

No se ejecutarán en paralelo operaciones que puedan modificar:

* APT;
* repositorios;
* usuarios;
* servicios;
* los mismos ficheros;
* bases de datos de paquetes.

La paralelización solo deberá utilizarse cuando el aislamiento sea claro.

## Auditoría

Las operaciones sensibles deberán quedar registradas con:

* fecha y hora;
* módulo;
* acción;
* resultado;
* código de salida;
* versión, cuando proceda.

Los logs deberán ser suficientes para investigar una incidencia sin exponer secretos.

## Privacidad

El sistema deberá recopilar únicamente la información necesaria.

No deberá enviar telemetría ni datos a terceros salvo decisión explícita.

Toda comunicación externa deberá documentarse.

## Telemetría

La telemetría estará desactivada por defecto salvo que una herramienta la imponga.

Cuando sea posible, los módulos deberán:

* informar de su existencia;
* documentar cómo desactivarla;
* aplicar la política del proyecto;
* no activar nuevas telemetrías silenciosamente.

## Datos personales

Los ejemplos, logs y capturas no deberán incluir:

* nombres reales innecesarios;
* correos;
* rutas personales completas;
* tokens;
* identificadores;
* direcciones IP públicas;
* información sensible.

Los datos utilizados en documentación deberán anonimizarse.

## Validación posterior

Toda operación sensible deberá verificarse.

Ejemplos:

* comprobar fingerprint;
* validar checksum;
* confirmar permisos;
* comprobar servicio;
* revisar puerto;
* validar sintaxis de configuración;
* verificar propietario;
* confirmar versión instalada.

La ausencia de error durante la ejecución no constituye verificación suficiente.

## Herramientas de análisis

Los scripts deberán someterse a:

* ShellCheck;
* pruebas;
* revisión de permisos;
* revisión de dependencias;
* análisis de secretos;
* revisión manual.

Podrán incorporarse herramientas adicionales cuando el proyecto lo necesite.

## Escaneo de secretos

El repositorio deberá evitar la inclusión accidental de secretos.

Podrá evaluarse el uso de herramientas de detección automática.

Toda alerta deberá investigarse.

No se considerará suficiente añadir el fichero al `.gitignore` después de haber versionado el secreto.

## Vulnerabilidades

Las dependencias y herramientas deberán revisarse periódicamente.

Cuando exista una vulnerabilidad relevante se deberá:

* evaluar impacto;
* actualizar;
* aplicar mitigación;
* documentar la decisión;
* añadir pruebas cuando proceda.

## Excepciones

Toda excepción de seguridad deberá incluir:

* motivo;
* alcance;
* riesgo;
* duración;
* responsable;
* controles compensatorios;
* fecha de revisión.

Las excepciones no deberán convertirse en comportamiento permanente por inercia.

## Pruebas de seguridad

Las pruebas deberán cubrir, cuando proceda:

* entradas inválidas;
* inyección;
* traversal de rutas;
* ausencia de secretos en logs;
* permisos;
* descargas alteradas;
* checksum incorrecto;
* firma inválida;
* repositorio no confiable;
* ejecución como `root`;
* uso sin `sudo`;
* interrupción;
* enlaces simbólicos;
* operaciones destructivas;
* repetición segura.

## Evidencias

Las pruebas de seguridad podrán generar evidencias como:

* resultado de ShellCheck;
* verificación de checksum;
* fingerprint;
* permisos;
* propietarios;
* puertos;
* servicios;
* logs enmascarados;
* resultados de escaneo.

Las evidencias no deberán contener secretos.

## Responsabilidad

Los asistentes de IA podrán proponer implementaciones y controles.

La responsabilidad sobre la seguridad corresponderá siempre al proyecto y a quienes acepten el cambio.

Ninguna recomendación de una IA deberá aplicarse sin revisión.

## Criterio final

Un módulo seguro no es únicamente el que evita ataques evidentes.

Debe limitar privilegios, verificar lo que instala, proteger la información, fallar de forma controlada y permitir comprender exactamente qué cambios realizó sobre el sistema.
