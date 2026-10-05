# Arquitectura

> ✏️ **Plantilla — rellénala con tu proyecto.** Los agentes la leen antes de
> diseñar e implementar, y el reviewer rechaza código que la incumpla. Cuanto
> más concreta, mejor trabajan.

## Stack
- Lenguaje / runtime: Python 3 (ejemplo)
- Frameworks: —
- Persistencia: —

## Estructura de carpetas
```
src/      código de la aplicación
tests/    tests (espejo de src/: src/foo.py → tests/test_foo.py)
specs/    specs SDD por feature
docs/     documentación para humanos y agentes
progress/ estado de sesión e informes de subagentes
```

## Capas y reglas de dependencia
Ejemplo para una app con capas (borra lo que no aplique):
- `api/` → solo traduce HTTP ↔ servicios. Sin lógica de negocio.
- `services/` → lógica de negocio. No conoce HTTP.
- `repositories/` → único sitio con acceso a BD.
- Las dependencias van hacia abajo: `api → services → repositories`. Nunca al revés.
