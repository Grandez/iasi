# PlantUML para Quarto

Filtro Lua que convierte bloques PlantUML en SVG mediante un PlantUML Server.

No necesita `curl`, Python, Java ni bibliotecas Lua adicionales. Usa la
codificación hexadecimal soportada por PlantUML (`~h`) y la mediabag de Pandoc.

## Uso

````markdown
```{.plantuml}
@startuml
Alice -> Bob : Hola
@enduml
```
````

Con parámetros dentro de las llaves:

````markdown
```{.plantuml
label="fig-plantuml-test"
fig-cap="Prueba de PlantUML"
width="80%"
server="http://plantuml.local:1025"
format="svg"
}
@startuml
Alice -> Bob : Hola
@enduml
```
````

En una sola línea:

````markdown
```{.plantuml label="fig-test" fig-cap="Prueba" width="80%"}
@startuml
Alice -> Bob : Hola
@enduml
```
````

## Activación

Si vive en:

```text
iasi/resources/quarto/_extensions/plantuml/
```

use en `_quarto.yml` o en el documento:

```yaml
filters:
  - ../resources/quarto/_extensions/plantuml/plantuml.lua
```

Ajuste la ruta relativa según la ubicación del proyecto Quarto.

## Nombre local

En Windows puede añadir:

```text
127.0.0.1 plantuml.local
```

al fichero:

```text
C:\Windows\System32\drivers\etc\hosts
```

El servidor por defecto es:

```text
http://plantuml.local:1025
```

## Desarrollo

Durante el desarrollo, renderice desde terminal:

```bash
quarto render prueba.qmd
```

RStudio Preview puede mantener un proceso persistente y no recargar de inmediato
un filtro situado fuera del proyecto.
