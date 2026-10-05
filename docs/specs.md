# Spec Driven Development (SDD)

> Este proyecto sigue un flujo Kiro-style: requirements → design → tasks → code.
> El código no se escribe hasta que el spec está aprobado por un humano.

## Estructura

Cada feature nueva (`"sdd": true` en `feature_list.json`) tiene una carpeta
dedicada en cuanto deja `pending`:

```
specs/<feature-name>/
├── requirements.md   # QUÉ se necesita (EARS notation)
├── design.md         # CÓMO se construirá (decisiones técnicas)
└── tasks.md          # PASOS concretos a implementar
```

El `feature-name` coincide con el campo `name` de `feature_list.json`.

## Estados de una feature

| Estado | Significado |
|--------|-------------|
| `pending` | Sin spec. El `spec_author` es el primero en actuar. |
| `spec_ready` | Spec redactado. Esperando aprobación humana. NO se toca código. |
| `in_progress` | Spec aprobado. `implementer` trabajando. |
| `done` | Código verde, `reviewer` aprobó, sesión cerrada. |
| `blocked` | Atascado. Razón en `progress/current.md`. |

## La puerta de aprobación humana

El flujo automático se detiene **una vez**: cuando el `spec_author` termina
sus tres archivos, marca la feature como `spec_ready` y para. El humano
lee `specs/<feature>/` y dice "aprobado" (o pide cambios).

Solo entonces el `leader` transiciona `spec_ready → in_progress` y lanza
el `implementer`.

```
pending → [spec_author] → spec_ready → ⏸ HUMANO → in_progress → [implementer → reviewer] → done
```

## requirements.md — EARS estricto

Las requirements se redactan en **EARS** (Easy Approach to Requirements Syntax).
Cada requirement es un párrafo numerado con uno de estos cinco patrones:

| Patrón | Plantilla |
|--------|-----------|
| **Ubicuo** | `El sistema DEBE <acción>.` |
| **Evento** | `CUANDO <disparador>, el sistema DEBE <acción>.` |
| **Estado** | `MIENTRAS <estado>, el sistema DEBE <acción>.` |
| **Opcional** | `DONDE <feature opcional>, el sistema DEBE <acción>.` |
| **No deseado** | `SI <evento no deseado> ENTONCES el sistema DEBE <acción>.` |

Reglas duras:

- Cada requirement tiene un id estable: `R1`, `R2`, ...
- Cada requirement DEBE ser verificable por al menos un test concreto.
- No mezcles varios `DEBE` en un mismo requirement. Si hay más de uno, parte.
- No uses verbos blandos ("podría", "puede", "soporta"). Solo `DEBE` / `NO DEBE`.

Ejemplo:

```markdown
## R1
CUANDO un usuario envía el formulario de registro con un email válido, el
sistema DEBE crear la cuenta en estado `pendiente_verificacion`.

## R2
SI el email ya existe ENTONCES el sistema DEBE responder con error 409 sin
revelar si la cuenta está verificada.

## R3
MIENTRAS la cuenta esté en `pendiente_verificacion`, el sistema NO DEBE
permitir iniciar sesión.
```

## design.md — decisiones técnicas

Captura **antes** de tocar código:

- Qué archivos se crean / modifican (ruta completa).
- Qué clases, funciones o endpoints nuevos aparecen (con firmas).
- Qué alternativa se descartó y por qué (mínimo una).
- Impacto en `docs/architecture.md` — ¿la feature roza alguna regla?

NO es ingeniería desde primeros principios — apóyate en
`docs/architecture.md` y `docs/conventions.md`. El `design.md` documenta los
puntos donde tu feature roza la frontera de esas reglas.

## tasks.md — checklist ejecutable

Pasos discretos en orden, cada uno con checkbox. Cada task referencia al
menos un `R<n>` que cubre.

Ejemplo:

```markdown
- [ ] T1 — Crear `registrar_usuario()` en `src/cuentas/servicios.py`. Cubre: R1, R2.
- [ ] T2 — Test `test_registro_crea_cuenta_pendiente` en `tests/test_cuentas.py`. Cubre: R1.
- [ ] T3 — Test `test_email_duplicado_devuelve_409`. Cubre: R2.
- [ ] T4 — Bloquear login de cuentas pendientes en `src/cuentas/login.py`. Cubre: R3.
- [ ] T5 — Test `test_login_rechazado_si_pendiente`. Cubre: R3.
```

El `implementer` marca `[x]` cada task al completarla. El `reviewer`
rechaza si queda alguna `[ ]` sin justificación documentada.

## Trazabilidad (regla dura)

- Cada test debe poder mapearse a un `R<n>` de su spec.
- Cada `R<n>` debe tener al menos un test concreto.
- El `reviewer` comprueba esta correspondencia explícitamente y rechaza si falta.

El `implementer` documenta el mapa en `progress/impl_<name>.md`:

```markdown
## Trazabilidad
- R1 → `test_registro_crea_cuenta_pendiente`
- R2 → `test_email_duplicado_devuelve_409`
- R3 → `test_login_rechazado_si_pendiente`
```

## Cuándo NO aplica SDD

Las features con `"sdd": false` o sin el campo `sdd` NO tienen spec.
Úsalo para cambios triviales (typos, bumps de dependencias, docs).
