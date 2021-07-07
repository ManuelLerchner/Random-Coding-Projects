import unittest
from main import evaluate


class TestStringMethods(unittest.TestCase):

    def test_lambdaAnd(self):
        lambdaAnd = '((λp.λq.((p q) p) λa.λb.b) λa.λb.a)'
        res = str(evaluate(lambdaAnd))
        self.assertEqual(res, "λa.λb.b")

    def test_lambdaSwitchedAnd(self):
        switchedAnd = '(((λf.λa.λb.((f b) a) λp.λq.((p q) p)) λa.λb.a) λa.λb.b)'
        res = str(evaluate(switchedAnd))
        self.assertEqual(res, "λa.λb.b")


if __name__ == '__main__':
    unittest.main()
