from django.test import TestCase
import unittest
import TagClass
import time
import Event
from datetime import datetime, timedelta
import CreateRankings


# Create your tests here.

TestDictionary = {}

class RFIDtest (unittest.TestCase):

    def testCalculateNet(self):
        from TagClass import Tag
        x = Tag("ABCDE")
        x.StartRace()
        time.sleep(5) # This shall make NetTime = 5
        x.FinishRace()
        x.CalculateNet()

        self.assertEqual(x.GetIntTime(), 5, 'The Time is wrong')

    def testTakeCode(self):
        TagDictionary = {}
        from Event import TakeCode
        from TagClass import Tag

        myDateTime = datetime.now() # Take the time

        TakeCode("ABCDE", TagDictionary) # The start time of this object should be the same as above

        for key, value in TagDictionary.items():
            EPC = key
            TagInstance = value


        self.assertEqual(EPC, "ABCDE")
        self.assertIsInstance(TagInstance, Tag)
        # As there is some microsecond latency in the code, set microseconds to 0:
        self.assertEqual(myDateTime.replace(microsecond=0), TagInstance.GetStartTime().replace(microsecond=0))

    def testDictionary(self):
        TagDictionary = {}
        from Event import EndEvent
        from Event import TakeCode

        TakeCode("ABCDE", TagDictionary)
        TakeCode("ABCDE", TagDictionary) # This is complete
        TakeCode("FGHIJ", TagDictionary) # This isn't complete and thus a DNF

        outputlist = EndEvent(TagDictionary)
        FirstObject = outputlist[0]
        SecondObject = outputlist[1]

        self.assertIsInstance(FirstObject, TagClass.Tag)
        self.assertIsInstance(SecondObject, TagClass.DNF)

    def testSort(self):
       from TagClass import Tag
       from CreateRankings import MergeSort


       FirstObject = Tag("ABCDE")
       FirstObject.SetStartTime(datetime(2024, 1, 1, 0, 0, 0))
       FirstObject.SetFinishTime(datetime(2024, 1, 1, 0, 0, 2)) # Net time of 2 seconds, first place


       SecondObject = Tag("FGHIJ")
       SecondObject.SetStartTime(datetime(2024, 1, 1, 0, 0, 0))
       SecondObject.SetFinishTime(datetime(2024, 1, 1, 0, 0, 4)) # Net time of 4 seconds, second place


       ThirdObject = Tag("KLMNO")
       ThirdObject.SetStartTime(datetime(2024, 1, 1, 0, 0, 0))
       ThirdObject.SetFinishTime(datetime(2024, 1, 1, 0, 0, 6)) # Net time of 6 seconds, third place


       outputlist = MergeSort([ThirdObject, FirstObject, SecondObject])


       self.assertEqual(outputlist[0].GetEPC(), "KLMNO") # Is the slowest first in the list?
       self.assertEqual(outputlist[1].GetEPC(), "FGHIJ")
       self.assertEqual(outputlist[2].GetEPC(), "ABCDE")


       self.assertEqual(FirstObject.GetRanking(), 1) # Does first object have ranking #1?
       self.assertEqual(SecondObject.GetRanking(), 2)
       self.assertEqual(ThirdObject.GetRanking(), 3)




if __name__ == '__main__':
    unittest.main()