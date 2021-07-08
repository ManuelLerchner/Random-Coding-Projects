from colorama import Fore

from lambdaToken import Token
from utility import printColor


class Lexer:

    def __init__(self):
        self.tokens = []
        self.idx = 0
        self.str = None

    def analyze(self, inputString: str):
        """
        Splits Input String into Tokens and appends them to the Tokens-Array
        """

        self.str = inputString.strip()

        printColor("\nTrying to evaluate Input:", Fore.YELLOW)
        printColor("'"+self.str+"'", Fore.GREEN, end="\n\n")

        if self.str == "":
            self.throwError(
                f"Found an empty Input String", 0, "Tokens")
        prevChar = None

        for chr in self.str:
            if chr == " ":
                self.tokens.append(Token(Token.SPACE))

            elif chr == "λ":
                self.tokens.append(Token(Token.LAMBDA))

            elif chr == ".":
                self.tokens.append(Token(Token.DOT))

            elif chr == "(":
                self.tokens.append(Token(Token.LPAR))

            elif chr == ")":
                self.tokens.append(Token(Token.RPAR))

            elif chr.isalpha() or chr.isnumeric():
                if self.tokens[-1].type == Token.VAR:
                    self.throwError(
                        "Probably encounterd an invalid Keyword", inputString.find(chr), "Tokens")
                self.tokens.append(Token(Token.VAR, str(chr)))

            else:
                self.throwError(
                    f"Encountered invalid Character: '{chr}'", inputString.find(chr), "Creating Tokens")

    def throwError(self, errorMsg, errorIdx, context):
        """
        Throws a custom Error-Message and Points to the part of the Input String where the error occurred
        """
        printColor("\n"+errorMsg + " while creating '" +
                   context+"'", Fore.YELLOW)

        printColor(' '*errorIdx+'↓', Fore.GREEN)
        printColor(self.str, Fore.RED)
        printColor(' '*errorIdx+'↑\n', Fore.GREEN)

        exit()

    def checkNext(self, reqType, context):
        """
        Checks if there still exists a Token and wheter it matches the required type.
        """
        if self.idx >= len(self.tokens):
            self.throwError(
                f"Parsing failed: Index out of Bounds", self.idx, context)

        if self.tokens[self.idx].type != reqType:
            self.throwError(
                f"Expected {reqType}, got {self.tokens[self.idx].type}", self.idx, context)

    def skipToken(self, reqType, context):
        """
        Checks if there still exists a Token of given type and then skips it
        """
        self.checkNext(reqType, context)
        self.idx += 1

    def nextToken(self, reqType, context):
        """
        Checks if the next Token is of given type and then returns it
        """
        self.checkNext(reqType, context)
        tok = self.tokens[self.idx]
        self.idx += 1
        return tok

    def peekToken(self, reqType, context):
        """
        Peeks at next token and checks if meets the required type
        !!Doesnt throw an error if comparison fails!!
        """
        if self.idx >= len(self.tokens):
            self.throwError(
                f"No more Token available", self.idx, context)

        return self.tokens[self.idx].type == reqType

    def finished(self):
        """
        Checks if all of the Tokens have been parsed
        """
        return self.idx == len(self.tokens)
