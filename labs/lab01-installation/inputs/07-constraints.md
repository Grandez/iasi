# Restricciones

## Introducción

Este documento recoge las restricciones técnicas y metodológicas del proyecto.

Estas restricciones deberán respetarse durante el diseño, la implementación y la evolución del sistema.

---

# Plataforma

La plataforma objetivo es Kubuntu LTS.

No se contempla inicialmente soporte para otras distribuciones Linux.

El soporte para otras plataformas podrá incorporarse en el futuro mediante módulos específicos.

---

# Lenguaje

Los scripts de instalación se desarrollarán utilizando Bash.

Las bibliotecas auxiliares deberán mantener la máxima compatibilidad posible con Bash.

---

# Gestor de paquetes

El mecanismo principal de instalación será APT.

Siempre que sea posible se utilizarán repositorios oficiales.

---

# Privilegios

El sistema utilizará privilegios elevados únicamente cuando resulte imprescindible.

No deberán ejecutarse procesos completos como usuario root.

---

# Dependencias externas

Toda dependencia externa deberá estar justificada.

Se evitarán herramientas innecesarias o con bajo nivel de mantenimiento.

---

# Idempotencia

Todos los módulos deberán poder ejecutarse varias veces sin producir efectos secundarios.

La repetición de una instalación no deberá provocar errores ni configuraciones inconsistentes.

---

# Compatibilidad

Los módulos deberán intentar minimizar el impacto sobre un sistema previamente configurado.

No deberán sobrescribir configuraciones del usuario salvo autorización explícita.

---

# Configuración

La configuración estará centralizada.

No deberán existir valores duplicados distribuidos entre distintos módulos.

---

# Estructura del proyecto

Todos los módulos deberán respetar la estructura oficial del repositorio.

No crearán directorios fuera de dicha estructura.

---

# Registro

Todo el sistema utilizará el mecanismo común de logging.

No se desarrollarán sistemas de registro independientes.

---

# Documentación

Toda decisión arquitectónica relevante deberá documentarse mediante un ADR.

Toda funcionalidad nueva deberá disponer de su especificación correspondiente.

---

# Calidad

El objetivo principal del proyecto no es únicamente automatizar instalaciones.

El objetivo es construir un sistema mantenible, reproducible y comprensible.