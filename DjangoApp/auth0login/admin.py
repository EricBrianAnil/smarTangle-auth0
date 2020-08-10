from django.contrib import admin
from social_django.models import UserSocialAuth, Association, Nonce

# Register your models here.
admin.site.unregister(UserSocialAuth)
admin.site.unregister(Association)
admin.site.unregister(Nonce)
