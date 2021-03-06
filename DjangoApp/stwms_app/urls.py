from django.urls import path, include
from . import views
from rest_framework import routers

router = routers.DefaultRouter()
router.register(r'users', views.UserViewSet)

urlpatterns = [
    path('', views.index, name="index"),
    path('home', views.stores, name="home"),
    path('accounts/sign_up/', views.sign_up, name="sign-up"),
    path('stores', views.stores, name="stores"),
    path('storeDetails', views.store_details, name="storeDetails"),
    path('rm_request', views.rawmaterial_request, name="rawMaterial-request"),
    path('warehouse_management', views.w_manage, name='warehouse-management'),
    path('procurement', views.procurement, name='procurement'),
    path('forecast', views.forecast, name="forecast"),
    path('check_avail', views.CheckAvailability.as_view(), name='check-avail'),

    # REST Framework
    path('api-login', include(router.urls)),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    path('api-create', views.UserCreateAPIView.as_view())
]
