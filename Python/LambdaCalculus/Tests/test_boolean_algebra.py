import unittest
from main import evaluate


class Test_Boolean_Algebra(unittest.TestCase):

    def test_ISZERO(self):
        inputString = "(ISZERO ZERO)"
        res = str(evaluate(inputString))
        self.assertTrue("TRUE" in res)

    def test_LEQ1(self):
        inputString = "((LEQ THREE) THREE)"
        res = str(evaluate(inputString))
        self.assertTrue("TRUE" in res)

    def test_LEQ2(self):
        inputString = "((LEQ TWO) THREE)"
        res = str(evaluate(inputString))
        self.assertTrue("TRUE" in res)

    def test_LEQ3(self):
        inputString = "((LEQ TEN) TWO)"
        res = str(evaluate(inputString))
        self.assertTrue("FALSE" in res)


if __name__ == '__main__':
    unittest.main()
