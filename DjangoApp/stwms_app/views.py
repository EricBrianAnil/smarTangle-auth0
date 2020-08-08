from django.db.models import QuerySet
from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import login
from django.contrib.auth.decorators import login_required
from rest_framework import viewsets, generics
from rest_framework.permissions import AllowAny
from .serializers import UserSerializer
from .forms import SignUpForm
from .models import StoreDetails, StoreInventory, RawMaterials, TransactionHistory, RawMaterialRequest

# InFluxDb
from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS

token = "NCAxa9xp-pPyTDYnCrkKowLETS_RSKY2gsTajAh9GKDmMv9NOTQPyYa6DsuBHEMGgeMDm6mUy9qBK5bUDKuiLQ=="
org = "1faff460d4557f87"
bucket = "05dd07784fa8d000"
client = InfluxDBClient(url="https://us-central1-1.gcp.cloud2.influxdata.com", token=token)
write_api = client.write_api(write_options=SYNCHRONOUS)

# Hornet Tangle
from iota import Iota, ProposedTransaction, Address, TryteString

api = Iota('https://nodes.devnet.iota.org:443', testnet=True)
address = "ZLGVEQ9JUZZWCZXLWVNTHBDX9G9KZTJP9VEERIIFHY9SIQKYBVAHIMLHXPQVE9IXFDDXNHQINXJDRPFDXNYVAPLZAW"

# Create your views here.


@login_required
def home(request):
    return render(request, 'home.html')


def sign_up(request):
    context_signup = {}
    form = SignUpForm(request.POST or None)
    if request.method == "POST":
        if form.is_valid():
            user = form.save()
            login(request, user)
            return render(request, 'home.html')
    context_signup['form'] = form
    return render(request, 'registration/sign_up.html', context_signup)


def index(request):
    return render(request, 'index.html')


@login_required
def stores(request):
    stores_data = StoreDetails.objects.exclude(store_id='W')
    context_stores = {'stores': stores_data, 'storesLen': len(stores_data)}
    return render(request, 'stores.html', context_stores)


@login_required
def store_details(request):
    if request.method == "POST":
        store_id = request.POST['store_id']
        raw_material_id = request.POST['rawMaterial_id']
        units = int(request.POST['units'])
        item = StoreInventory.objects.get(rawMaterial_id=raw_material_id, storeId=store_id)
        item_sold = units
        item.unitsAvailable = item.unitsAvailable - item_sold
        item.unitsSold = item.unitsSold + item_sold
        item.save()

        data = "%s,store=%s units=%s" % (
            RawMaterials.objects.get(rawMaterial_id=raw_material_id).rawMaterial_name,
            store_id,
            str(units)
        )
        write_api.write(bucket, org, data)

        message = TryteString.from_unicode(data)
        tx = ProposedTransaction(
            address=Address(address),
            message=message,
            value=0
        )
        result = api.send_transfer(transfers=[tx])
        hashValue = result['bundle'].tail_transaction.hash

        transaction = TransactionHistory(
            storeId=StoreDetails.objects.get(store_id=store_id),
            rawMaterial_id=RawMaterials.objects.get(rawMaterial_id=raw_material_id),
            units=units,
            hash=hashValue
        )
        transaction.save()
    else:
        store_id = request.GET['store_id']

    items_data = StoreInventory.objects.filter(storeId=store_id)
    store_data = StoreDetails.objects.get(store_id=store_id)
    context = {'items': items_data, 'store': store_data, 'shopMenu': store_data.storeManager == request.user}
    return render(request, 'storeDetails.html', context)


@login_required
def rawmaterial_request(request):
    if request.method == "GET":
        store_id = request.GET['store_id']
        store = StoreDetails.objects.get(store_id=store_id)
        stores_list = StoreDetails.objects.exclude(store_id=store_id)
        raw_material = RawMaterials.objects.get(rawMaterial_id=request.GET['rawMaterial_id'])
        items_data = StoreInventory.objects.exclude(storeId=store_id)
        context = {'store': store, 'rawMaterial': raw_material, 'items': items_data, 'stores': stores_list, 'shopMenu': store.storeManager == request.user}
        return render(request, 'rawmaterial_request.html', context)
    elif request.method == "POST":
        store_id = request.POST['store_id']
        raw_material_id = request.POST['rawMaterial_id']
        from_store_id = request.POST['from_store_id']
        units = request.POST['units']
        request = RawMaterialRequest(
            store_id=StoreDetails.objects.get(store_id=store_id),
            rawMaterial_id=RawMaterials.objects.get(rawMaterial_id=raw_material_id),
            fromStore_id=from_store_id,
            units=units
        )
        request.save()
        return render(request, 'request_success.html')


@login_required
def w_manage(request):
    if request.user.username == 'admin_ibm':
        stores_list = StoreDetails.objects.all()
        context = {
            'warehouseItems': StoreInventory.objects.filter(storeId='W'),
            'storeItems': StoreInventory.objects.exclude(storeId='W'),
            'store': StoreDetails.objects.get(store_id='W'),
        }
        return render(request, 'warehouseManagement.html', context)



class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer


class UserCreateAPIView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = (AllowAny,)
