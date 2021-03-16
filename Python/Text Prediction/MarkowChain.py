
import random
import pprint
pp = pprint.PrettyPrinter(indent=4)


class MarkowChain:

    def __init__(self, order):
        self.order = order
        self.model = {}
        self.latestText = ""

    def analyze(self, text):
        self.latestText = text

        for i in range(0, len(text)-self.order):
            fragment = text[i:i+self.order]
            nextLetter = text[i+self.order]

            if fragment not in self.model:
                self.model[fragment] = {}

            if nextLetter not in self.model[fragment]:
                self.model[fragment][nextLetter] = 1
            else:
                self.model[fragment][nextLetter] += 1
        pp.pprint(self.model)

    def getNextCharacter(self, fragment):
        letters = []
        try:
            for chr in self.model[fragment].keys():
                for _ in range(self.model[fragment][chr]):
                    letters.append(chr)
        except KeyError as E:
            key, val = random.choice(list(self.model.items()))
            print(f"Got stuck, inserted '{key}'")
            return key

        return random.choice(letters)

    def generateText(self, length):
        currFragment = self.latestText[0:self.order]

        output = currFragment
        for _ in range(length-self.order):
            newChr = self.getNextCharacter(currFragment)
            output += newChr
            currFragment = output[-self.order:]

        return output


text = ""
with open("text.txt", "r") as file:
    for line in file:
        line = line.strip("\n")
        text += line


MC = MarkowChain(5)


MC.analyze(text)

text = MC.generateText(500)

print(text)
