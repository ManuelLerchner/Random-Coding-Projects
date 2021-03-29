
storage = ""


def tokify(str):
    Tokens = []

    for chr in str:
        match(chr, Tokens)
    conclude(Tokens)
    return Tokens


def match(chr, Tokens):
    global storage
    switcher = {
        ")": Token.RPar,
        "(": Token.LPar,
        "+": Token.Plus,
        "-": Token.Minus,
        "*": Token.Mult,
        "/": Token.Div,
        "^": Token.Pow,
    }

    type = switcher.get(chr)
    value = None

    if type != None:

        conclude(Tokens)

        Tokens.append(Token(type, value))

    if type == None:

        if str(chr).isalpha():
            type = Token.Var
            value = chr
            Tokens.append(Token(type, value))

        else:
            storage += chr


def conclude(Tokens):
    global storage
    if storage != "":
        prevType = Token.Number
        prevValue = float(storage)
        storage = ""
        Tokens.append(Token(prevType, prevValue))


class Token:

    LPar = "LPar"
    RPar = "RPar"

    Plus = "Plus"
    Minus = "Minus"
    Mult = "Mult"
    Div = "Div"
    Pow = "Pow"

    Var = "Var"
    Number = "Number"

    def __init__(self, type, value):
        self.type = type
        self.value = value

    def __repr__(self):
        val = self.value if self.value != None else ""
        return f"{self.type}{val}"
