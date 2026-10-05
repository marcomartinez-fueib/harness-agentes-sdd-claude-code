# Arnés de agentes SDD para Claude Code

Plantilla para programar con **Claude Code** usando un equipo de subagentes
coordinados y un flujo **SDD** (*Spec Driven Development*): primero se escribe
una especificación, un humano la aprueba, y solo entonces los agentes escriben
código y tests. Ninguna feature se da por terminada sin tests verdes y sin que
un revisor automático compruebe que cada requisito está cubierto por un test.

Es el esqueleto de un sistema que uso a diario en un proyecto real
(Django + React, más de 80 features entregadas así), sin el código del producto
y con un ejemplo mínimo en Python para que funcione desde el primer clon.

> 🔀 **Hay dos versiones de esta plantilla:**
> - **Esta**, para Claude Code (de pago, la más fiable siguiendo el protocolo).
> - [`harness-agentes-sdd-opencode`](https://github.com/marcomartinez-fueib/harness-agentes-sdd-opencode),
>   para [opencode](https://opencode.ai) con **modelos gratuitos**.
>
> El flujo, las specs, el backlog y la documentación son idénticos; solo
> cambia la capa que conecta con la herramienta.

---

## Índice

1. [La idea en 30 segundos](#la-idea-en-30-segundos)
2. [Requisitos](#requisitos)
3. [Puesta en marcha](#puesta-en-marcha)
4. [Tu primera feature, paso a paso](#tu-primera-feature-paso-a-paso)
5. [Qué hay en el repo](#qué-hay-en-el-repo)
6. [Los cuatro agentes](#los-cuatro-agentes)
7. [El flujo SDD y los estados](#el-flujo-sdd-y-los-estados)
8. [Las specs: EARS, design y tasks](#las-specs-ears-design-y-tasks)
9. [Las redes de seguridad](#las-redes-de-seguridad)
10. [Adaptarlo a tu proyecto](#adaptarlo-a-tu-proyecto)
11. [Consejos de uso](#consejos-de-uso)
12. [Preguntas frecuentes](#preguntas-frecuentes)

---

## La idea en 30 segundos

```
            tú: "implementa la siguiente feature"
                          │
                          ▼
                  ┌───────────────┐
                  │    leader     │  coordina, NUNCA escribe código
                  └───────┬───────┘
                          │
        ┌─────────────────┼──────────────────────────────┐
        ▼                 ▼                              ▼
 ┌─────────────┐   ⏸ TÚ APRUEBAS     ┌─────────────┐   ┌──────────┐
 │ spec_author │ ─► el spec ───────► │ implementer │ ─►│ reviewer │
 └─────────────┘                     └─────────────┘   └──────────┘
 requirements.md                      código + tests    APPROVED /
 design.md                            tasks [x]         CHANGES_REQUESTED
 tasks.md
```

Tres principios sostienen todo:

1. **El estado vive en archivos, no en la conversación.** El backlog está en
   `feature_list.json`, el progreso en `progress/`, las specs en `specs/`.
   Puedes cerrar Claude Code, volver mañana y retomar exactamente donde lo
   dejaste. Cualquier agente nuevo se orienta leyendo `AGENTS.md`.
2. **Separación de roles.** Quien coordina no implementa, quien implementa no
   se autoaprueba, quien revisa no arregla. Cada agente tiene un único trabajo
   y unas reglas duras que se lo impiden salirse.
3. **Demostrar, no afirmar.** "Debería funcionar" no vale. `./init.sh` en verde
   y cada requisito `R<n>` mapeado a un test concreto es lo único que cuenta.

---

## Requisitos

- [Claude Code](https://docs.claude.com/en/docs/claude-code) instalado y con
  sesión iniciada (`claude` en la terminal).
- Python 3.9+ (solo para el ejemplo; cámbialo por tu stack, ver
  [Adaptarlo](#adaptarlo-a-tu-proyecto)).
- Git.

---

## Puesta en marcha

```bash
# 1. Crea tu repo a partir de esta plantilla (botón "Use this template" en
#    GitHub) o clónalo directamente:
git clone https://github.com/marcomartinez-fueib/harness-agentes-sdd-claude-code.git mi-proyecto
cd mi-proyecto

# 2. Comprueba que el entorno está sano (también activa el hook pre-push):
./init.sh
# → [OK] Entorno listo

# 3. Abre Claude Code en la carpeta:
claude
```

Al arrancar, Claude Code carga automáticamente `CLAUDE.md`, que le dice que
actúe como **leader**. Los subagentes de `.claude/agents/` y los hooks de
`.claude/settings.json` también se cargan solos: no hay que instalar nada más.

> 💡 Comprueba que los agentes se han detectado con el comando `/agents`
> dentro de Claude Code. Deberías ver `leader`, `spec_author`, `implementer`
> y `reviewer`.

---

## Tu primera feature, paso a paso

El repo trae dos features de ejemplo en `feature_list.json`:

- `saludo` → ya está `done`. Mírala para ver cómo queda una feature terminada:
  `specs/saludo/`, `src/saludo.py`, `tests/test_saludo.py`,
  `progress/impl_saludo.md` y `progress/review_saludo.md`.
- `contador-palabras` → está `pending`. Es la que vas a hacer tú.

### 1. Pide la feature

En Claude Code escribe:

```
implementa la siguiente feature pendiente
```

El leader lee el backlog, ejecuta `./init.sh`, ve que `contador-palabras` está
`pending` y lanza al **spec_author**. Este escribe:

```
specs/contador-palabras/requirements.md   ← QUÉ (requisitos R1, R2… en EARS)
specs/contador-palabras/design.md         ← CÓMO (archivos, firmas, alternativas)
specs/contador-palabras/tasks.md          ← PASOS (T1, T2… cada uno cubre R<n>)
```

…y cambia el estado a `spec_ready`. El leader **se detiene** y te dice:

> Spec listo en `specs/contador-palabras/`. Revísalo y di **'aprobado'** para
> continuar con la implementación, o pídeme cambios.

### 2. Revisa el spec (la parte importante)

Abre los tres archivos. Este es el momento más barato para corregir el rumbo:
cambiar una línea de `requirements.md` cuesta segundos; cambiar código ya
escrito, mucho más. Pregúntate:

- ¿Falta algún caso límite? (¿y si el texto solo tiene signos de puntuación?)
- ¿Algún requisito es ambiguo o imposible de testear?
- ¿El diseño toca archivos que no debería?

Si quieres cambios, díselo en lenguaje natural ("añade un requisito para
números", "R3 no me convence porque…"). Cuando esté bien:

```
aprobado
```

### 3. Implementación y revisión (automático)

El leader pasa la feature a `in_progress` y lanza al **implementer**, que
ejecuta las tasks una a una marcándolas `[x]`, escribe código y tests, pasa
`./init.sh` y documenta el mapa requisito → test en
`progress/impl_contador-palabras.md`.

Después lanza al **reviewer**, que comprueba trazabilidad, tasks, arquitectura
y `CHECKPOINTS.md`, y escribe su veredicto en
`progress/review_contador-palabras.md`. Si rechaza, el implementer corrige y se
vuelve a revisar. Si aprueba, la feature pasa a `done` y el resumen se archiva
en `progress/history.md`.

### 4. Commit

Revisa el diff (`git diff`) y haz commit tú o pídeselo a Claude. El hook
`pre-push` volverá a pasar `./init.sh` antes de subir nada.

### 5. Añade tus propias features

Edita `feature_list.json` y añade entradas como esta:

```json
{
  "id": 3,
  "name": "exportar-csv",
  "title": "Exportar resultados a CSV",
  "description": "Qué es y por qué lo quieres, en 1-3 frases.",
  "acceptance": [
    "Criterio observable 1",
    "Criterio observable 2"
  ],
  "status": "pending",
  "sdd": true
}
```

- `name` es el identificador: da nombre a la carpeta `specs/<name>/` y a los
  informes `progress/*_<name>.md`. Usa kebab-case.
- `acceptance` es lo que más ayuda al spec_author. Si es insuficiente, el
  spec_author marcará la feature como `blocked` y te pedirá aclaraciones en
  vez de inventarse requisitos.
- `"sdd": false` para cambios triviales que no merecen spec.

También puedes pedírselo a Claude: *"añade al backlog una feature para
exportar a CSV con estos criterios: …"* (editar `feature_list.json` sí se lo
permite al leader).

---

## Qué hay en el repo

```
.
├── CLAUDE.md                 # Se carga solo al abrir Claude Code: "eres el leader"
├── AGENTS.md                 # Mapa del repo para cualquier agente (punto de entrada)
├── CHECKPOINTS.md            # Criterios objetivos de "estado sano" (los usa el reviewer)
├── init.sh                   # Verificación del entorno: backlog coherente + tests
├── feature_list.json         # Backlog con estados
│
├── .claude/
│   ├── settings.json         # Permisos y hooks (tests tras cada edición, init.sh al parar)
│   └── agents/
│       ├── leader.md         # Orquestador
│       ├── spec_author.md    # Redacta specs
│       ├── implementer.md    # Escribe código + tests
│       └── reviewer.md       # Aprueba o rechaza
│
├── docs/
│   ├── specs.md              # El proceso SDD y el formato EARS
│   ├── verification.md       # Qué cuenta como "funciona"
│   ├── architecture.md       # ✏️ Plantilla: rellénala con tu arquitectura
│   └── conventions.md        # ✏️ Plantilla: tu estilo, tests y Git
│
├── specs/<feature>/          # requirements.md · design.md · tasks.md
├── progress/
│   ├── current.md            # Sesión en curso (se vacía al cerrar)
│   ├── history.md            # Bitácora append-only
│   ├── impl_<feature>.md     # Informe del implementer (trazabilidad)
│   └── review_<feature>.md   # Veredicto del reviewer
│
├── scripts/git-hooks/pre-push   # No deja hacer push si init.sh falla
├── src/                      # Tu código (ejemplo: saludo.py)
└── tests/                    # Tus tests (ejemplo: test_saludo.py)
```

---

## Los cuatro agentes

Cada agente es un archivo Markdown en `.claude/agents/` con un *frontmatter*
que define su nombre, descripción y **qué herramientas puede usar**. Las
herramientas son la primera barrera: el reviewer, por ejemplo, no tiene `Edit`
ni `Write`, así que físicamente no puede "arreglar" el código que revisa.

| Agente | Herramientas | Hace | No hace nunca |
|--------|--------------|------|---------------|
| **leader** | Read, Glob, Grep, Bash, Agent | Lee el backlog, decide qué toca, lanza subagentes, para en la puerta humana | Escribir en `src/`/`tests/`, marcar `done`, saltarse la aprobación |
| **spec_author** | Read, Write, Edit, Glob, Grep | Escribe los 3 archivos del spec y pone `spec_ready` | Tocar código, lanzar al implementer, inventar requisitos |
| **implementer** | Read, Write, Edit, Glob, Grep, Bash | Ejecuta `tasks.md`, escribe código y tests, pasa `init.sh` | Trabajar sin spec aprobado, desviarse del spec, autoaprobarse |
| **reviewer** | Read, Glob, Grep, Bash | Verifica trazabilidad, tasks, arquitectura, CHECKPOINTS | Editar nada; aprobar con tests rojos o requisitos sin test |

### La regla anti-teléfono-descompuesto

Los subagentes **escriben sus resultados en archivos** y al leader solo le
devuelven una línea con la referencia:

```
spec_ready -> specs/contador-palabras/
APPROVED -> progress/review_contador-palabras.md
```

¿Por qué? Porque si cada agente resume al siguiente lo que ha hecho, la
información se degrada en cada salto (como el juego del teléfono). Con
archivos, todos leen la misma fuente original, el contexto del leader no se
llena de detalles, y tú puedes auditar todo después.

### Escalado de esfuerzo

El leader no lanza siempre lo mismo; ajusta según la complejidad:

| Complejidad | Subagentes |
|-------------|------------|
| Trivial (1 archivo) | spec_author → ⏸ → implementer |
| Media (2-3 archivos) | spec_author → ⏸ → implementer → reviewer |
| Compleja (refactor) | 2-3 exploradores en paralelo → spec_author → ⏸ → implementer → reviewer |
| Muy compleja | Se parte en sub-features y se aplica la tabla a cada una |

---

## El flujo SDD y los estados

```
pending → [spec_author] → spec_ready → ⏸ HUMANO → in_progress → [implementer → reviewer] → done
                                                                                ↘ blocked
```

| Estado | Significa | Quién lo pone |
|--------|-----------|---------------|
| `pending` | Sin spec todavía | Tú, al añadirla |
| `spec_ready` | Spec escrito, esperando tu aprobación. No se toca código | spec_author |
| `in_progress` | Aprobada, implementándose. **Solo una a la vez** | leader, tras tu "aprobado" |
| `done` | Tests verdes + reviewer APPROVED | implementer, tras la aprobación del reviewer |
| `blocked` | Atascada; el motivo está en `progress/` | cualquiera |

La **puerta humana** es la única pausa del flujo y es deliberada: es donde tu
criterio aporta más con menos esfuerzo.

Si cierras la sesión a medias, al volver el leader verá el estado en
`feature_list.json` y sabrá qué hacer (p. ej. con `in_progress` te preguntará
si reanuda o aborta).

---

## Las specs: EARS, design y tasks

Detalle completo en [`docs/specs.md`](docs/specs.md). Resumen:

**`requirements.md`** usa EARS (*Easy Approach to Requirements Syntax*), cinco
plantillas que obligan a escribir requisitos sin ambigüedad:

| Patrón | Plantilla |
|--------|-----------|
| Ubicuo | `El sistema DEBE <acción>.` |
| Evento | `CUANDO <disparador>, el sistema DEBE <acción>.` |
| Estado | `MIENTRAS <estado>, el sistema DEBE <acción>.` |
| Opcional | `DONDE <feature opcional>, el sistema DEBE <acción>.` |
| No deseado | `SI <evento no deseado> ENTONCES el sistema DEBE <acción>.` |

Un `DEBE` por requisito, ids estables (`R1`, `R2`…) y cada uno testeable.

**`design.md`**: archivos a crear/modificar, firmas nuevas, errores y al menos
una alternativa descartada con su porqué.

**`tasks.md`**: checklist ordenado; cada task dice qué `R<n>` cubre.

```markdown
- [ ] T1 — Crear `contar_palabras()` en `src/contador.py`. Cubre: R1, R2.
- [ ] T2 — Test `test_ignora_mayusculas` en `tests/test_contador.py`. Cubre: R1.
```

La **trazabilidad** cierra el círculo: el reviewer rechaza si algún `R<n>` no
tiene al menos un test concreto que lo verifique.

---

## Las redes de seguridad

Las instrucciones en Markdown son "blandas": el modelo las sigue casi siempre,
pero no siempre. Por eso hay capas "duras" que ejecuta el sistema, no el agente:

| Capa | Dónde | Qué hace |
|------|-------|----------|
| Permisos de herramientas | frontmatter de cada agente | El reviewer no puede editar; el spec_author no puede ejecutar comandos |
| Hook `PostToolUse` | `.claude/settings.json` | Tras cada `Edit`/`Write`, corre los tests y le enseña el resultado al agente |
| Hook `Stop` | `.claude/settings.json` | Al terminar cada turno, ejecuta `./init.sh` y avisa si está rojo |
| `init.sh` | raíz | Valida el backlog (estados válidos, máx. una `in_progress`) y pasa los tests |
| Hook git `pre-push` | `scripts/git-hooks/` | No se puede hacer push con `init.sh` en rojo (`--no-verify` para emergencias) |
| `CHECKPOINTS.md` | raíz | Lista objetiva que el reviewer recorre antes de aprobar |

---

## Adaptarlo a tu proyecto

1. **Borra el ejemplo:** `src/saludo.py`, `tests/test_saludo.py`,
   `specs/saludo/`, `progress/*_saludo.md`, la entrada de ejemplo de
   `progress/history.md` y las dos features de `feature_list.json`.
2. **Rellena `docs/architecture.md` y `docs/conventions.md`.** Es lo que más
   mejora la calidad del resultado: los agentes leen estos archivos antes de
   diseñar e implementar, y el reviewer los usa como vara de medir. Todo lo que
   no escribas ahí, el modelo lo improvisará.
3. **Cambia el comando de tests** en dos sitios:
   - `init.sh` → bloque de tests (`pytest`, `npm test -- --run`, `cargo test`,
     `go test ./...`…). Añade lint y typecheck si los tienes.
   - `.claude/settings.json` → hook `PostToolUse` (mejor la versión rápida) y
     `permissions.allow`.
4. **Ajusta las rutas protegidas.** Si tu código no vive en `src/` y `tests/`
   (p. ej. `backend/` y `frontend/`), cámbialo en `CLAUDE.md`, `AGENTS.md`,
   `.claude/agents/leader.md`, `spec_author.md` y `CHECKPOINTS.md`
   (`grep -rn "src/" CLAUDE.md AGENTS.md CHECKPOINTS.md .claude/`).
5. **Actualiza `CHECKPOINTS.md`** con lo que para ti significa "proyecto sano"
   (p. ej. "no hay queries a BD fuera de `repositories/`").

### Extensiones que uso yo y puedes añadir

- **Integración con Jira/Linear/GitHub Issues:** un campo `"issue"` por feature
  y que el leader cree/transicione el ticket en cada cambio de estado. Regla
  importante: si la API falla, se anota en `progress/current.md` y **no** se
  bloquea el flujo.
- **Flujo de ramas `dev → pre → pro`** con el `pre-push` bloqueando commits
  directos a `pre`/`pro` y CI que repite `./init.sh`.
- **`init.sh full`** con cobertura para CI y una versión rápida (sin cobertura,
  tests en paralelo) para el día a día.
- **Informes de exploración** (`progress/explore_<tema>.md`) cuando el leader
  lanza agentes de investigación en paralelo antes de una feature compleja.

---

## Consejos de uso

- **Invierte tu tiempo en la revisión del spec**, no en revisar el código línea
  a línea. Un buen spec produce buen código casi siempre.
- **Features pequeñas.** Si un spec pasa de ~10 requisitos, pide partirla.
- **`acceptance` concretos y observables** en `feature_list.json`. "Que sea
  rápido" no sirve; "responde en < 200 ms con 1 000 elementos" sí.
- **Cuando algo sale mal, corrige el arnés, no solo el código.** Si el agente
  repite un error, añade una regla a `docs/conventions.md`, un checkpoint o un
  test. El sistema mejora con cada fallo.
- **Bugs urgentes:** puedes añadir una feature con `"sdd": false` o, para algo
  de una línea, decirle explícitamente al leader que lo haga un implementer sin
  spec. Tú mandas: las reglas protegen de errores, no de ti.
- **Retomar sesiones:** basta con abrir `claude` y decir *"¿en qué estado
  estamos?"*. El leader leerá `progress/current.md` y el backlog.
- **Mira los informes** `progress/impl_*.md` y `progress/review_*.md`: son la
  mejor forma de entender qué ha hecho cada agente y por qué.

---

## Preguntas frecuentes

**¿El leader de verdad no puede escribir código?**
Técnicamente sí: el leader es la sesión principal de Claude Code y tiene todas
las herramientas. Lo que se lo impide es `CLAUDE.md`. En la práctica lo respeta
muy bien, y las demás capas (hooks, reviewer, pre-push) atrapan lo que se
escape. Si lo ves saltárselo, recuérdaselo: "eres el leader, lanza un
implementer".

**¿Cuánto cuesta en tokens?**
Más que pedirle el cambio directamente: cada subagente arranca con contexto
limpio y lee la documentación. A cambio, el contexto de la sesión principal se
mantiene pequeño durante horas, el resultado es auditable y los errores se
cazan antes. Para cambios triviales usa `"sdd": false`.

**¿Funciona con otros lenguajes?**
Sí. Nada del flujo depende de Python; solo el ejemplo y el comando de tests.
Ver [Adaptarlo a tu proyecto](#adaptarlo-a-tu-proyecto).

**¿Y con opencode u otros agentes (Cursor, Codex, Gemini CLI…)?**
Para opencode hay una versión lista:
[`harness-agentes-sdd-opencode`](https://github.com/marcomartinez-fueib/harness-agentes-sdd-opencode).
Para los demás, `AGENTS.md`, las specs, el backlog y `progress/` son Markdown/JSON plano y
sirven para cualquiera. Lo específico de Claude Code es `CLAUDE.md`,
`.claude/agents/` (subagentes) y `.claude/settings.json` (hooks).

**¿Qué pasa si el reviewer rechaza una y otra vez?**
El leader relanza al implementer con el informe del reviewer. Tras dos rondas
fallidas para y te pregunta: normalmente significa que el spec tiene un
problema, no el código.

---

## Licencia

MIT. Úsalo, cámbialo y compártelo.
