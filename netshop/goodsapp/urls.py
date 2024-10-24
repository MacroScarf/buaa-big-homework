from django.contrib import admin
from django.urls import path, re_path
from goodsapp import views

urlpatterns = [
    path('', views.IndexView.as_view()),
    path('category/<int:cid>/', views.IndexView.as_view()),
    path('category/<int:cid>/page/<int:num>', views.IndexView.as_view()),
    re_path(r'^goodsdetails/(\d+)/$', views.DetailView.as_view()),
    re_path(r'^goodsdetails/(\d+)/comment/$', views.CommentView.as_view()),
    path('search/', views.SearchView.as_view()),
    path('usedgoodsdetail/<int:ugid>/', views.usedGoodDetailView.as_view()),
]
