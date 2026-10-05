import unittest

from src.saludo import saludar


class TestSaludar(unittest.TestCase):
    def test_saludo_con_nombre(self):  # R1
        self.assertEqual(saludar("Ana"), "Hola, Ana!")

    def test_saludo_recorta_espacios(self):  # R1
        self.assertEqual(saludar("  Ana  "), "Hola, Ana!")

    def test_nombre_vacio_lanza_error(self):  # R2
        with self.assertRaises(ValueError):
            saludar("")

    def test_nombre_solo_espacios_lanza_error(self):  # R2
        with self.assertRaises(ValueError):
            saludar("   ")


if __name__ == "__main__":
    unittest.main()
