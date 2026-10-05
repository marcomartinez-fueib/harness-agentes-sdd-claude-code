# Verificación — Cómo demostrar que el trabajo funciona

> Regla de oro: **el agente no dice "funciona", lo demuestra**.
> Toda feature termina con evidencia ejecutable, no con afirmaciones.

## Niveles

1. **Tests unitarios** de cada función pública: camino feliz + al menos un caso de error.
2. **Tests de integración** si la feature cruza capas (API, BD, CLI…).
3. **Suite completa:** `./init.sh` debe terminar con `[OK] Entorno listo`.
4. **Trazabilidad (features `sdd: true`):** cada `R<n>` de
   `specs/<name>/requirements.md` mapea a ≥1 test. El implementer lo documenta
   en `progress/impl_<name>.md`:

```markdown
## Trazabilidad
- R1 → `test_saludo_con_nombre`
- R2 → `test_nombre_vacio_lanza_error`
```

Marca el requirement en el propio test con un comentario (`# R1`) para que el
reviewer lo encuentre con `grep`.

## Anti-patrones

- ❌ "He añadido la función, debería funcionar." → falta test ejecutable.
- ❌ Test que solo verifica que la función no lanza excepción.
- ❌ Marcar `done` sin pasar `./init.sh`.

## Si `./init.sh` está rojo

No marques nada como `done`. Anota el bloqueo en `progress/current.md` y pon
la feature en `blocked` en `feature_list.json`.
