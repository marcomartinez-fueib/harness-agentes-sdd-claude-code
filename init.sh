#!/bin/bash
# Verifica que el entorno está listo. Debe terminar con exit 0.
# Es la "fuente de verdad" de que el proyecto está sano: la usan los agentes,
# el hook Stop de Claude Code y el hook pre-push de git.
#
# ADÁPTALO A TU STACK: sustituye el bloque de tests por pytest, npm test,
# cargo test, go test… y añade lint/typecheck si los tienes.
set -e

echo "[init] Verificando entorno..."

# Activa los git hooks versionados del repo (idempotente).
if [ -d scripts/git-hooks ] && command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
    if [ "$(git config core.hooksPath 2>/dev/null || true)" != "scripts/git-hooks" ]; then
        git config core.hooksPath scripts/git-hooks
        echo "[init] git hooks activados (core.hooksPath=scripts/git-hooks)."
    fi
fi

# Coherencia del backlog: JSON válido y como mucho una feature in_progress.
python3 - <<'PY'
import json, sys
d = json.load(open("feature_list.json"))
valid = set(d["rules"]["valid_status"])
bad = [f["name"] for f in d["features"] if f["status"] not in valid]
wip = [f["name"] for f in d["features"] if f["status"] == "in_progress"]
if bad:
    sys.exit(f"[FAIL] Estados inválidos en feature_list.json: {bad}")
if len(wip) > 1:
    sys.exit(f"[FAIL] Más de una feature in_progress: {wip}")
print(f"[init] feature_list.json OK ({len(d['features'])} features)")
PY

# Tests (ejemplo en Python con unittest, sin dependencias).
echo "[init] Ejecutando tests..."
python3 -m unittest discover -s tests -q

echo "[OK] Entorno listo"
