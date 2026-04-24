from django.contrib import admin
from django.urls import path, re_path
from django.conf import settings
from django.views.static import serve as static_serve
from . import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/core', views.api_core),
    path('api/functions', views.api_functions),
    path('test/', views.test_page),
    # Serve React app — must be last
    re_path(r'^(?!api/|admin/|test/|static/).*$', views.react_app),
]
