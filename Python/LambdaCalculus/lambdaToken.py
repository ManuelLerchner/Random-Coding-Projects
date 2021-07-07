class Token:

    LAMBDA = "LAMBDA"
    DOT = "DOT"
    VAR = "VAR"
    LPAR = "LPAR"
    RPAR = "RPAR"
    SPACE = "SPACE"

    def __init__(self, type: str, value: str = None):
        self.type = type
        self.value = value

    def __repr__(self):
        return str(self.type) + (":"+str(self.value) if self.value is not None else "")
