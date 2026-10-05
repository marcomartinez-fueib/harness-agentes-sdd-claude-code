# Requirements — saludo

> Feature 1 de `feature_list.json`. EARS estricto (ver `docs/specs.md`).

## R1
CUANDO se llama a `saludar` con un nombre no vacío, el sistema DEBE devolver
`"Hola, <nombre>!"` con el nombre sin espacios al principio ni al final.

## R2
SI el nombre está vacío o contiene solo espacios ENTONCES el sistema DEBE
lanzar `ValueError`.
