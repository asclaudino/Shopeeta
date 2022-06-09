from django.urls import path

from . import views

urlpatterns = [
    path("verify_username/", views.verify_username),
    path("verify_email/", views.verify_email),
    
    path('user/', views.UserView.as_view()),
]