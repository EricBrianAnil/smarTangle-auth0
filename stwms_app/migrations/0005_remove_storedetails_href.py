# Generated by Django 3.0.3 on 2020-06-16 09:37

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('stwms_app', '0004_storedetails_store_name'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='storedetails',
            name='href',
        ),
    ]
