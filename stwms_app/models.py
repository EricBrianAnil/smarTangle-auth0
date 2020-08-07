from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver

# Create your models here.


# class Profile(models.Model):
#     user = models.OneToOneField(User, on_delete=models.CASCADE)
#     designation = models.CharField(max_length=25)


# @receiver(post_save, sender=User)
# def create_user_profile(sender, instance, created, **kwargs):
#     if created:
#         Profile.objects.create(user=instance)
#
#
# @receiver(post_save, sender=User)
# def save_user_profile(sender, instance, **kwargs):
#     instance.profile.save()


class StoreDetails(models.Model):
    store_id = models.CharField(primary_key=True, max_length=25)
    store_name = models.CharField(max_length=25)
    storeManager = models.ForeignKey(User, on_delete=models.PROTECT)
    place_id = models.CharField(max_length=50)

    class Meta:
        verbose_name_plural = "Store Details"


class RawMaterials(models.Model):
    rawMaterial_id = models.CharField(primary_key=True, max_length=25)
    rawMaterial_name = models.CharField(unique=True, max_length=25)
    price = models.IntegerField()
    requestsFromUser = models.IntegerField()

    class Meta:
        verbose_name_plural = "Raw Material Details"


class WarehouseInventory(models.Model):
    rawMaterial_id = models.OneToOneField(RawMaterials, on_delete=models.PROTECT)
    unitsAvailable = models.BigIntegerField()

    class Meta:
        verbose_name_plural = "Warehouse Inventory"


class Suppliers(models.Model):
    supplier_id = models.CharField(primary_key=True, max_length=25)
    supplier_name = models.CharField(max_length=25)
    supplier_rating = models.FloatField()

    class Meta:
        verbose_name_plural = "Suppliers"


class RawMaterialBatches(models.Model):
    uniqueBatch_id = models.IntegerField(primary_key=True)
    rawMaterial_id = models.ForeignKey(RawMaterials, on_delete=models.PROTECT)
    units = models.IntegerField()
    supplier = models.ForeignKey(Suppliers, on_delete=models.PROTECT)

    class Meta:
        verbose_name_plural = "Raw Material Batches"


class StoreInventory(models.Model):
    rawMaterial_id = models.ForeignKey(RawMaterials, on_delete=models.PROTECT)
    storeId = models.ForeignKey(StoreDetails, on_delete=models.PROTECT)
    unitsAvailable = models.BigIntegerField()
    unitsSold = models.BigIntegerField()

    class Meta:
        verbose_name_plural = "Store Inventory"


class TransactionHistory(models.Model):
    transaction_id = models.BigAutoField(primary_key=True)
    rawMaterial_id = models.ForeignKey(RawMaterials, on_delete=models.CASCADE)
    storeId = models.ForeignKey(StoreDetails, on_delete=models.CASCADE)
    units = models.IntegerField()
    dateTime = models.DateTimeField()


# class TravelHistory(models.Model):
#     truck_id
#     batch_id
#     destStore_id