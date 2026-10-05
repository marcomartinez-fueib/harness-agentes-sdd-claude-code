# CHECKPOINTS — Evaluación del estado final

> En sistemas multi-agente no se evalúa el camino, se evalúa el destino.
> Checkpoints objetivos que un juez (humano o IA) usa para decidir si el
> proyecto está sano. El `reviewer` los recorre antes de aprobar.

## C1 — El arnés está completo
- [ ] Existen `AGENTS.md`, `init.sh`, `feature_list.json`, `progress/current.md`.
- [ ] Existen `docs/architecture.md`, `docs/conventions.md`, `docs/verification.md`, `docs/specs.md`.
- [ ] `./init.sh` termina con exit code 0.

## C2 — El estado es coherente
- [ ] Como mucho una feature en `in_progress` en `feature_list.json`.
- [ ] Toda feature `done` tiene tests asociados que pasan.
- [ ] `progress/current.md` está vacío o describe solo la sesión activa.

## C3 — El código respeta la arquitectura
- [ ] `src/` sigue la estructura de `docs/architecture.md`.
- [ ] No hay `print()` de debug ni TODOs sin contexto.

## C4 — La verificación es real
- [ ] `./init.sh` termina verde (tests + lo que añadas: lint, typecheck…).
- [ ] Los tests comprueban comportamiento, no solo "que no lanza excepción".

## C5 — La sesión se cerró bien
- [ ] No hay archivos sin trackear sospechosos.
- [ ] `progress/history.md` tiene una entrada por la última sesión.
- [ ] La última feature trabajada está en su estado correcto.

## C6 — Spec Driven Development
- [ ] Toda feature `sdd: true` en `spec_ready`, `in_progress` o `done` tiene
      `specs/<name>/` con `requirements.md`, `design.md` y `tasks.md`.
- [ ] `requirements.md` usa EARS estricto (ver `docs/specs.md`).
- [ ] Toda feature `done` tiene todas sus tasks `[x]`.
- [ ] Cada `R<n>` está cubierto por al menos un test concreto.
