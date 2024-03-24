from django.shortcuts import render
from rest_framework import viewsets
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
import json

from .models import RFID
from .serializers import RFIDSerializer
from django.http import HttpResponse
from parkrunbe import urls

from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework.parsers import JSONParser

from django.db import connection, transaction

from .serializers import RunnerSerializer
from .models import Runners
from .models import Users
from .serializers import UserSerializer

import logging

logger = logging.getLogger('django')

class RFIDview(viewsets.ModelViewSet):
    queryset = RFID.objects.all().order_by('EPC') 
    serializer_class = RFIDSerializer
    
class RunnerView(viewsets.ModelViewSet):
    queryset = Runners.objects.all().order_by('UserID_num')
    serializer_class = RunnerSerializer

    def CreateRecords(self, requestdata):

        # Parse the JSON
        runner_epc = requestdata["EPC_num"]
        runner_id = requestdata["UserID_num"]

        try:

            with connection.cursor() as cursor:

                # Records from RFID
                cursor.execute("""SELECT main_rfid.Ranking, main_rfid.NetTime
                    FROM main_rfid
                    INNER JOIN main_runners ON main_rfid.EPC = main_runners.EPC_num_id 
                    WHERE main_runners.EPC_num_id= %s"""
                    , (runner_epc,))
    
                rfidrecords = cursor.fetchall()
                Ranking, NetTime = rfidrecords[0]
    
                # Records from Users
                cursor.execute("""SELECT main_users.Category, main_users.Weight
                    FROM main_users
                    INNER JOIN main_runners ON main_users.UserID = main_runners.UserID_num_id 
                    WHERE main_runners.UserID_num_id = %s"""
                    , (int(runner_id),))
    
                userrecords = cursor.fetchall()
                Category, Weight = userrecords[0]

                # Number of runners
                cursor.execute("""SELECT COUNT(*) FROM main_rfid""")

                racecountrecords = cursor.fetchall()
                RaceCount = racecountrecords[0][0]

        except Exception:
                print(Exception)
                Ranking = -1
                NetTime = 0
                Category = "NA"
                Weight = 0
                RaceCount = 0

        # Create JSON based on the output
        response_data = {
            'Ranking': Ranking,
            'NetTime': NetTime,
            'Category': Category,
            'Weight': Weight,
            'RaceCount': RaceCount,
        }

        return response_data


    def create(self, request, *args, **kwargs):

        # Override the standard functionality:
        response = super().create(request, *args, **kwargs)
        
        # Put the default_data into a variable that won't be used:
        default_data = response.data

        # Create custom response data:
        custom_data = self.CreateRecords(request.data)

        # Create JSON:
        data = {
            'data': custom_data,
        }

        return Response(data, status=status.HTTP_201_CREATED)

class UserView(viewsets.ModelViewSet):
    queryset = Users.objects.all().order_by('UserID')
    serializer_class = UserSerializer