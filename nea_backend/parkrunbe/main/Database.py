import Locked as Locked
import sqlite3
import django
import os
import sys

sys.path.append('/Users/rexwb/Academic/Computing/NEA/nea_backend/parkrunbe')

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "parkrunbe.settings")

#from main.models import RFID
from django.db import connection, transaction

def WriteToDB(List):

    try:

        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM main_rfid")

            for i, l in enumerate(List):
                insert_query = """
                INSERT INTO main_rfid
                (EPC, NetTime, Ranking)
                VALUES (%s, %s, %s)
                """

                Records = (List[i].GetEPC(), List[i].GetIntTime(), List[i].GetRanking())
                cursor.execute(insert_query, Records)

    except Exception:
        print(Exception)
































