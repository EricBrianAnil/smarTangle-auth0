from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import login
from django.contrib.auth.decorators import login_required
from django.contrib.admin.models import LogEntry
from django.conf import settings
from rest_framework import viewsets, generics, filters
from rest_framework.permissions import AllowAny
from joblib import load
from .serializers import UserSerializer, MaterialAvailability
from .forms import SignUpForm
from .models import StoreDetails, StoreInventory, RawMaterials, TransactionHistory, RawMaterialRequest, Suppliers, \
    RawMaterialBatches, TruckDetails, TravelHistory
from .MLmodels import TimeSeriesModel as tsModel

# Firebase
from firebase_admin import credentials, firestore, initialize_app

# InFluxDb
from influxdb_client import InfluxDBClient
from influxdb_client.client.write_api import SYNCHRONOUS
from iota import Iota, ProposedTransaction, Address, TryteString

token = "NCAxa9xp-pPyTDYnCrkKowLETS_RSKY2gsTajAh9GKDmMv9NOTQPyYa6DsuBHEMGgeMDm6mUy9qBK5bUDKuiLQ=="
org = "1faff460d4557f87"
bucket = "05dd07784fa8d000"
client = InfluxDBClient(url="https://us-central1-1.gcp.cloud2.influxdata.com", token=token)
write_api = client.write_api(write_options=SYNCHRONOUS)

# Hornet Tangle
api = Iota('https://nodes.comnet.thetangle.org/')
address = "ZLGVEQ9JUZZWCZXLWVNTHBDX9G9KZTJP9VEERIIFHY9SIQKYBVAHIMLHXPQVE9IXFDDXNHQINXJDRPFDXNYVAPLZAW"

cred = credentials.Certificate('static/files/smartangle-firebase.json')
try:
    initialize_app(cred)
except ValueError:
    pass


# Create your views here.


def handler404(request, exception=None):
    response = render(request, "404.html")
    response.status_code = 404
    return response



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


# TODO: Add Sales Graph
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

        data = "%s,store=%s units=%s" % (
            RawMaterials.objects.get(rawMaterial_id=raw_material_id).rawMaterial_name,
            store_id,
            str(units)
        )

        transaction = TransactionHistory(
            storeId=StoreDetails.objects.get(store_id=store_id),
            rawMaterial_id=RawMaterials.objects.get(rawMaterial_id=raw_material_id),
            units=units
        )
        write_api.write(bucket, org, data)
        item.save()
        transaction.save()
    else:
        store_id = request.GET['store_id']

    transactions = TransactionHistory.objects.filter(storeId=store_id)
    items_data = StoreInventory.objects.filter(storeId=store_id)
    store_data = StoreDetails.objects.get(store_id=store_id)
    itemsList = [i.rawMaterial_id.rawMaterial_name for i in items_data]
    context = {
        'items': items_data,
        'store': store_data,
        'shopMenu': store_data.storeManager.email == request.user.email,
        'itemsList': itemsList,
        'backButton': True,
        'backButtonLink': 'stores',
        'transactions': transactions
    }
    return render(request, 'storeDetails.html', context)


@login_required
def rawmaterial_request(request):
    if request.method == "GET":
        store_id = request.GET['store_id']
        context = {
            'store': StoreDetails.objects.get(store_id=store_id),
            # 'rawMaterial': RawMaterials.objects.get(rawMaterial_id=request.GET['rawMaterial_id']),
            'items': StoreInventory.objects.exclude(storeId=store_id),
            'stores': StoreDetails.objects.exclude(store_id=store_id),
            'shopMenu': StoreDetails.objects.get(store_id=store_id).storeManager.email == request.user.email,
            'rawMaterialList': RawMaterials.objects.all(),
            'backButton': True,
            'backButtonLink': 'rm_request'
        }
        return render(request, 'rawmaterial_request.html', context)
    elif request.method == "POST":
        raw_material_request = RawMaterialRequest(
            store_id=StoreDetails.objects.get(store_id=request.POST['store_id']),
            rawMaterial_id=RawMaterials.objects.get(rawMaterial_id=request.POST['rawMaterial_id']),
            fromStore_id=StoreDetails.objects.get(store_id=request.POST['from_store_id']),
            units=request.POST['units'],
            status='Pending',
        )
        raw_material_request.save()
        return render(request, 'request_success.html', {
            'requestDetails': raw_material_request,
            'backButton': True,
            'backButtonLink': 'rm_request'
        })
    else:
        return render(request, '404.html')


@login_required
def w_manage(request):
    if request.user.email == settings.ADMIN_EMAIL:
        if request.method == "POST":
            rm_request = RawMaterialRequest.objects.get(request_id=request.POST['request_id'])
            if request.POST['Action'] == 'Accepted':
                rm_request.status = 'Accepted'
                rm_request.truck_id = TruckDetails.objects.get(truck_id=request.POST['truck_id'])
                fromStore = StoreInventory.objects.get(
                    storeId=rm_request.fromStore_id,
                    rawMaterial_id=rm_request.rawMaterial_id
                )
                fromStore.unitsAvailable -= rm_request.units
                try:
                    toStore = StoreInventory.objects.get(
                        storeId=rm_request.store_id,
                        rawMaterial_id=rm_request.rawMaterial_id
                    )
                    toStore.unitsAvailable += rm_request.units
                except StoreInventory.DoesNotExist:
                    toStore = StoreInventory(
                        rawMaterial_id=rm_request.rawMaterial_id,
                        storeId=rm_request.store_id,
                        unitsSold=0,
                        unitsAvailable=rm_request.units
                    )
                travel = TravelHistory(
                    toStore_id=rm_request.store_id,
                    fromStore_id=rm_request.fromStore_id,
                    truck_id=rm_request.truck_id
                )
                fromStore.save()
                toStore.save()
                travel.save()
            else:
                rm_request.status = 'Rejected'
            rm_request.save()

        suppliers = Suppliers.objects.all()
        raw_materials = RawMaterials.objects.all()
        suppliers_data = {}
        for supplier in suppliers:
            tmp_list = []
            for raw_material in raw_materials:
                rating = 0
                batches = RawMaterialBatches.objects.filter(rawMaterial_id=raw_material, supplier_id=supplier)
                for batch in batches:
                    rating += batch.quality_score
                tmp_list.append(rating/len(batches) if len(batches) != 0 else 0)
            suppliers_data[supplier.supplier_name] = tmp_list[:]

        stackedBarGraphData = {}
        for store in StoreDetails.objects.exclude(store_id='W'):
            stackedBarGraphData[store] = [i.unitsSold for i in StoreInventory.objects.filter(storeId=store)]
        context = {
            'warehouseItems': StoreInventory.objects.filter(storeId='W'),
            'storeItems': StoreInventory.objects.exclude(storeId='W'),
            'store': StoreDetails.objects.get(store_id='W'),
            'requests': RawMaterialRequest.objects.all()[::-1],
            'inventory': StoreInventory.objects,
            'trucks': TruckDetails.objects.all(),
            'logs': LogEntry.objects.all(),
            'requestValidation': dict(),
            'rawMaterials': raw_materials,
            'suppliers_data': suppliers_data,
            'stackedBarGraphData': stackedBarGraphData
        }

        for rawMaterialRequest in RawMaterialRequest.objects.filter(status='Pending'):
            fromStoreUnits = StoreInventory.objects.get(rawMaterial_id=rawMaterialRequest.rawMaterial_id,
                                                        storeId=rawMaterialRequest.fromStore_id).unitsAvailable
            toStoreUnits = rawMaterialRequest.units
            print(fromStoreUnits, toStoreUnits)
            context['requestValidation'][rawMaterialRequest.request_id] = ((fromStoreUnits - toStoreUnits) > 0)
        context['logsLen'] = len(context['logs'])
        print(context['requestValidation'])
        return render(request, 'warehouseManagement.html', context)


@login_required
def procurement(request):
    if request.user.email == settings.ADMIN_EMAIL:
        if request.method == "POST":
            model = load('static/files/model.sav')
            dict_data = {
                'raw_material_id': RawMaterials.objects.get(rawMaterial_id=request.POST['rawMaterial_id']),
                'supplier_id': Suppliers.objects.get(supplier_id=request.POST['supplier_id']),
                'units': int(request.POST['units']),
                'calories': float(request.POST['calories']),
                'proteins': float(request.POST['proteins']),
                'fat': float(request.POST['fat']),
                'sodium': float(request.POST['sodium']),
            }
            dict_data['quality_score'] = model.predict([[
                dict_data['calories'],
                dict_data['proteins'],
                dict_data['fat'],
                dict_data['sodium']
            ]])[0].round(2)
            batch = RawMaterialBatches(
                rawMaterial_id=dict_data['raw_material_id'],
                supplier=dict_data['supplier_id'],
                units=dict_data['units'],
                calories=dict_data['calories'],
                sodium=dict_data['sodium'],
                proteins=dict_data['proteins'],
                fat=dict_data['fat'],
                quality_score=dict_data['quality_score'],
                hash=''
            )
            batch.save()
            unique_batch_id = batch.uniqueBatch_id

            rawMaterial_update = StoreInventory.objects.get(
                rawMaterial_id=request.POST['rawMaterial_id'],
                storeId=StoreDetails.objects.get(store_id='W')
            )
            rawMaterial_update.unitsAvailable += dict_data['units']
            rawMaterial_update.save()

            data = "%d;%s;%s;%s;%s;%s;%s;%s;%s" % (
                unique_batch_id,
                dict_data['raw_material_id'].rawMaterial_name,
                dict_data['supplier_id'].supplier_name,
                dict_data['units'],
                dict_data['quality_score'],
                dict_data['calories'],
                dict_data['proteins'],
                dict_data['sodium'],
                dict_data['fat']
            )
            context = dict_data.copy()
            message = TryteString.from_unicode(data)
            tx = ProposedTransaction(
                address=Address(address),
                message=message,
                value=0
            )
            result = api.send_transfer(transfers=[tx], min_weight_magnitude=10)
            dict_data['hashValue'] = result['bundle'].tail_transaction.hash
            batch.hash = dict_data['hashValue']
            batch.save()

            dict_data['hashValue'] = str(dict_data['hashValue'])
            dict_data['raw_material_id'] = dict_data['raw_material_id'].rawMaterial_name
            dict_data['supplier_id'] = dict_data['supplier_id'].supplier_name
            db = firestore.client()
            db.collection(u'RawMaterialBatch').document(str(unique_batch_id)).set(dict_data)

            dict_data['unique_id'] = unique_batch_id
            context['unique_id'] = unique_batch_id
            context['hash'] = batch.hash
            context['backButton'] = True
            context['backButtonLink'] = 'procurement'
            return render(request, 'procure_success.html', context)

        context = {
            'rawMaterials': RawMaterials.objects.all(),
            'suppliers': Suppliers.objects.all(),
        }
        return render(request, 'procurement.html', context)
    return render(request, '404.html')


@login_required
def forecast(request):
    if request.user.email == settings.ADMIN_EMAIL:
        context = {
            'rawMaterials': RawMaterials.objects.all(),
            'post': False,
            'pageTitle': 'Forecast'
        }
        if request.method == "POST":
            context['post'] = True
            context['forecast'] = {}
            rawMaterial = RawMaterials.objects.get(rawMaterial_id=request.POST['rawMaterial_id'])
            context['pageTitle'] = rawMaterial.rawMaterial_name
            forecastPeriod = int(request.POST['forecastPeriod'])
            storesList = StoreDetails.objects.exclude(store_id='W')
            for store in storesList:
                try:
                    model = tsModel(rawMaterial.rawMaterial_id, store.store_id, forecastPeriod)
                    if len(TransactionHistory.objects.filter(storeId=store, rawMaterial_id=rawMaterial)) < 2:
                        continue
                    forecast_day, forecast_hour, forecast_week, forecast_month = model.fb_prophet()
                    context['forecast'][store] = {
                        'forecast_day': forecast_day[1],
                        'forecast_hour': forecast_hour[1],
                        'forecast_week': forecast_week[1],
                        'forecast_month': forecast_month[1],
                    }
                except RuntimeError:
                    pass
            try:
                context['labels'] = [forecast_day[0], forecast_hour[0], forecast_week[0], forecast_month[0]]
            except NameError:
                pass
            context['backButton'] = True
            context['backButtonLink'] = 'forecast'
        return render(request, 'forecastDetails.html', context)
    return render(request, '404.html')


class CheckAvailability(generics.ListCreateAPIView):
    search_fields = ['rawMaterial_id__rawMaterial_name']
    filter_backends = (filters.SearchFilter,)
    queryset = StoreInventory.objects.exclude(storeId='W')
    serializer_class = MaterialAvailability


class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer


class UserCreateAPIView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = (AllowAny,)
