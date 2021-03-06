# Generated by Django 3.0.3 on 2020-06-24 05:24

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('stwms_app', '0025_remove_rawmaterialrequest_truck'),
    ]

    operations = [
        migrations.AddField(
            model_name='rawmaterialrequest',
            name='status',
            field=models.CharField(default='Pending', max_length=10),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='rawmaterialrequest',
            name='truck',
            field=models.ForeignKey(blank=True, default='T01', on_delete=django.db.models.deletion.PROTECT, to='stwms_app.TruckDetails'),
            preserve_default=False,
        ),
    ]
