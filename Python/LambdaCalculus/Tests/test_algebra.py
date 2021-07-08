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
        inputString = "((EXP TWO) THREE)"
        res = str(evaluate(inputString))
        self.assertTrue("λx.λx.(x (x (x (x (x (x (x (x x))))))))" in res)

    def test_MINUS(self):
        inputString = "((MINUS EIGHT) THREE)"
        res = str(evaluate(inputString))
        self.assertTrue("FIVE" in res)


if __name__ == '__main__':
    unittest.main()
