#coding=utf-8
from django.urls import path, re_path
from cartapp import views


urlpatterns = [
    re_path(r'^$', views.CartView.as_view()),
    re_path(r'^queryAll/$', views.queryAll),
]