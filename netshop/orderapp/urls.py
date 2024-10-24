from django.urls import path, re_path
from orderapp.views import toPayView, orderView, orderListView

urlpatterns = [
    path('', orderView.as_view()),
    path('toPay/', toPayView.as_view()),
    path('orderList/', orderListView.as_view()),
]
