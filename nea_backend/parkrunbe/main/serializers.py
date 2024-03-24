from rest_framework import serializers
from .models import RFID
from .models import Runners
from .models import Users

class RFIDSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = RFID
        fields = ['EPC', 'NetTime', 'Ranking']

class RunnerSerializer(serializers.HyperlinkedModelSerializer):

    

    UserID_num = serializers.PrimaryKeyRelatedField(queryset=Users.objects.all())
    EPC_num = serializers.PrimaryKeyRelatedField(queryset=RFID.objects.all())

    class Meta:
        model = Runners
        fields = '__all__'

class UserSerializer(serializers.HyperlinkedModelSerializer):

    class Meta:
        model = Users
        fields = ['UserID', 'Category', 'Email', 'Weight', 'FirstName', 'LastName', 'Password']

