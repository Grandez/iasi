# Visión

## Propósito

Este proyecto tiene como objetivo construir un sistema modular de instalación y configuración del entorno de desarrollo utilizado por IASI.

No pretende ser únicamente un conjunto de scripts Bash, sino una infraestructura reutilizable, reproducible y mantenible que permita preparar un sistema desde cero de forma automatizada.

El proyecto servirá tanto para el desarrollo diario de IASI como para documentar y enseñar el proceso de construcción de un entorno profesional de ingeniería de software e ingeniería asistida por IA.

---

## Motivación

Preparar un entorno de desarrollo moderno implica instalar y configurar decenas de herramientas.

Con frecuencia este proceso se realiza manualmente, sin documentación suficiente y con un alto riesgo de errores, diferencias entre equipos o pérdida de conocimiento.

Este proyecto pretende convertir ese proceso en un activo de ingeniería.

La instalación del entorno debe ser:

- reproducible;
- automatizable;
- verificable;
- documentada;
- mantenible.

---

## Objetivos

El sistema deberá permitir:

- instalar un entorno completo desde una instalación limpia de Kubuntu;
- ejecutar únicamente los módulos necesarios;
- verificar el estado del sistema;
- facilitar la actualización del entorno;
- documentar cada decisión tomada.

---

## Filosofía

El proyecto seguirá los mismos principios que defiende IASI.

La automatización no sustituye al conocimiento.

Los scripts representan la implementación de decisiones de ingeniería previamente analizadas y documentadas.

Cada módulo tendrá una única responsabilidad.

La complejidad deberá concentrarse en la infraestructura para que la utilización del sistema resulte sencilla.

---

## Alcance inicial

La primera versión incluirá la instalación y configuración de herramientas como:

- sistema base;
- utilidades de desarrollo;
- Git;
- Docker;
- Node.js;
- OpenSpec;
- Ollama;
- Java;
- Python;
- R;
- RStudio;
- Quarto;
- TinyTeX.

Cada componente será independiente y reutilizable.

---

## Fuera del alcance

Este proyecto no pretende:

- sustituir a un gestor de configuración como Ansible;
- administrar servidores en producción;
- soportar múltiples distribuciones Linux en la primera versión;
- automatizar procesos ajenos al entorno de desarrollo.

---

## Resultado esperado

El resultado final será una colección coherente de módulos reutilizables capaces de preparar un entorno de desarrollo completo con un número mínimo de pasos manuales.

El proyecto constituirá además el caso práctico utilizado por IASI para demostrar una metodología de ingeniería basada en especificaciones, automatización y asistencia mediante IA.