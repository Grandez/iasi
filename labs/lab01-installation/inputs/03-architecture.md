# Arquitectura

## Introducción

El proyecto se estructura como un conjunto de módulos independientes organizados por responsabilidad.

Cada módulo representa una capacidad concreta del sistema y podrá desarrollarse, mantenerse y evolucionar de forma independiente.

La arquitectura persigue minimizar el acoplamiento y maximizar la reutilización.

---

# Visión general

El sistema se divide en cinco grandes áreas.

- Configuración
- Bibliotecas comunes
- Instalación
- Verificación
- Registro

La siguiente figura resume la arquitectura lógica.

```
                 +----------------+
                 | Configuration  |
                 +--------+-------+
                          |
                          |
        +-----------------+-----------------+
        |                                   |
        v                                   v
+---------------+                 +----------------+
| Common Library|                 | Logging System |
+-------+-------+                 +-------+--------+
        |                                 |
        +-----------------+---------------+
                          |
                          v
                +-------------------+
                | Installation      |
                | Modules           |
                +-------------------+
                          |
                          v
                +-------------------+
                | Verification      |
                +-------------------+
```

---

# Componentes

## Configuración

Contiene toda la configuración común del proyecto.

Versiones.

Parámetros.

Opciones globales.

No contendrá lógica.

---

## Bibliotecas

Implementan funcionalidad reutilizable.

Ejemplos:

- logging
- apt
- descargas
- validaciones
- utilidades

Toda funcionalidad compartida deberá residir aquí.

---

## Instalación

Cada módulo instala una única herramienta o capacidad.

Ejemplos:

- Docker
- Java
- R
- Quarto
- OpenSpec

Los módulos únicamente coordinan la instalación.

No implementan lógica común.

---

## Verificación

Cada módulo dispondrá de una verificación equivalente.

Una instalación no podrá considerarse finalizada hasta superar su verificación.

---

## Registro

Todo el sistema utilizará un mecanismo homogéneo de logging.

El usuario deberá conocer en todo momento:

- qué está ocurriendo;
- qué módulo se ejecuta;
- si existe algún problema.

---

# Dependencias

Las dependencias deberán dirigirse siempre hacia las bibliotecas comunes.

Los módulos no deberán depender entre sí salvo cuando resulte imprescindible.

---

# Principios arquitectónicos

- Bajo acoplamiento.
- Alta cohesión.
- Responsabilidad única.
- Reutilización.
- Independencia.
- Simplicidad.

---

# Evolución

La arquitectura está diseñada para crecer mediante la incorporación de nuevos módulos.

La incorporación de una nueva herramienta no deberá requerir modificaciones en los módulos existentes, salvo cuando introduzca una nueva capacidad compartida.