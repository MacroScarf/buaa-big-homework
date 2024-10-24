import json

import json

from django.db import models


class Shop(models.Model):
    sname = models.CharField(max_length=50)
    fan_num = models.IntegerField(default=1)
    rating = models.DecimalField(max_digits=3, decimal_places=2, default=3)
    slogourl = models.ImageField(upload_to='shop_logo/', default='/media/shop_logo/2.png')
    user = models.ForeignKey('userapp.UserInfo', on_delete=models.CASCADE)

    def __str__(self):
        return self.sname

    def getGoods(self):
        goodslist = self.goods_set.all()
        return goodslist

    def getUserInfo(self):
        return self.user

    def getLogoImage(self):
        return self.slogourl

    def getHotGoodsList(self):
        goodslist = self.goods_set.filter(isHot=True, isdelete=False)
        if goodslist:
            return goodslist
        else:
            return sorted(self.goods_set.filter(isdelete=False), key=lambda x: x.getSalesVolume(), reverse=True)[:4]

    def getTotalSalesVolume(self):
        goodslist = self.getGoods()
        totalsalesvolume = 0
        for good in goodslist:
            totalsalesvolume += good.getSalesVolume()
        return totalsalesvolume

    def updateRating(self):
        goodslist = self.getGoods()
        newrating = 0.0
        totalVolume = 0
        for good in goodslist:
            volume = good.getSalesVolume()
            newrating += good.getRating() * volume
            totalVolume += volume
        self.rating = round((newrating / totalVolume), 2)

    def getShopDict(self):
        goodslist = self.getGoods()
        sales = []
        sales_pro = []
        totalVolume = self.getTotalSalesVolume()
        if totalVolume == 0:
            totalVolume = 1

        for good in goodslist:
            gname = good.gname
            if good.isdelete:
                gname += '（下架）'

            volume = good.getSalesVolume()
            sales.append({'gname': gname, 'volume': volume})
            sales_pro.append({'gname': gname, 'proportion': round(volume / totalVolume, 2)})

        sales = json.dumps(sales, ensure_ascii=False)
        sales_pro = json.dumps(sales_pro, ensure_ascii=False)

        return json.dumps({
            'sname': self.sname,
            'totalSales': sales,
            'proportionSales': sales_pro
        })
