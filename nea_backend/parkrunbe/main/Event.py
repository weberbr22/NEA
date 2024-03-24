from datetime import datetime
import CreateRankings as CreateRankings
import TagClass as TagClass
import Database as Database

def StartTag(EPC, TagDictionary):
    # Create new key-value pair:
    from TagClass import Tag
    TagInstance = Tag(EPC)
    TagInstance.StartRace()
    TagDictionary.update({EPC : TagInstance})
    return TagDictionary

def FinishTag(EPC, TagDictionary):
    # Update old Tag Object:
    TagInstance = TagDictionary[EPC]
    TagInstance.FinishRace()
    return TagDictionary

def TakeCode(EPC, TagDictionary):
    # Create Tag Objects using functions and place into Dictionary:
    if EPC in TagDictionary:
        FinishTag(EPC, TagDictionary)
    else:
        StartTag(EPC, TagDictionary)
    return TagDictionary

def EndEvent(TagDictionary):
    UnsortedTags = []
    DNFTags = []
    for key in TagDictionary:
        if TagDictionary[key].GetStartTime() is not None and TagDictionary[key].GetFinishTime() is not None:
            # This is a completed tag so is added to the list
            UnsortedTags.append(TagDictionary[key])
        elif TagDictionary[key].GetStartTime() is not None and TagDictionary[key].GetFinishTime() == None:
            # This is a DNF, so produce a DNF instance and add to another list
            DNFInstance = TagClass.DNF(key)
            DNFTags.append(DNFInstance)

    from CreateRankings import MergeSort

    SortedTags = MergeSort(UnsortedTags)
    SortedTags = SortedTags + DNFTags

    from Database import WriteToDB
    WriteToDB(SortedTags)
    
    return SortedTags