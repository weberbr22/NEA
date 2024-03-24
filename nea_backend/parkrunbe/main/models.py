from django.db import models

class RFID(models.Model):
    EPC = models.CharField(max_length=100, primary_key = True)
    NetTime = models.IntegerField(default=0)
    Ranking = models.IntegerField()

    def __str__(self):
        return self.EPC
    
class Users(models.Model):
    UserID = models.IntegerField(default = 0, primary_key = True)
    Category = models.CharField(max_length=100)
    Email = models.CharField(max_length = 100)
    Weight = models.IntegerField()
    FirstName = models.CharField(max_length=100, default="John")
    LastName = models.CharField(max_length=100, default="Doe")
    Password = models.CharField(max_length=100, default="password")

    def __str__(self):
        return str(self.UserID)
    
class Runners(models.Model): # Here are the foreign keys
    UserID_num = models.ForeignKey(Users, on_delete=models.CASCADE, to_field='UserID')
    EPC_num = models.ForeignKey(RFID, on_delete=models.CASCADE, to_field='EPC')

    def __str__(self):
        return f"{self.UserID_num} - {self.EPC_num}"

