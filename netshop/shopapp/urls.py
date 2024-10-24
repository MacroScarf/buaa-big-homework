from django.urls import path, re_path

from shopapp import views

urlpatterns = [
    path('<int:shopid>/shopdetail/', views.ShopView.as_view()),
    path('<int:shopid>/shopdetail/page/<int:num>', views.ShopView.as_view()),
]
