import timing

text = ""

'''
with open('../Data/bigText.txt') as inputfile:
    for line in inputfile:
        text += ''.join(map(str, line.strip().split(',')))
'''
'''
text = 'Hallo, ich heiße Manuel Lerchner und versuche gerade' \
       'einen String mithilfe der Huffman-Kodiedung zu komprimieren. ' \
       'Es sieht so aus, als ob es funktionieren würde!'
'''

text = "Fischers Fritz fischt frische Fische, Blaukraut bleibt Blaukraut, Brautkleid bleibt Brautkleid, Der Whiskymixer mixt den Whisky mit dem Whiskymixer. Mit dem Whiskymixer mixt der Whiskymixer den Whisky."


#####################################Root################################################################################
class Root:
    def __init__(self, **kwargs):
        self.letter = kwargs.get('letter')
        self.count = kwargs.get('count')
        self.childA = kwargs.get('childA')
        self.childB = kwargs.get('childB')

    # connect 2 nodes width a new one
    def join(self, otherRoot):
        New = Root(count=self.count + otherRoot.count)
        if self.count > otherRoot.count:
            New.childA = self
            New.childB = otherRoot
        else:
            New.childA = otherRoot
            New.childB = self
        New.childA.parent = New.childB.parent = New
        Roots.append(New)
        Roots.remove(otherRoot)
        Roots.remove(self)

    ###get Letter adress###
    def traverseUp(self, startRoot):
        outString = ""
        parent = startRoot
        while hasattr(parent, "parent"):
            current, parent = parent, parent.parent
            if parent.childA == current:
                outString += "1"
            elif parent.childB == current:
                outString += "0"
        return outString[::-1]

    ###encode String###
    def getEncoding(self):
        if self.childA:
            self.childA.getEncoding()
        if self.letter:
            Encoding[self.letter] = self.traverseUp(self)
        if self.childB:
            self.childB.getEncoding()

    ### decode String##
    def decode(self, input):
        returnString = ""
        count = 0
        while count < len(input):
            next = Roots[0]
            while next.letter == None:
                currChar = input[count]
                if next.childA and currChar == "1":
                    next = next.childA
                if next.childB and currChar == "0":
                    next = next.childB
                count += 1
            returnString += next.letter
        return returnString

    ##accses Value manually###
    def findValue(self, input):
        next = Roots[0]
        for k in range(len(input)):
            currChar = input[k]
            if next.childA and currChar == "1":
                next = next.childA
            elif next.childB and currChar == "0":
                next = next.childB
            else:
                return "Error"
        return next.letter


#####################################Setup Roots########################################################################
Roots = []
for chr in list(set(text)):
    countVar = text.count(chr)
    Roots.append(Root(letter=chr, count=countVar))

if len(Roots) == 1:
    Roots.append(Root(letter='', count=0))


### sort Roots###
def byCount(elem):
    return elem.count


###Joing Roots####
while True:
    try:
        Roots.sort(key=byCount)
        Roots[0].join(Roots[1])
    except:
        break

Huffman = Roots[0]

###################Get Encoding##############################
Encoding = {}
Huffman.getEncoding()
compressedData = "".join([Encoding.get(c) for c in text])

###Print####
print("\nEncoding:")
for d, v in sorted(Encoding.items(), key=lambda item: (text.count(str(item[0]))), reverse=True):
    print(str(text.count(d)) + "['" + str(d) +
          "':" + str(Encoding.get(d)) + "]  ", end='')


####Bits needet####
def lenOfText(input, **kwargs):
    stringLen = len(input.encode("utf8"))
    if kwargs.get("char"):
        return stringLen * 8
    else:
        return stringLen


lenCompressed = lenOfText(compressedData)
lenOriginal = lenOfText(text, char=True)

print("\n\nCompressed:  ", Huffman.decode(compressedData))
print("Original:    ", text)
print("\n\nCompressed to:", str(round(lenCompressed / lenOriginal * 100, 3)
                                ) + "%  Comp/Orig : ", lenCompressed, "/", lenOriginal)
