import random

text = """ Das Ostern der leeren Kirchen Eine eigenartige und auch beklemmende Stille füllte beim heurigen Osterfest unsere Kirchen. Kein
festlicher Gesang, keine gemeinsamen Gottesdienste, kein Leben im Dorf und auf den Straßen.
Man tat sich schwer, etwas von der Osterfreude zu
spüren. Zu groß waren die Veränderungen der letzten Zeit, zu sehr musste auf viel lieb Gewonnenes
verzichtet werden. Die Gottesdienste waren, und
das hat uns diese Krise wieder einmal bewusst gemacht, für die Dorfgemeinschaft ein wichtiger wöchentlicher Bezugspunkt, um den Glauben zu feiern, sich aber auch zu treffen und auszutauschen.
Wann wieder die Normalität eintritt, das weiß wohl
keiner von uns. Trotzdem möchte ich mich auf diesem Weg ganz herzlich bei all jenen bedanken,
die während dieser Zeit weiterhin ihren Aufgaben
in der Kirche und bei den Gottesdiensten, die ich
gefeiert habe, nachgekommen sind und mich als
Pfarrer unterstützt haben. Unsere Kirchen waren
auch ohne öffentliche Gottesdienste sauber und
geschmückt. Ebenso bei den Verabschiedungen
unserer Verstorbenen im Friedhof waren helfende
Hände zur Stelle. Das Schifflein der Kirche wird zurzeit von den Wellen dieser Ereignisse hin - und hergeworfen. Aber Christus, der Herr, sitzt mit uns im
Boot und er ist der Steuermann. Bitten wir darum,
dass wir wieder den schützenden Hafen der Normalität anlaufen können. Lassen wir uns aber auch
in dieser Zeit der zunehmenden menschlichen Distanz nicht davon abhalten, weiterhin zusammenzuhalten und Gemeinschaft zu pflegen, in welcher Art
auch immer.
Pfarrer Michael
D"""

words=text.split(' ')

res=""


for i in range(0,200):
    res+= words[random.randrange(len(words))].strip("\n")+" "


print(res)

