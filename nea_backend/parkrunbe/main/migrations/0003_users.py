# Generated by Django 4.2.9 on 2024-01-27 15:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main', '0002_rfid_nettime'),
    ]

    operations = [
        migrations.CreateModel(
            name='Users',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('UserID_num', models.IntegerField()),
                ('Category', models.CharField(max_length=100)),
                ('Email', models.CharField(max_length=100)),
                ('Weight', models.IntegerField()),
            ],
        ),
    ]
