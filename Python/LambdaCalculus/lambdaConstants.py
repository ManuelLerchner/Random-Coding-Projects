import re


class Constants:

    Constants = {
        # Boolean
        "TRUE":         "λa.λb.a",
        "FALSE":        "λa.λb.b",
        # Numbers
        "ZERO":         "λf.λx.x",
        "ONE":          "λf.λx.(f x)",
        "TWO":          "λf.λx.(f (f x))",
        "THREE":        "λf.λx.(f (f (f x)))",
        "FOUR":         "λf.λx.(f (f (f (f x))))",
        "FIVE":         "λf.λx.(f (f (f (f (f x)))))",
        "SIX":          "λf.λx.(f (f (f (f (f (f x))))))",
        "SEVEN":        "λf.λx.(f (f (f (f (f (f (f x)))))))",
        "EIGHT":        "λf.λx.(f (f (f (f (f (f (f (f x))))))))",
        "NINE":         "λf.λx.(f (f (f (f (f (f (f (f (f x)))))))))",
        "TEN":          "λf.λx.(f (f (f (f (f (f (f (f (f (f x))))))))))",
        "ELEVEN":       "λf.λx.(f (f (f (f (f (f (f (f (f (f (f x)))))))))))",
        "TWELVE":       "λf.λx.(f (f (f (f (f (f (f (f (f (f (f (f x))))))))))))",
        "THIRTEEN":     "λf.λx.(f (f (f (f (f (f (f (f (f (f (f (f (f x)))))))))))))",
        "FOURTEEN":     "λf.λx.(f (f (f (f (f (f (f (f (f (f (f (f (f (f x))))))))))))))",
        "FIFTEEN":      "λf.λx.(f (f (f (f (f (f (f (f (f (f (f (f (f (f (f x)))))))))))))))",
        "SIXTEEN":      "λf.λx.(f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f x))))))))))))))))",
        "SEVENTEEN":    "λf.λx.(f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f x)))))))))))))))))",
        "EIGHTEEN":     "λf.λx.(f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f x))))))))))))))))))",
        "NINETEEN":     "λf.λx.(f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f x)))))))))))))))))))",
        "TWENTY":       "λf.λx.(f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f x))))))))))))))))))))",
    }

    Operations = {
        # Basic Operators https://youtu.be/3VQ382QG-y4
        "I":                "λx.x",
        "M":                "λf.(f f)",
        "K":                "λa.λb.a",
        "KI":               "λa.λb.b",
        "C":                "λf.λa.λb.((f b) a)",

        # Basic Operators Renamed
        "IDENTITY":         "I",
        "FIRST":            "K",
        "FLIP":             "C",
        "SECOND":           "KI",

        # Arithmetic
        "SUCC":             "λn.λf.λx.(f ((n f) x))",
        "PRED":             "λn.λf.λx.(((n λg.λh.(h (g f))) λu.x) λu.u)",
        "PLUS":             "λm.λn.λf.λx.((m f) ((n f) x))",
        "MULT":             "λm.λn.λf.(m (n f))",
        "EXP":              "λm.λn.λf.λx.(((n m) f) x)",
        "MINUS":            "λj.λk.((k PRED) j)",
        "div":              "λc.λn.λm.λf.λx.(λd.(((ISZERO d) ((ZERO f) x)) (f ((((c d) m) f) x))) ((MINUS n) m))",
        "divide1":          "(Y div)",
        "DIV":              "λn.(divide1 (SUCC n))",

        # Boolean
        "AND":              "λp.λq.((p q) p)",
        "OR":               "λp.λq.((p p) q)",
        "XOR":              "λp.λq.((p ((q λa.λb.b) λa.λb.a)) q)",
        "NOT":              "λf.λa.λb.((f b) a)",
        "IFTHENELSE":       "λb.λx.λy.((b x) y)",
        "ISZERO":           "λn.((n λx.FALSE) TRUE)",
        "LEQ":              "λm.λn.(ISZERO ((MINUS m) n))",
        "EQ":               "λm.λn.((AND ((LEQ m) n)) ((LEQ n) m))",

        # Tuple
        "PAIR":             "λx.λy.λz.((z x) y)",
        "FIRST_EL":         "λp.(p FIRST)",
        "SECOND_EL":        "λp.(p SECOND)",

        # List
        "nil":              "((PAIR TRUE) TRUE)",
        "isnil":            "FIRST_EL",
        "cons":             "λh.λt.((PAIR FALSE) ((PAIR h) t))",
        "head":             "λz.(FIRST_EL (SECOND_EL z))",
        "tail":             "λz.(SECOND_EL (SECOND_EL z))",

        # Recursion
        # (*recursion for call-by-name*)
        "Y":                "λf.(λx.(f (x x)) λx.(f (x x)))",
        "FACT_STEP":        "λg.λn.(((IFTHENELSE (ISZERO n)) ONE) ((MULT n) (g (PRED n))))",
        "FACT":             "(Y FACT_STEP)",

        # (*recursion for call-by-value*)
        "YV":               "λf.(λx.(f (λo.(x x) o)) λx.(f (λo.(x x) o)))",
        "FACT_STEPV":       "λg.λn.((((IFTHENELSE (ISZERO n)) λo.ONE) λo.((MULT n) (g (PRED n)))) o)",
        "FACTV":            "(YV FACT_STEPV)",

        "FIB_STEP":         "λg.λn.(((IFTHENELSE ((LEQ n) TWO)) ONE) ((PLUS (g (PRED n))) (g (PRED (PRED n)))))",
        "FIB":              "(Y FIB_STEP)",
    }

    def getAll(self):
        """
        Returns a Dict containing all defined Constants
        """
        return {**Constants.Constants, **Constants.Operations}

    def evaluateString(self, inputString: str, debug=False):
        """
        Replaces Keywords inside the given String with defined Constants
        """
        out = inputString

        for _ in range(10):
            for (key, val) in self.getAll().items():
                prev = out
                new = re.sub(rf'\b{key}\b', val, out)

                if(prev != new and debug):
                    print(key, "substituded with", val)
                out = new

        return out

    def findInDict(self, inputString: str):
        """
        Checks if given inputString is a value in Constants, then returns the key
        """
        return " | ".join(
            key for (key, val) in self.getAll().items() if (val == inputString)
        )
