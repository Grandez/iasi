# Módulos

## Introducción

El sistema se organiza mediante módulos independientes.

Cada módulo implementa una única capacidad del entorno de desarrollo.

Los módulos podrán ejecutarse de forma individual o combinarse para construir instalaciones completas.

---

# Tipos de módulos

Se distinguen cuatro tipos de módulos.

- Infraestructura
- Instalación
- Verificación
- Utilidades

---

# Infraestructura

Proporcionan servicios comunes al resto del sistema.

Ejemplos:

- configuración
- logging
- utilidades
- descargas
- validaciones

Los módulos de infraestructura no instalan software.

---

# Instalación

Representan la instalación de una única herramienta o componente.

Cada módulo tendrá una única responsabilidad.

Ejemplos:

- Sistema base
- Git
- Docker
- Node.js
- OpenSpec
- Ollama
- Python
- Java
- R
- RStudio
- Quarto
- TinyTeX

---

# Verificación

Cada módulo de instalación dispondrá de un módulo equivalente de verificación.

La verificación comprobará que:

- la instalación existe;
- la versión es correcta;
- el componente puede ejecutarse.

---

# Dependencias

Los módulos únicamente podrán depender de:

- infraestructura;
- configuración;
- módulos explícitamente declarados.

Las dependencias implícitas deberán evitarse.

---

# Flujo de ejecución

Una instalación típica seguirá el siguiente orden.

Sistema

↓

Infraestructura

↓

Herramientas base

↓

Lenguajes

↓

Herramientas de desarrollo

↓

Herramientas de IA

↓

Validación

---

# Evolución

El sistema está diseñado para admitir nuevos módulos sin modificar la arquitectura existente.

La incorporación de una nueva herramienta deberá limitarse, preferentemente, a:

- un nuevo módulo de instalación;
- un nuevo módulo de verificación.

El resto del sistema no debería requerir modificaciones.