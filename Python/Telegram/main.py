from requests.api import request
import telegram
import requests


text = """
Der Oberschenkelknochen (lat. Femur) gehört zu den stabilsten Knochen des menschlichen Körpers. Dennoch kann es auch im Bereich dieses Knochens zu Frakturen (sogenannter Oberschenkelbruch) kommen.

Bei älteren Patienten lassen sich Frakturen des Oberschenkels wesentlich häufiger beobachten als bei jungen Menschen. Diese Tatsache ist vor allem darin zu begründen, dass während des Alterns strukturelle Veränderungen im Bereich der Knochenstruktur beobachten kann.
Auf Grund dieser Veränderungen kann die Belastbarkeit des Oberschenkelknochens stark beeinflusst werden. Oberschenkelbrüche werden wahrscheinlicher.
In den meisten Fällen muss ein Oberschenkelbruch operativ korrigiert werden.
Zu den häufigsten Formen des Oberschenkelbruchs gehört der sogenannte Oberschenkelhalsbruch. Eine Fraktur des Knochens kann jedoch häufig auch im Bereich des Oberschenkelschaftes beobachtet werden.
Des Weiteren treten Frakturen des Oberschenkels oftmals direkt am oder in der Nähe des Hüftgelenkes auf. Auch die kniegelenksnahen Knochenanteile können bei Unfällen stark beschädigt werden und einen Bruch aufweisen.

Ursachen
In den meisten Fällen beruht die Ursache des Oberschenkelbruchs auf einer zu großen mechanischen Belastung.
Meistens wird diese Überbelastung durch eine starke Vorschädigung der Knochensubstanz verstärkt.
Vor allem für Patienten die unter ausgeprägten osteoporotischen Veränderungen leiden besteht ein erhöhtes Risiko einen Oberschenkelbruch zu erleiden.
Je stärker die Veränderungen der Knochensubstanz, desto weniger Belastung kann diese aushalten, desto schneller kann es zu einer Fraktur kommen.
Bei ausgeprägten Fällen genügen deshalb schon relativ geringe Gewalteinwirkungen um einen Oberschenkelbruch zu provozieren.
Die häufigste Ursache für die Entstehung eines Oberschenkelbruchs im Bereich des Hüftkopfes sind sogenannte Rotationstraumata oder einfache Verrenkungen.
Der Oberschenkelbruch des Schenkelhalses, also der Verbindung zwischen Hüftkopf und Oberschenkelschaft, bricht in den meisten Fällen bei Stürzen.
Gerade Patienten die direkt auf die seitliche Hüfte oder auf das gestreckte Bein fallen erleiden oftmals eine Fraktur des Oberschenkelhalses.
Diese Form des Oberschenkelbruchs betrifft vor allem ältere Menschen deren Knochensubstanz durch osteoporotische Veränderungen bereits sehr instabil geworden ist. Frakturen im Bereich des Schaftes lassen sich in der Hauptzahl der Fälle auf starke Gewalteinwirkungen zurückführen.

Aus diesem Grund gehören Unfälle zu den häufigsten Ursachen des Oberschenkelbruchs am Knochenschaft. Oftmals tritt diese Form der Fraktur zusammen mit Verletzungen anderer Strukturen auf (Polytrauma).
Der Oberschenkelbruch der unteren, kniegelenksnahen Knochenabschnitte wird zumeist durch einen Autounfall verursacht. Klassisch für diese Form der Fraktur ist das Aufprallen der Kniegelenke gegen das Armaturenbrett.
"""

tok = "1712090935:AAHOBBtCtxWUwKNNQqzcuzRJcbVWweX6Anc"

chat_id = "971630322"

bot = telegram.Bot(token=tok)
print(bot)

list = text.split(' ')
for i in range(10000):
    msg = "You have been fucking hacked m8"
    url = f"https://api.telegram.org/bot{tok}/sendMessage?chat_id={chat_id}&text={list[i]+' '}"
    res = requests.get(url)

    print(res)
