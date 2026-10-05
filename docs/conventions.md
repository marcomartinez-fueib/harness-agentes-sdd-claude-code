# Convenciones

> ✏️ **Plantilla — adáptala.** Lo que no esté escrito aquí, el agente lo
> inventará; si te importa, escríbelo.

## Código
- Nombres en español o inglés, pero **uno solo** en todo el repo.
- Funciones pequeñas y puras cuando sea posible.
- Errores: lanza excepciones específicas (`ValueError`, excepciones propias), nunca
  devuelvas `None` para señalar error.
- Sin `print()` de debug en código commiteado.

## Tests
- Un archivo de test por módulo: `src/x.py` → `tests/test_x.py`.
- Nombre del test = comportamiento: `test_nombre_vacio_lanza_error`.
- Comentario `# R<n>` en cada test que cubra un requirement.

## Git
- Commits pequeños con [Conventional Commits](https://www.conventionalcommits.org/es/):
  `feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `chore:`.
- Una feature = una rama (`feat/<name>`) o al menos un bloque de commits coherente.
- El hook `pre-push` ejecuta `./init.sh`; si está rojo, no se sube.
