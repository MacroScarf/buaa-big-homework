import decimal

from django.db import models


class Area(models.Model):
    areaid = models.IntegerField(primary_key=True, help_text='区域编号')
    areaname = models.CharField(max_length=50, help_text='区域名称')
    parentid = models.IntegerField(help_text='父级编号')
    arealevel = models.IntegerField(help_text='区域等级(1省/2市/3区县)')
    status = models.IntegerField(help_text='状态（1可用/0不可用）')

    class Meta:
        managed = False
        db_table = 'area'
        unique_together = (('areaid', 'parentid'),)


class UserInfo(models.Model):
    uname = models.EmailField()
    pwd = models.CharField(max_length=1000)
    uidentity = models.CharField(max_length=50, default='student')
    balance = models.DecimalField(max_digits=15, decimal_places=2, default=decimal.Decimal('0.00'))

    def __str__(self):
        return self.uname

    def getShopCount(self):
        return self.shop_set.count()

    class Meta:
        ordering = ('id',)


class Address(models.Model):
    aname = models.CharField(max_length=30)
    aphone = models.CharField(max_length=11)
    addr = models.CharField(max_length=100)
    isdefault = models.BooleanField(default=False)
    userinfo = models.ForeignKey(UserInfo, on_delete=models.CASCADE, help_text='用户信息')


class FollowShop(models.Model):
    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)
    shop = models.ForeignKey('shopapp.Shop', on_delete=models.CASCADE)


class FavoriteGood(models.Model):
    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)
    good = models.ForeignKey('goodsapp.Goods', on_delete=models.CASCADE)


class UserFootprint(models.Model):
    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)
    goods = models.ForeignKey('goodsapp.Goods', on_delete=models.CASCADE)
    timestamp = models.DateTimeField(auto_now_add=True)  # 记录足迹的时间戳

    class Meta:
        unique_together = (('user', 'goods'),)  # 确保同一个用户对同一商品只有一个足迹记录
