from lambdaToken import Token
from colorama import Fore, Style


class Lexer:

    def __init__(self, str):
        self.str = str.strip()
        self.tokens = []
        self.idx = 0
        self.parse(self.str)

    def parse(self, str):
        """
        Splits Input String into Tokens and appends them to the Tokens-Array
        """
        for chr in str:
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

            elif chr.isalpha():
                self.tokens.append(Token(Token.VAR, chr))

            else:
                self.throwError(
                    f"Encountered invalid Character: '{chr}'", str.find(chr))

    def throwError(self, errorMsg, errorIdx, context):
        """
        Throws a custom Error-Message and Points to the part of the Input String where the error occurred
        """
        print(f"\n{Fore.YELLOW}{errorMsg} while creating '{context}'{Style.RESET_ALL}")

        print(f"{Fore.GREEN}{' '*errorIdx+'↓'}{Style.RESET_ALL}")
        print(f"{Fore.RED}{self.str}  {Style.RESET_ALL}")
        print(f"{Fore.GREEN}{' '*errorIdx+'↑'}{Style.RESET_ALL}\n")

        exit(errorMsg)

    def checkNext(self, reqType,context):
        """
        Checks if there still exists a Token and wheter it matches the required type.
        """
        if not(self.idx < len(self.tokens)):
            self.throwError(
                f"Parsing failed: Index out of Bounds", self.idx, context)

        if not (self.tokens[self.idx].type == reqType):
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

    def peekToken(self, reqType):
        """
        Peeks at next token and checks if meets the required type
        !!Doesnt throw an error if comparison fails!!
        """
        return self.tokens[self.idx].type == reqType

    def finished(self):
        """
        Checks if all of the Tokens have been parsed
        """
        return self.idx == len(self.tokens)
