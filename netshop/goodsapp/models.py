import json

from django.db import models

# Create your models here.
from django.db import models
import collections

from userapp.models import UserInfo
from shopapp.models import Shop
from django.db.models import Count
from django.db.models.functions import Cast
from django.db.models import DateField


# Create your models here.


class Category(models.Model):
    cname = models.CharField(max_length=10)

    def __str__(self):
        return self.cname


class Goods(models.Model):
    gname = models.CharField(max_length=100)
    gdesc = models.CharField(max_length=100)
    oldprice = models.DecimalField(max_digits=10, decimal_places=2)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    isHot = models.BooleanField(default=False)
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
    shop = models.ForeignKey(Shop, on_delete=models.CASCADE)
    isdelete = models.BooleanField(default=False)

    def __str__(self):
        return self.gname

    def goods_to_dict(self):
        from orderapp.models import OrderItem
        # 评论
        commentlist = Comment.objects.filter(goods=self)
        # 按日期分组并计算每组的评论数量
        comments_grouped = commentlist.annotate(date_only=Cast('date', DateField())).values('date_only').annotate(
            count=Count('id')).order_by('date_only')
        comments = []
        for comment in comments_grouped:
            date_str = comment['date_only'].strftime('%Y-%m-%d') if comment['date_only'] else None
            comments.append({
                'date': date_str,
                'count': comment['count']
            })
        comments = json.dumps(comments, ensure_ascii=False)

        # 销量
        orderitemlist = OrderItem.objects.filter(goodsid=self.id)
        sales = []
        sales_dict = {}
        for orderitem in orderitemlist:
            order = orderitem.order
            if order.status != '已支付':
                continue
            date_str = order.date.strftime('%Y-%m-%d') if order.date else None
            # 先记录成字典，将时间相同的合并
            if date_str in sales_dict:
                sales_dict[date_str] += orderitem.count
            else:
                sales_dict[date_str] = orderitem.count
        sales = [{'date': date, 'count': count} for date, count in sales_dict.items()]
        sales = json.dumps(sales, ensure_ascii=False)

        # 款式
        inventorys = Inventory.objects.filter(goods=self)
        styles_dict = {}
        styles = []
        for inventory in inventorys:
            count = inventory.count
            color = inventory.color.colorname
            size = inventory.size.sname
            if color not in styles_dict:
                styles_dict[color] = {}
            if size not in styles_dict[color]:
                styles_dict[color][size] = 0
            styles_dict[color][size] += count
        styles = [{'color': color, 'size': size} for color, size in styles_dict.items()]
        styles = json.dumps(styles, ensure_ascii=False)
        return json.dumps({
            'id': str(self.id),
            'gname': str(self.gname),
            'comments': comments,
            'sales': sales,
            'styles': styles
        })

    def getColorImg(self):
        return self.inventory_set.first().color.colorurl

    def getColors(self):
        colors = []
        for inventory in self.inventory_set.all():
            color = inventory.color
            if color not in colors:
                colors.append(color)
        return colors

    def getSizes(self):
        sizes = []
        for inventory in self.inventory_set.all():
            size = inventory.size
            if size not in sizes:
                sizes.append(size)
        return sizes

    def getDetailInfo(self):
        datas = collections.OrderedDict()
        for detail in self.gooddetail_set.all():
            gdname = detail.getName()
            if gdname not in datas:
                datas[gdname] = [detail.gdurl]
            else:
                datas[gdname].append(detail.gdurl)
        return datas

    def getSalesVolume(self):
        from orderapp.models import OrderItem
        orderlist = OrderItem.objects.filter(goodsid=self.id)
        volume = 0
        for orderitem in orderlist:
            if orderitem.order.status == '已支付':
                volume += orderitem.count
        return volume

    def getRating(self):
        rating = 0.0
        i = 0
        for comment in self.comment_set.all():
            i += 1
            rating += comment.rating * 1.0
        if i > 0:
            rating = round((rating / i), 2)
        else:
            rating = 3.0
        # print(rating)
        return rating

    def isUsed(self):
        return False


class GoodsDetailName(models.Model):
    gdname = models.CharField(max_length=30)


class GoodDetail(models.Model):
    gdurl = models.ImageField(upload_to='')
    goodsdname = models.ForeignKey(GoodsDetailName, on_delete=models.CASCADE)
    goods = models.ForeignKey(Goods, on_delete=models.CASCADE)

    def getName(self):
        return self.goodsdname.gdname


class Size(models.Model):
    sname = models.CharField(max_length=10)


class Color(models.Model):
    colorname = models.CharField(max_length=10)
    colorurl = models.ImageField(upload_to='color/')


class Inventory(models.Model):
    count = models.PositiveIntegerField(default=100)
    color = models.ForeignKey(Color, on_delete=models.CASCADE)
    goods = models.ForeignKey(Goods, on_delete=models.CASCADE)
    size = models.ForeignKey(Size, on_delete=models.CASCADE)


class Comment(models.Model):
    content = models.CharField(max_length=100)
    date = models.DateTimeField(auto_now_add=True)
    rating = models.IntegerField(default=0)
    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)
    goods = models.ForeignKey(Goods, on_delete=models.CASCADE)

    def getUname(self):
        return self.user.uname


class UsedGoods(models.Model):
    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)
    gname = models.CharField(max_length=100, unique=True)
    gdesc = models.CharField(max_length=100)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
    isdelete = models.BooleanField(default=False)

    def __str__(self):
        return self.gname

    def getColorImg(self):
        return self.usedgoodsdetail_set.first().ugdurl

    def getDetailImg(self):
        return self.usedgoodsdetail_set.all()[1].ugdurl

    def getOrderStatus(self):
        from orderapp.models import OrderItem, Order
        orderitemlist = OrderItem.objects.filter(goodsid=self.id, colorid=0)
        orderstatuslist = [Order.objects.get(id=orderitem.order_id).status for orderitem in orderitemlist]
        if '未支付' in orderstatuslist:
            return False
        else:
            return True

    def getSalesVolume(self):
        return 0

    def getRating(self):
        return 3.0

    def isUsed(self):
        return True


class UsedGoodsDetail(models.Model):
    ugdurl = models.ImageField(upload_to='')
    ugdname = models.CharField(max_length=30, default='二手商品详情描述')
    usedgoods = models.ForeignKey(UsedGoods, on_delete=models.CASCADE)

    def __str__(self):
        return self.ugdname
