import unittest
from main import evaluate


class Test_Logic(unittest.TestCase):

    def test_IFTHENELSE(self):
        inputString = "(((IFTHENELSE FALSE) A) B)"
        res = str(evaluate(inputString))
        self.assertTrue("B" in res)

    def test_IFTHENELSE(self):
        inputString = "(((IFTHENELSE TRUE) A) B)"
        res = str(evaluate(inputString))
        self.assertTrue("A" in res)


if __name__ == '__main__':
    unittest.main()
