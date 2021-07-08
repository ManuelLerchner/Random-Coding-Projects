import unittest
from main import evaluate


class Test_List(unittest.TestCase):

    def test_FIRST_EL(self):
        inputString = "(FIRST_EL ((PAIR a) b))"
        res = str(evaluate(inputString))
        self.assertTrue("a" in res)

    def test_SECOND_EL(self):
        inputString = "(SECOND_EL ((PAIR a) b))"
        res = str(evaluate(inputString))
        self.assertTrue("b" in res)

    def test_head(self):
        inputString = "(head ((cons a) ((cons b) c)))"
        res = str(evaluate(inputString))
        self.assertTrue("a" in res)

    def test_head_tail(self):
        inputString = "(head (tail ((cons a) ((cons b) c))))"
        res = str(evaluate(inputString))
        self.assertTrue("b" in res)

    def test_head1(self):
        inputString = "(head (tail (tail ((cons a) ((cons b) ((cons c) d))))))"
        res = str(evaluate(inputString))
        self.assertTrue("c" in res)

    def test_FIRST_EL1(self):
        inputString = "(FIRST_EL ((PAIR 5) j))"
        res = str(evaluate(inputString))
        self.assertTrue("5" in res)


if __name__ == '__main__':
    unittest.main()
