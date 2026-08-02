# Principios

## Introducción

Este proyecto no se construye únicamente para automatizar la instalación de software.

Su objetivo es demostrar una forma de hacer ingeniería.

Los principios descritos en este documento deberán prevalecer sobre las decisiones de implementación concretas.

---

# 1. Ingeniería antes que programación

Antes de escribir un script debe comprenderse el problema que se pretende resolver.

La programación constituye una fase posterior del proceso de ingeniería.

---

# 2. Modularidad

Cada módulo deberá tener una única responsabilidad.

Un módulo debe ser pequeño, sencillo y reutilizable.

La combinación de múltiples módulos permitirá construir instalaciones más complejas.

---

# 3. Reutilización

Toda funcionalidad común deberá implementarse una única vez.

Los módulos compartirán bibliotecas y utilidades comunes siempre que sea posible.

La duplicación de código deberá evitarse.

---

# 4. Idempotencia

Ejecutar un módulo varias veces no deberá producir efectos secundarios no deseados.

Siempre que sea posible, un módulo deberá detectar el estado actual antes de realizar modificaciones.

---

# 5. Verificación

Toda instalación deberá poder verificarse.

Instalar no es suficiente.

Cada componente deberá proporcionar mecanismos para comprobar que funciona correctamente.

---

# 6. Observabilidad

Todo el proceso deberá generar información suficiente para comprender qué está ocurriendo.

Los mensajes deberán ser claros, homogéneos y útiles para el diagnóstico.

---

# 7. Simplicidad

La complejidad debe concentrarse dentro de la infraestructura.

La utilización del sistema debe resultar sencilla.

---

# 8. Independencia

Cada módulo deberá poder ejecutarse de forma independiente.

No deberán existir dependencias ocultas entre módulos.

Las dependencias explícitas deberán documentarse.

---

# 9. Reproducibilidad

Dos instalaciones ejecutadas bajo las mismas condiciones deberán producir el mismo resultado.

---

# 10. Trazabilidad

Las decisiones de ingeniería deberán quedar documentadas.

Las modificaciones importantes deberán poder reconstruirse mediante ADR y especificaciones.

---

# 11. Prioridad por repositorios oficiales

Siempre que sea posible se utilizarán repositorios oficiales y mecanismos soportados por los fabricantes.

Las excepciones deberán documentarse y justificarse.

---

# 12. Automatización responsable

La automatización no elimina la necesidad de comprender el sistema.

Los scripts deberán facilitar el trabajo del ingeniero, nunca ocultar el funcionamiento del entorno.

---

# Conclusión

El éxito del proyecto no se medirá por el número de scripts desarrollados.

Se medirá por la claridad de su diseño, la facilidad de mantenimiento y la capacidad para reproducir un entorno completo de forma fiable y comprensible.