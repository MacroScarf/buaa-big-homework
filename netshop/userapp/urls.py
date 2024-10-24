from django.urls import path, re_path

from userapp import views

urlpatterns = [
    re_path(r'^register/$', views.RegisterView.as_view()),
    re_path(r'^center/$', views.CenterView.as_view()),
    re_path(r'^login/$', views.LoginView.as_view()),
    re_path(r'^loadCode/$', views.LoadCodeView.as_view()),
    re_path(r'^logout/$', views.LogoutView.as_view()),
]
