# Generated by Django 3.0.3 on 2020-06-23 15:04

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('stwms_app', '0017_auto_20200623_1546'),
    ]

    operations = [
        migrations.AlterField(
            model_name='rawmaterialbatches',
            name='uniqueBatch_id',
            field=models.AutoField(primary_key=True, serialize=False),
        ),
    ]
