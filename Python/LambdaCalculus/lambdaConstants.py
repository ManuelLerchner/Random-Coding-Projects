class Constants:

    Constants = {
        "TRUE": "λa.λb.a",
        "FALSE": "λa.λb.b",
        "ZERO": "λf.λx.x",
        "ONE": "λf.λx.(f x)",
        "TWO": "λf.λx.(f (f x))",
        "THREE": "λf.λx.(f (f (f x)))",
        "FOUR": "λf.λx.(f (f (f (f x))))",
    }

    Operations = {
        "I": "λx.x",  # Identity
        "M": "λf.(f f)",  # Self Application
        "K": "λa.λb.a",  # First
        "KI": "λa.λb.b",  # Second
        "C": "λf.λa.λb.((f b) a)",  # Flip

        "SUCC": "λn.λf.λx.(f ((n f) x))",
        "AND": "λp.λq.((p q) p)",
        "OR": "λp.λq.((p p) q)",
        "XOR": "λp.λq.((p ((q λa.λb.b) λa.λb.a)) q)",
        "NOT": "λf.λa.λb.((f b) a)",

    }

    @staticmethod
    def getAll():
        """
        Returns a Dict containing all defined Constants
        """
        return {**Constants.Constants, **Constants.Operations}
