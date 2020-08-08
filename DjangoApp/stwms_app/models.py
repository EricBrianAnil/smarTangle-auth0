from django.db import models
from django.contrib.auth.models import User


class StoreDetails(models.Model):
    store_id = models.CharField(primary_key=True, max_length=25)
    store_name = models.CharField(max_length=25)
    storeManager = models.ForeignKey(User, on_delete=models.PROTECT)
    place_id = models.CharField(max_length=50)

    def __str__(self):
        return self.store_name

    class Meta:
        verbose_name_plural = "Store Details"


class RawMaterials(models.Model):
    rawMaterial_id = models.CharField(primary_key=True, max_length=25)
    rawMaterial_name = models.CharField(unique=True, max_length=25)
    price = models.IntegerField()
    requestsFromUser = models.IntegerField()

    def __str__(self):
        return self.rawMaterial_name + ' ' + self.rawMaterial_id

    class Meta:
        verbose_name_plural = "Raw Material Details"
        ordering = ['rawMaterial_id']


class Suppliers(models.Model):
    supplier_id = models.CharField(primary_key=True, max_length=25)
    supplier_name = models.CharField(max_length=25)
    supplier_rating = models.FloatField()

    class Meta:
        verbose_name_plural = "Suppliers"


class RawMaterialBatches(models.Model):
    uniqueBatch_id = models.AutoField(primary_key=True)
    rawMaterial_id = models.ForeignKey(RawMaterials, on_delete=models.PROTECT)
    units = models.IntegerField()
    supplier = models.ForeignKey(Suppliers, on_delete=models.PROTECT)
    quality_score = models.FloatField()
    calories = models.FloatField()
    proteins = models.FloatField()
    fat = models.FloatField()
    sodium = models.FloatField()
    dateTime = models.DateTimeField(auto_now_add=True)
    hash = models.CharField(max_length=100)

    class Meta:
        verbose_name_plural = "Raw Material Batches"


class StoreInventory(models.Model):
    rawMaterial_id = models.ForeignKey(RawMaterials, on_delete=models.PROTECT)
    storeId = models.ForeignKey(StoreDetails, on_delete=models.PROTECT)
    unitsAvailable = models.BigIntegerField()
    unitsSold = models.BigIntegerField()

    def __str__(self):
        return self.storeId.store_id + ': ' + self.rawMaterial_id.rawMaterial_name

    class Meta:
        verbose_name_plural = "Inventory"
        ordering = ['storeId', 'rawMaterial_id']


class TransactionHistory(models.Model):
    transaction_id = models.BigAutoField(primary_key=True)
    rawMaterial_id = models.ForeignKey(RawMaterials, on_delete=models.CASCADE)
    storeId = models.ForeignKey(StoreDetails, on_delete=models.CASCADE)
    units = models.IntegerField()
    dateTime = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = "Transaction History"


class TruckDetails(models.Model):
    truck_id = models.CharField(max_length=10, primary_key=True)
    truck_owner = models.CharField(max_length=25)

    class Meta:
        verbose_name_plural = "Truck Details"


class TravelHistory(models.Model):
    truck_id = models.ForeignKey(TruckDetails, on_delete=models.PROTECT)
    toStore_id = models.ForeignKey(StoreDetails, on_delete=models.CASCADE, related_name='travelToStore')
    fromStore_id = models.ForeignKey(StoreDetails, on_delete=models.CASCADE, related_name='travelFromStore')

    class Meta:
        verbose_name_plural = "Travel History"


class RawMaterialRequest(models.Model):
    request_id = models.AutoField(primary_key=True)
    store_id = models.ForeignKey(StoreDetails, on_delete=models.CASCADE, related_name='requestedStore')
    rawMaterial_id = models.ForeignKey(RawMaterials, on_delete=models.CASCADE)
    fromStore_id = models.ForeignKey(StoreDetails, on_delete=models.CASCADE, related_name='fromStore')
    units = models.IntegerField()
    status = models.CharField(max_length=10)
    truck = models.ForeignKey(TruckDetails, blank=True, null=True, on_delete=models.PROTECT)

    class Meta:
        verbose_name_plural = "Raw Materials Requests"
