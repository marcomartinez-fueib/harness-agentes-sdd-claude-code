# Bitácora histórica (append-only)

> Cada vez que se cierra una sesión, su resumen se añade aquí.
> No edites entradas anteriores. Solo añades al final.

---

## Sesión de ejemplo — saludo (DONE)

- Spec en `specs/saludo/` aprobado por el humano.
- Implementado `src/saludo.py` + `tests/test_saludo.py` (4 tests).
- Trazabilidad: R1 → `test_saludo_con_nombre`, `test_saludo_recorta_espacios`;
  R2 → `test_nombre_vacio_lanza_error`, `test_nombre_solo_espacios_lanza_error`.
- Reviewer: APPROVED.
