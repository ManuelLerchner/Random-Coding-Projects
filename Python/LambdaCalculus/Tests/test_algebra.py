import unittest
from main import evaluate


class Test_Algebra(unittest.TestCase):

    def test_SUCC(self):
        inputString = "(SUCC (SUCC (SUCC FOUR)))"
        res = str(evaluate(inputString))
        self.assertTrue("SEVEN" in res)

    def test_MULT(self):
        inputString = "((MULT TWO) FOUR)"
        res = str(evaluate(inputString))
        self.assertTrue("EIGHT" in res)

    def test_PRED(self):
        inputString = "(PRED (PRED TEN))"
        res = str(evaluate(inputString))
        self.assertTrue("EIGHT" in res)

    def test_EXP(self):
        inputString = "((EXP ONE) FIVE)"
        res = str(evaluate(inputString))
        self.assertTrue("ONE" in res)

    def test_MINUS(self):
        inputString = "((MINUS EIGHT) THREE)"
        res = str(evaluate(inputString))
        self.assertTrue("FIVE" in res)

    def test_MINUS2(self):
        inputString = "((MINUS ZERO) THREE)"
        res = str(evaluate(inputString))
        self.assertTrue("ZERO" in res)

    def test_EXP1(self):
        inputString = "((EXP TWO) THREE)"
        res = str(evaluate(inputString))
        self.assertTrue("EIGHT" in res)


if __name__ == '__main__':
    unittest.main()
