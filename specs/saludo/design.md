# Design — saludo

## Archivos
- Nuevo: `src/saludo.py`
- Nuevo: `tests/test_saludo.py`

## Firmas
```python
def saludar(nombre: str) -> str: ...
```

## Errores
- `ValueError` si `nombre` está vacío o solo tiene espacios (R2).

## Alternativa descartada
- Devolver `"Hola, desconocido!"` con nombre vacío. Descartada: oculta errores
  del llamante; preferimos fallar pronto.

## Impacto en arquitectura
Ninguno: función pura en `src/`, sin dependencias.
