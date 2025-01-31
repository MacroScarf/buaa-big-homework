# coding=utf-8

from collections import OrderedDict
from cartapp.models import *
from django.db.models import F
import jsonpickle

from goodsapp.models import Inventory


class CartManager(object):
    def add(self, goodsid, colorid, sizeid, count, *args, **kwargs):
        # 添加商品，如果商品已经存在就更新商品的数量(self.update())，否则直接放到购物车
        pass

    def delete(self, goodsid, colorid, sizeid, *args, **kwargs):
        # 删除一个购物项
        pass

    def update(self, goodsid, colorid, sizeid, count, step, *args, **kwargs):
        # 更新购物项的数据,添加减少购物项数据
        pass

    def queryAll(self, *args, **kwargs):
        # :return CartItem  多个购物项
        pass

    def judge(self, goodsid, colorid, sizeid, count, *args, **kwargs):
        # 判断商品的数量还够不够
        try:
            inventory = Inventory.objects.get(goods_id=goodsid, color_id=colorid, size_id=sizeid)
            if inventory.count >= int(count):
                return {'success': True, 'message': '库存充足'}
            else:
                return {'success': False, 'message': '库存不足'}
        except Inventory.DoesNotExist:
            return {'success': False, 'message': '商品不存在'}


# 当前用户未登录
class SessionCartManager(CartManager):
    cart_name = 'cart'

    def __init__(self, session):
        self.session = session
        # 创建购物车 #  {cart:{key1:cartitem,key2:cartitem}}
        if self.cart_name not in self.session:
            self.session[self.cart_name] = OrderedDict()

    def __get_key(self, goodsid, colorid, sizeid):
        return goodsid + ',' + colorid + ',' + sizeid

    def add(self, goodsid, colorid, sizeid, count, *args, **kwargs):
        # 获取购物项的唯一标示
        key = self.__get_key(goodsid, colorid, sizeid)

        # session   {'cart':{key1:item}}
        # session('cart',[{key1:cartitem,key2:cartitem}])
        if key in self.session[self.cart_name]:
            self.update(goodsid, colorid, sizeid, count, *args, **kwargs)
        else:
            self.session[self.cart_name][key] = jsonpickle.dumps(
                CartItem(goodsid=goodsid, colorid=colorid, sizeid=sizeid, count=count))

    def delete(self, goodsid, colorid, sizeid, *args, **kwargs):
        key = self.__get_key(goodsid, colorid, sizeid)
        if key in self.session[self.cart_name]:
            del self.session[self.cart_name][key]

    def update(self, goodsid, colorid, sizeid, step, *args, **kwargs):
        key = self.__get_key(goodsid, colorid, sizeid)
        if key in self.session[self.cart_name]:
            cartitem = jsonpickle.loads(self.session[self.cart_name][key])
            cartitem.count = int(str(cartitem.count)) + int(step)
        else:
            raise Exception('SessionManager中的update出错了')

    def queryAll(self, *args, **kwargs):
        scartitemlist = self.session[self.cart_name].values()
        cartitemlist = [jsonpickle.loads(sc) for sc in scartitemlist]

        return cartitemlist

    def migrateSession2DB(self):
        if 'user' in self.session:
            user = jsonpickle.loads(self.session.get('user'))
            for cartitem in self.queryAll():
                if CartItem.objects.filter(goodsid=cartitem.goodsid, colorid=cartitem.colorid,
                                           sizeid=cartitem.sizeid).count() == 0:
                    cartitem.user = user
                    cartitem.save()
                else:
                    item = CartItem.objects.get(goodsid=cartitem.goodsid, colorid=cartitem.colorid,
                                                sizeid=cartitem.sizeid)
                    item.count = int(item.count) + int(cartitem.count)
                    item.save()

            del self.session[self.cart_name]


# 用户已登录
class DBCartManger(CartManager):
    def __init__(self, user):
        self.user = user

    def add(self, goodsid, colorid, sizeid, count, *args, **kwargs):
        if self.user.cartitem_set.filter(goodsid=goodsid, colorid=colorid, sizeid=sizeid).count() == 1:
            self.update(goodsid, colorid, sizeid, count, *args, **kwargs)
        else:
            CartItem.objects.create(goodsid=goodsid, colorid=colorid, sizeid=sizeid, count=count, user=self.user)

    def delete(self, goodsid, colorid, sizeid, *args, **kwargs):
        self.user.cartitem_set.filter(goodsid=goodsid, colorid=colorid, sizeid=sizeid).delete()

    def update(self, goodsid, colorid, sizeid, step, *args, **kwargs):
        self.user.cartitem_set.filter(goodsid=goodsid, colorid=colorid, sizeid=sizeid).update(
            count=F('count') + int(step), isdelete=False)

    def queryAll(self, *args, **kwargs):
        return self.user.cartitem_set.order_by('id').filter(isdelete=False).all()

    # 根据goodsid,sizeid,colorid获取CartItem对象
    def get_cartitems(self, goodsid, sizeid, colorid, *args, **kwargs):
        return self.user.cartitem_set.get(goodsid=goodsid, sizeid=sizeid, colorid=colorid)


# 工厂方法
# 根据当前用户是否登录返回相应的CartManger对象
def getCartManager(request):
    if request.session.get('user'):
        # 当前用户已登录
        return DBCartManger(jsonpickle.loads(request.session.get('user')))
    return SessionCartManager(request.session)
