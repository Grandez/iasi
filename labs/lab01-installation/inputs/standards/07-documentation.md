# Estándar de documentación

## Propósito

Este documento define cómo debe documentarse el proyecto y sus componentes.

La documentación forma parte del sistema.

No se considera un artefacto posterior ni una explicación añadida al terminar la implementación.

Su objetivo es permitir que una persona o un asistente de IA pueda comprender:

* qué problema resuelve el proyecto;
* cómo está organizado;
* qué decisiones se tomaron;
* cómo se utiliza;
* cómo se verifica;
* cómo puede modificarse con seguridad;
* cómo ha evolucionado.

## Principios

La documentación deberá ser:

* clara;
* precisa;
* actualizada;
* trazable;
* proporcional a su propósito;
* próxima al artefacto que describe;
* independiente de conversaciones efímeras;
* comprensible sin conocimiento previo del historial del equipo.

La documentación deberá explicar tanto el resultado como el razonamiento relevante que condujo a él.

## El proyecto se describe a sí mismo

El repositorio deberá contener la información necesaria para reconstruir su propósito, arquitectura, decisiones y evolución.

Una persona que clone el proyecto deberá poder responder, sin depender de conversaciones externas:

* qué se está construyendo;
* por qué existe;
* cómo está organizado;
* qué reglas gobiernan su implementación;
* qué decisiones importantes se tomaron;
* qué cambios están en curso;
* cómo ejecutar y verificar el sistema.

El repositorio constituye la memoria técnica del proyecto.

## Tipos de documentación

El proyecto distinguirá, como mínimo, los siguientes tipos de documentación:

1. Visión y contexto.
2. Requerimientos.
3. Arquitectura.
4. Estándares.
5. Especificaciones.
6. ADR.
7. Documentación de módulos.
8. Documentación de uso.
9. Documentación de pruebas.
10. Evidencias y resultados.
11. Laboratorios.
12. Historial de cambios.

Cada tipo responde a una pregunta diferente y no deberá utilizarse para sustituir arbitrariamente a los demás.

## Visión y contexto

La visión describe:

* el propósito;
* la motivación;
* el alcance;
* los objetivos;
* el resultado esperado.

No deberá incluir detalles de implementación que puedan cambiar sin afectar a la finalidad del proyecto.

## Requerimientos

Los requerimientos deberán expresar resultados observables.

Deberán identificarse de forma estable mediante códigos como:

```text
RF-001
RF-002
RNF-001
RNF-002
```

Cada requerimiento deberá incluir, cuando proceda:

* descripción;
* motivación;
* prioridad;
* criterios de aceptación;
* relaciones;
* estado.

Los identificadores eliminados no deberán reutilizarse para otros requerimientos.

## Arquitectura

La documentación de arquitectura deberá describir:

* componentes;
* responsabilidades;
* relaciones;
* dependencias;
* límites;
* flujos;
* restricciones;
* mecanismos de extensión.

No deberá limitarse a diagramas.

Todo diagrama deberá acompañarse de una explicación textual suficiente.

## ADR

Las decisiones arquitectónicas relevantes deberán registrarse mediante Architecture Decision Records.

Un ADR deberá incluir, como mínimo:

* identificador;
* título;
* fecha;
* estado;
* contexto;
* problema;
* alternativas consideradas;
* decisión;
* consecuencias.

Los ADR no se eliminarán cuando queden obsoletos.

Su estado cambiará a:

* sustituido;
* rechazado;
* obsoleto;
* supersedido por otro ADR.

La historia de las decisiones deberá conservarse.

## Especificaciones

Las especificaciones deberán describir qué debe construirse antes de detallar cómo se implementará.

Deberán incluir:

* alcance;
* comportamiento esperado;
* restricciones;
* criterios de aceptación;
* dependencias;
* casos relevantes;
* relación con requerimientos.

Las conversaciones con asistentes de IA no sustituirán a las especificaciones persistentes.

## Estándares

Los estándares deberán definir reglas comunes y reutilizables.

Ejemplos:

* codificación;
* nomenclatura;
* logging;
* consola;
* Shell;
* pruebas;
* documentación.

Los estándares no deberán mezclarse con decisiones específicas de un módulo concreto.

## Proximidad

La documentación deberá vivir lo más cerca posible del artefacto que describe.

Ejemplos:

```text
modules/docker/README.md
tests/README.md
inputs/standards/logging.md
adr/decisions/003-adopt-openspec.qmd
```

La documentación transversal permanecerá en ubicaciones comunes.

La documentación específica de un módulo deberá acompañar al módulo.

## README principal

El repositorio deberá incluir un `README.md` en la raíz.

Deberá explicar, como mínimo:

* nombre del proyecto;
* propósito;
* estado;
* estructura general;
* requisitos previos;
* inicio rápido;
* documentación disponible;
* forma de contribuir;
* licencia.

El README principal no deberá intentar contener toda la documentación.

Actuará como mapa de entrada.

## README de módulos

Cada módulo público deberá incluir documentación suficiente para comprenderlo y utilizarlo.

Como mínimo:

```markdown
# Nombre del módulo

## Propósito

## Requisitos

## Dependencias

## Instalación

## Verificación

## Uso

## Opciones

## Códigos de salida

## Efectos sobre el sistema

## Idempotencia

## Errores conocidos

## Pruebas
```

Las secciones podrán simplificarse cuando no sean aplicables.

## Documentación de bibliotecas

Las bibliotecas comunes deberán documentar:

* responsabilidad;
* API pública;
* funciones;
* parámetros;
* resultados;
* efectos secundarios;
* errores;
* dependencias;
* ejemplos.

Las funciones internas no necesitarán documentación formal cuando su propósito sea evidente.

## Documentación de funciones

Las funciones públicas y reutilizables deberán documentar:

* propósito;
* parámetros;
* resultado;
* códigos de retorno;
* efectos secundarios;
* precondiciones;
* errores esperados.

Ejemplo conceptual:

```bash
# Instala los paquetes indicados mediante APT.
#
# Argumentos:
#   $@  Nombres de paquetes.
#
# Devuelve:
#   0   Instalación correcta.
#   10  Fallo durante la instalación.
#
# Efectos:
#   Modifica el sistema mediante apt-get.
apt_install() {
    ...
}
```

No será necesario documentar cada línea ni repetir lo que el código ya expresa.

## Comentarios en código

Los comentarios deberán explicar principalmente:

* por qué;
* restricciones externas;
* decisiones no evidentes;
* riesgos;
* soluciones temporales;
* incompatibilidades;
* excepciones.

No deberán repetir mecánicamente la operación.

Debe evitarse:

```bash
# Crear directorio.
mkdir -p "$target_dir"
```

Se preferirá:

```bash
# El directorio debe crearse antes de elevar privilegios para conservar
# la propiedad del usuario que ejecuta el módulo.
mkdir -p "$target_dir"
```

## Documentación de argumentos

Todo script público deberá documentar:

* sintaxis;
* argumentos;
* opciones;
* valores por defecto;
* ejemplos;
* códigos de salida.

La salida de `--help` deberá coincidir con la documentación escrita.

No se mantendrán interfaces documentadas que el script no implemente.

## Ejemplos

Los ejemplos deberán ser:

* ejecutables;
* mínimos;
* representativos;
* seguros;
* coherentes con la versión actual.

Ejemplo:

```bash
./install/docker.sh
./install/docker.sh --verbose
./verify/docker.sh
```

Cuando un ejemplo modifique el sistema, deberá indicarlo claramente.

## Inicio rápido

Los documentos de entrada deberán ofrecer un camino mínimo para comenzar.

El inicio rápido deberá mostrar únicamente los pasos imprescindibles.

Las explicaciones detalladas se enlazarán desde él.

No deberá convertirse en una copia resumida de toda la documentación.

## Estructura del repositorio

La estructura principal deberá documentarse mediante un árbol breve.

Ejemplo:

```text
project/
├── inputs/
├── openspec/
├── scripts/
├── tests/
├── docs/
└── logs/
```

Cada directorio deberá acompañarse de una descripción de su responsabilidad.

## Diagramas

Los diagramas se utilizarán cuando aporten claridad.

Podrán representar:

* arquitectura;
* dependencias;
* flujos;
* estados;
* secuencias;
* despliegues.

Todo diagrama deberá:

* tener título;
* incluir contexto;
* ser legible;
* mantenerse junto al texto;
* utilizar terminología coherente;
* actualizarse cuando cambie el sistema.

No se crearán diagramas ornamentales sin función explicativa.

## Formato

La documentación utilizará Markdown como formato base, salvo cuando otro formato esté justificado.

Los documentos Quarto utilizarán `.qmd`.

Se respetarán:

* encabezados jerárquicos;
* listas coherentes;
* bloques de código etiquetados;
* tablas legibles;
* líneas razonablemente cortas;
* enlaces descriptivos.

Se evitarán estructuras innecesariamente complejas.

## Encabezados

Los encabezados deberán representar una jerarquía lógica.

No se saltarán niveles sin necesidad.

Ejemplo correcto:

```markdown
# Módulo Docker

## Instalación

### Repositorio oficial
```

Debe evitarse:

```markdown
# Módulo Docker

#### Repositorio oficial
```

## Bloques de código

Todo bloque de código deberá indicar el lenguaje cuando proceda.

Ejemplos:

````markdown
```bash
sudo apt-get update
```

```yaml
project:
  type: book
```
````

Los comandos deberán poder copiarse sin eliminar prefijos decorativos.

No se incluirá el prompt de Shell salvo cuando sea necesario distinguir usuarios o entornos.

## Salida de comandos

La salida esperada deberá diferenciarse de los comandos.

Ejemplo:

```bash
openspec --version
```

Salida:

```text
1.2.3
```

No se mezclarán comandos y resultados en un mismo bloque sin una indicación clara.

## Tablas

Las tablas deberán utilizarse para información comparativa o estructurada.

No deberán emplearse para párrafos extensos.

Las columnas deberán mantenerse razonablemente estrechas y comprensibles.

## Enlaces

Los enlaces internos deberán utilizar rutas relativas cuando sea posible.

El texto del enlace deberá describir el destino.

Se evitará:

```markdown
Pulse aquí.
```

Se preferirá:

```markdown
Consulte el [estándar de logging](logging.md).
```

## Imágenes

Las imágenes deberán almacenarse cerca del documento que las utiliza cuando sean específicas.

Las imágenes compartidas podrán residir en una ubicación común.

Toda imagen deberá:

* tener nombre descriptivo;
* incluir texto alternativo;
* ser legible;
* evitar información sensible;
* mantener un tamaño razonable.

Los nombres deberán seguir el estándar de nomenclatura.

## Capturas de pantalla

Las capturas deberán utilizarse cuando una interfaz visual sea relevante.

Deberán:

* mostrar únicamente la información necesaria;
* evitar datos personales;
* mantener una resolución coherente;
* incluir explicación;
* estar actualizadas.

No se utilizarán capturas como sustituto de instrucciones textuales esenciales.

## Idioma

La documentación principal del proyecto se redactará en castellano.

El código, identificadores y nombres técnicos utilizarán inglés según el estándar de nomenclatura.

Los términos técnicos podrán mantenerse en inglés cuando su traducción reduzca precisión.

No se mezclarán idiomas de forma arbitraria.

## Terminología

El proyecto deberá mantener un glosario.

Los términos relevantes deberán utilizarse de forma coherente.

Si se adopta `module`, no se alternará sin motivo con:

* component;
* plugin;
* unit;
* package.

Cuando dos términos representen conceptos distintos, la diferencia deberá documentarse.

## Versiones

La documentación deberá indicar versiones cuando afecten al comportamiento.

Ejemplo:

```text
Plataforma validada: Kubuntu 26.04 LTS
Bash mínimo: 5.x
```

No se introducirán versiones exactas innecesarias en múltiples documentos.

Las versiones centralizadas deberán enlazarse o generarse cuando resulte posible.

## Estado de los documentos

Los documentos podrán indicar su estado:

* borrador;
* propuesto;
* aceptado;
* obsoleto;
* sustituido.

El estado deberá utilizarse especialmente en:

* ADR;
* especificaciones;
* propuestas;
* documentos en revisión.

## Fecha

Las fechas deberán utilizar formato ISO:

```text
YYYY-MM-DD
```

Ejemplo:

```text
2026-08-02
```

No se utilizarán formatos ambiguos.

## Autoría

La autoría individual podrá registrarse cuando aporte valor.

La responsabilidad principal pertenece al proyecto.

Cuando exista participación de IA, no será necesario marcar cada párrafo, pero deberá quedar clara la metodología general de trabajo asistido.

La revisión y aceptación corresponden al equipo de ingeniería.

## Documentación generada

La documentación podrá generarse automáticamente cuando proceda.

Ejemplos:

* inventario de versiones;
* referencia de funciones;
* índice de ADR;
* matrices de trazabilidad;
* resultados de pruebas;
* estructura de módulos.

Los contenidos generados deberán identificarse para evitar ediciones manuales que posteriormente se pierdan.

## Fuente de verdad

Cada dato deberá tener una fuente de verdad definida.

Ejemplos:

* versiones en configuración;
* decisiones en ADR;
* comportamiento en especificaciones;
* API en código o documentación generada;
* estado de pruebas en resultados automatizados.

No deberá mantenerse manualmente la misma información en múltiples lugares sin un mecanismo de sincronización.

## Trazabilidad

La documentación deberá permitir relacionar:

```text
Requerimiento
    ↓
Especificación
    ↓
Decisión
    ↓
Implementación
    ↓
Prueba
    ↓
Evidencia
```

Las referencias podrán utilizar identificadores como:

```text
RF-003
RNF-004
ADR-003
SPEC-logging
TEST-logging-no-ansi
```

No es necesario implantar desde el primer día una herramienta compleja.

La trazabilidad deberá crecer con el proyecto.

## Relación con ADR

Los documentos deberán enlazar los ADR que justifican decisiones relevantes.

Ejemplo:

```markdown
La adopción de OpenSpec se documenta en
[ADR-003](../../adr/decisions/003-adopt-openspec.qmd).
```

No se copiará el contenido completo del ADR dentro de otros documentos.

## Relación con especificaciones

La documentación de módulos deberá enlazar su especificación vigente.

La especificación define el comportamiento esperado.

La documentación de uso explica cómo interactuar con la implementación.

Ambas deberán mantenerse coherentes.

## Relación con pruebas

Los requerimientos y especificaciones deberán incluir o enlazar criterios de aceptación.

La documentación de pruebas deberá indicar qué comportamientos demuestra.

Cuando una prueba completa genere evidencias, estas deberán incluir:

* fecha;
* versión;
* commit;
* plataforma;
* resultado;
* log relevante.

## Laboratorios

Los Labs documentarán procesos experimentados y validados.

No deberán escribirse como simples transcripciones de comandos.

Cada Lab deberá incluir:

* objetivo;
* contexto;
* hipótesis;
* requisitos previos;
* procedimiento;
* observaciones;
* problemas encontrados;
* resultados;
* conclusiones;
* limpieza o reversión, cuando proceda.

El Lab deberá distinguir entre:

* lo previsto;
* lo observado;
* lo aprendido.

## Errores conocidos

Los módulos podrán mantener una sección de errores o limitaciones conocidas.

Cada entrada deberá indicar:

* síntoma;
* causa conocida;
* impacto;
* solución temporal;
* estado.

Los problemas corregidos deberán trasladarse al historial cuando corresponda.

## Resolución de problemas

La documentación de troubleshooting deberá organizarse por síntomas observables.

Ejemplo:

```markdown
## OpenSpec busca package.json en el directorio actual

### Síntoma

...

### Causa

...

### Solución

...
```

No deberá limitarse a una lista desordenada de comandos.

## Historial de cambios

Los cambios relevantes deberán registrarse mediante:

* Git;
* ADR;
* especificaciones;
* changelog cuando exista una versión publicada.

El historial no deberá depender únicamente de mensajes de commit poco descriptivos.

## Changelog

Cuando el proyecto produzca versiones consumibles, deberá mantener un `CHANGELOG.md`.

Deberá recoger:

* nuevas capacidades;
* cambios;
* correcciones;
* incompatibilidades;
* eliminaciones;
* migraciones necesarias.

No incluirá cada cambio interno menor.

## Obsolescencia

La documentación obsoleta no deberá permanecer activa sin indicación.

Podrá:

* eliminarse si no tiene valor histórico;
* marcarse como obsoleta;
* trasladarse a archivo;
* enlazar el documento sustituto.

Los ADR conservarán siempre su valor histórico y no se eliminarán.

## Revisión

Toda modificación relevante del código deberá revisar la documentación afectada.

La revisión deberá comprobar:

* exactitud;
* enlaces;
* ejemplos;
* versiones;
* capturas;
* requisitos;
* especificaciones;
* ADR relacionados.

Un cambio no deberá considerarse completo cuando deja documentación inconsistente.

## Validación automatizada

Se evaluará la automatización de comprobaciones como:

* enlaces rotos;
* formato Markdown;
* encabezados;
* identificadores duplicados;
* bloques de código;
* referencias inexistentes;
* índice de ADR;
* ortografía técnica;
* archivos sin usar.

La automatización deberá apoyar la calidad, no sustituir la revisión humana.

## Markdown lint

La documentación Markdown deberá validarse mediante reglas compartidas.

Las excepciones deberán configurarse a nivel de proyecto y no según preferencias individuales.

No se forzarán reglas que reduzcan significativamente la legibilidad o entren en conflicto con Quarto.

## Plantillas

Los documentos repetitivos deberán utilizar plantillas.

Ejemplos:

```text
templates/
├── adr.qmd
├── module-readme.md
├── specification.md
├── lab.qmd
└── test-report.md
```

Las plantillas deberán definir una estructura mínima sin impedir adaptaciones justificadas.

## Código generado por IA

La documentación generada por IA deberá revisarse para detectar:

* afirmaciones no verificadas;
* ejemplos inexistentes;
* versiones inventadas;
* incoherencias;
* explicaciones genéricas;
* referencias falsas;
* repetición innecesaria;
* contradicciones con el código.

La fluidez del texto no constituye prueba de corrección.

## Conversaciones con IA

Las conversaciones podrán servir para explorar y redactar.

Las decisiones y conocimientos relevantes deberán trasladarse a artefactos persistentes del repositorio.

No deberá dependerse del historial de una conversación para comprender una decisión vigente.

## Documentación mínima antes de implementar

Antes de comenzar una funcionalidad relevante deberá existir, al menos:

* problema u objetivo;
* alcance;
* requerimientos afectados;
* criterios de aceptación;
* restricciones principales.

No es necesario completar toda la documentación del sistema antes de cada cambio.

Debe existir suficiente conocimiento para orientar la implementación.

## Documentación al finalizar

Antes de considerar terminada una funcionalidad deberá comprobarse:

* especificación actualizada;
* README actualizado;
* ejemplos válidos;
* pruebas documentadas;
* ADR creado o actualizado, si procede;
* limitaciones registradas;
* evidencias disponibles cuando sean necesarias.

## Evitar duplicación

No se copiarán grandes fragmentos entre documentos.

Se utilizarán:

* enlaces;
* referencias;
* includes de Quarto;
* generación automática;
* fuentes centralizadas.

Cuando sea inevitable repetir una idea, deberá definirse qué documento es la fuente principal.

## Proporcionalidad

La documentación deberá ser proporcional al riesgo, complejidad y permanencia.

Una función interna sencilla no requiere un tratado.

Una decisión arquitectónica, una interfaz pública o un instalador que modifique el sistema sí requieren documentación suficiente.

El objetivo no es producir documentos.

Es conservar conocimiento útil.

## Criterio final

Un proyecto está bien documentado cuando una persona puede incorporarse, comprenderlo, utilizarlo, verificarlo y modificarlo sin depender de quienes lo crearon.

La documentación debe permitir conocer no solo qué hace el sistema, sino también por qué fue construido de esa manera y cómo demostrar que sigue funcionando.
