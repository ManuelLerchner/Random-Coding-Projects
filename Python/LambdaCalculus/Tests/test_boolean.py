import unittest
from main import evaluate


class Test_Boolean(unittest.TestCase):

    def test_AND(self):
        inputString = "((AND TRUE) TRUE)"
        res = str(evaluate(inputString))
        self.assertTrue("TRUE" in res)

    def test_XOR(self):
        inputString = "((XOR FALSE) TRUE)"
        res = str(evaluate(inputString))
        self.assertTrue("TRUE" in res)

    def test_NOT(self):
        inputString = "(NOT (NOT FALSE))"
        res = str(evaluate(inputString))
        self.assertTrue("FALSE" in res)

    def test_C_XOR(self):
        inputString = "(((C XOR) FALSE) FALSE)"
        res = str(evaluate(inputString))
        self.assertTrue("FALSE" in res)


if __name__ == '__main__':
    unittest.main()
