# AGENTS.md — Mapa de navegación para agentes de IA

> Punto de entrada para cualquier agente que trabaje en este repositorio.
> NO es una biblia de reglas: es un **mapa**. Lee solo lo que necesites cuando
> lo necesites (divulgación progresiva).

## 1. Antes de empezar (obligatorio)

1. Ejecuta `./init.sh` y verifica que termina sin errores. Si falla, **para**
   y resuelve el entorno antes de tocar código.
2. Lee `progress/current.md` para saber en qué estado quedó la última sesión.
3. Lee `feature_list.json`. Toda feature con `"sdd": true` pasa por
   **Spec Driven Development** — ver `docs/specs.md` y §4.

## 2. Mapa del repositorio

| Archivo / carpeta | Qué contiene | Cuándo leerlo |
|-------------------|-------------|---------------|
| `feature_list.json` | Backlog: features con estado (`pending` / `spec_ready` / `in_progress` / `done` / `blocked`) | Siempre, al empezar |
| `progress/current.md` | Estado de la sesión actual | Siempre, al empezar |
| `progress/history.md` | Bitácora append-only de sesiones anteriores | Si necesitas contexto histórico |
| `specs/<feature>/` | `requirements.md` + `design.md` + `tasks.md` | Antes de implementar una feature `sdd: true` |
| `docs/architecture.md` | Capas, módulos, reglas de dependencias | Antes de implementar |
| `docs/conventions.md` | Estilo, nombres, flujo de Git | Antes de escribir código o hacer commit |
| `docs/specs.md` | Proceso SDD: EARS, los 3 archivos, puerta humana | Antes de redactar o leer un spec |
| `docs/verification.md` | Cómo demostrar que el trabajo funciona | Antes de declarar algo `done` |
| `CHECKPOINTS.md` | Criterios objetivos de "estado final correcto" | Para auto-evaluarte |
| `.claude/agents/` | Subagentes: `leader`, `spec_author`, `implementer`, `reviewer` | Si orquestas trabajo |
| `src/` | Código de la aplicación | Para implementar |
| `tests/` | Tests | Para implementar / revisar |

## 3. Reglas duras (no negociables)

- **Una sola feature a la vez.** No mezcles cambios de varias tareas.
- **No declares una tarea `done` sin tests verdes** (`./init.sh` al 100%).
- **No saltes la fase de spec** ni la **puerta de aprobación humana**.
- **Documenta lo que haces** en `progress/current.md` mientras trabajas, no al final.
- **Deja el repositorio limpio** antes de cerrar la sesión (§5).
- **Si no sabes algo, busca en `docs/`** antes de inventarlo.

## 4. Flujo de trabajo (SDD)

```
pending → [spec_author] → spec_ready → ⏸ HUMANO → in_progress → [implementer → reviewer] → done
```

1. El leader detecta la primera feature `pending` con `"sdd": true`.
2. Lanza `spec_author`, que crea `specs/<name>/{requirements,design,tasks}.md`
   y marca el status como `spec_ready`.
3. **Pausa.** El humano lee el spec y aprueba (o pide cambios).
4. El leader cambia el status a `in_progress` y lanza `implementer`.
5. El implementer ejecuta `tasks.md` una a una, marcándolas `[x]`.
6. El reviewer verifica trazabilidad `R<n>` ↔ test y tasks completas.
7. Si aprueba, la feature pasa a `done` y el resumen va a `progress/history.md`.

## 5. Cierre de sesión

1. `./init.sh` — todo verde.
2. Si la tarea está acabada: `status: "done"` en `feature_list.json`.
3. Mueve el resumen de `progress/current.md` al final de `progress/history.md`.
4. Deja `progress/current.md` solo con la plantilla.
5. Sin archivos temporales, `print()` de debug ni TODOs sin contexto.

## 6. Si te bloqueas

- Relee la sección relevante de `docs/`.
- Si una herramienta no hace lo que esperas, **no inventes un workaround**:
  documenta el bloqueo en `progress/current.md` y para.
