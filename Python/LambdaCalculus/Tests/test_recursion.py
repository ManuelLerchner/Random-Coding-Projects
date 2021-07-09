import unittest
from main import evaluate


class Test_Recursion(unittest.TestCase):
    def test_Fibonacci(self):
        inputString = "(FIB ONE)"
        res = str(evaluate(inputString))
        self.assertTrue("ONE" in res)

    def test_Factorial(self):
        inputString = "(FACT TWO)"
        res = str(evaluate(inputString))
        self.assertTrue("TWO" in res)


if __name__ == '__main__':
    unittest.main()
