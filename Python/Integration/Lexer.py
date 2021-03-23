
import Token


class Lexer:

    def __init__(self, expression):
        self.expression = expression

    def evaluate(self):

        Tokens=Token.tokify(self.expression)

        print(Tokens)
