import CreateRankings as CreateRankings
#import TakeRFID as TakeRFID
#import Event as Event
import TagClass as TagClass
import django
import os
import sys

#print("Current Working Directory:", os.getcwd())
#print("Python Path:", sys.path)

sys.path.append('/Users/rexwb/Academic/Computing/NEA/nea_backend/parkrunbe')

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "parkrunbe.settings")

#print('Before Django Setup')

#django.setup()

#print('After Django Setup')

# Start Event:



def Main():

    from TakeRFID import ShowCodes

    TagDictionary = {}

    while True:
        EPC = ShowCodes() # Read codes from USB

        if EPC == "KILL EVENT":
            from Event import EndEvent

            return EndEvent(TagDictionary)
        
        # While event runs, place the EPCs into the object handler function:

        from Event import TakeCode
        TagDictionary = TakeCode(EPC, TagDictionary)
            


print(Main())