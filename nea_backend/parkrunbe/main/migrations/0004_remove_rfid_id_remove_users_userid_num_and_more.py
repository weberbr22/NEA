# Generated by Django 4.2.9 on 2024-01-27 16:28

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('main', '0003_users'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='rfid',
            name='id',
        ),
        migrations.RemoveField(
            model_name='users',
            name='UserID_num',
        ),
        migrations.RemoveField(
            model_name='users',
            name='id',
        ),
        migrations.AddField(
            model_name='users',
            name='UserID',
            field=models.IntegerField(default=0, primary_key=True, serialize=False),
        ),
        migrations.AlterField(
            model_name='rfid',
            name='EPC',
            field=models.CharField(max_length=100, primary_key=True, serialize=False),
        ),
        migrations.CreateModel(
            name='Runners',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('EPC_num', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='main.rfid')),
                ('UserID_num', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='main.users')),
            ],
        ),
    ]
