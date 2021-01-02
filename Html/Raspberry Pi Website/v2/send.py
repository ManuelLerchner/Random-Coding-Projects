from pushbullet import Pushbullet
import sys
token="o.6nPV3vqOV5NqQSRTAwayAwZqi7oIHVTL"



input=sys.argv[1]


person="Default"


if input=="192.168.0.150":
    person="Manuel"
    
elif input=="192.168.0.151" or input=="192.168.0.154":
    person="Simone"

elif input=="192.168.0.152":
    person="Irmgard"
    
elif input=="192.168.0.153":
    person="Elmar"



pb = Pushbullet(token)
dev = pb.get_device('HUAWEI EVA-L09')
push = dev.push_note("Notification", "Door just opened by: "+person +" at: " +input)
