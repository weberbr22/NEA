# Generated by Django 4.2.9 on 2024-01-24 16:56

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='RFID',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('EPC', models.CharField(max_length=100)),
                ('Ranking', models.IntegerField()),
            ],
        ),
    ]
