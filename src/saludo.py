"""Feature 1 — saludo. Spec: specs/saludo/."""


def saludar(nombre: str) -> str:
    """Devuelve un saludo personalizado (R1). Lanza ValueError si el nombre está vacío (R2)."""
    if not nombre or not nombre.strip():
        raise ValueError("El nombre no puede estar vacío")
    return f"Hola, {nombre.strip()}!"
