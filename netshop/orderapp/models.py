from __future__ import unicode_literals
from django.db import models

from goodsapp.models import Color, Goods, Size, UsedGoods
from shopapp.models import Shop
from userapp.models import Address, UserInfo


class Order(models.Model):
    order_num = models.CharField(max_length=50)
    date = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, default='未生成')
    payway = models.CharField(max_length=20, default='walletpay')
    address = models.ForeignKey(Address, on_delete=models.CASCADE)
    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)
    totalPrice = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)


class OrderItem(models.Model):
    goodsid = models.PositiveIntegerField()
    colorid = models.PositiveIntegerField()
    sizeid = models.PositiveIntegerField()
    count = models.PositiveIntegerField()
    order = models.ForeignKey(Order, on_delete=models.CASCADE)

    def getColor(self):
        return Color.objects.get(id=self.colorid)

    def getGoods(self):
        return Goods.objects.get(id=self.goodsid)

    def getSize(self):
        return Size.objects.get(id=self.sizeid)

    def getTotalPrice(self):
        return int(self.count) * self.getGoods().price

    def getShop(self):
        good = Goods.objects.get(id=self.goodsid)
        shop = good.shop
        return shop

    def getOrder(self):
        return self.order

    def getUsedGoods(self):
        return UsedGoods.objects.get(id=self.goodsid)
