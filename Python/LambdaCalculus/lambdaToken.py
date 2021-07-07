class Token:

    LAMBDA = "LAMBDA"
    DOT = "DOT"
    VAR = "VAR"
    LPAR = "LPAR"
    RPAR = "RPAR"
    SPACE = "SPACE"

    def __init__(self, type: str, varName: str = None, internalIDX=0):
        self.type = type
        self.varName = varName
        self.internalIDX = internalIDX

    def debugPrint(self):
        """
        Returns all attributes of Token
        """
        return str(self.type) + (":"+str(self.varName)+"_"+str(self.internalIDX) if self.varName is not None else "")

    def __repr__(self):
        """
        Returns VariableName
        """
        # return self.debugPrint()
        return self.varName
