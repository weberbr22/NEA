from datetime import datetime, timedelta

class Tag:

    def __init__(self, EPC):
        self.EPC = EPC
        self.StartTime = None
        self.FinishTime = None
        self.NetTime = None
        self.Ranking = None

    def GetEPC(self):
        return self.EPC

    def SetEPC(self, Number):
        self.EPC = Number

    def GetStartTime(self):
        return self.StartTime
    
    def GetFinishTime(self):
        return self.FinishTime

    def StartRace(self):
        Time = datetime.now()
        self.StartTime = Time

    def FinishRace(self):
        Time = datetime.now()
        self.FinishTime = Time

    def GetTime(self):
        return self.NetTime
    
    def SetNetTime(self, Time):
        self.NetTime = Time

    def SetStartTime(self, Time):
        self.StartTime = Time
    
    def SetFinishTime(self, Time):
        self.FinishTime = Time

    def CalculateNet(self):
        Net = self.FinishTime - self.StartTime
        self.NetTime = Net
    
    def SetRanking(self, Position):
        self.Ranking = Position

    def GetRanking(self):
        return self.Ranking
    
    def GetIntTime(self):
        intTime = int((self.NetTime).total_seconds())
        return intTime


class DNF(Tag):

    def __init__(self, EPC):
        self.EPC = EPC
        self.NetTime = timedelta(seconds=0)
        self.Ranking = -1
        self.DNF = True