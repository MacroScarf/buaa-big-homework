import datetime
import json
import time
import uuid
from decimal import Decimal

import jsonpickle
import pytz
from django.http import JsonResponse
from django.shortcuts import render
from django.views import View
from datetime import datetime
from goodsapp.models import Inventory, Goods
from orderapp.models import Order, OrderItem
from userapp.models import Address


# Create your views here.
class orderView(View):
    def get(self, request):
        items = request.GET.get('cartitems', '')

        # 获取当前用户登录信息
        user = jsonpickle.loads(request.session.get('user'))

        if not user:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        option = request.GET.get('option', '')
        orderItemList = []

        # 先使用默认地址
        addrObj = user.address_set.get(isdefault=True)

        # 获取用户的收件地址
        addrList = user.address_set.all()
        shanghai_tz = pytz.timezone('Asia/Shanghai')
        current_time = datetime.now(shanghai_tz)
        timestamp = datetime.now(shanghai_tz).strftime('%Y%m%d%H%M%S%f')

        # 添加Order表信息
        params = {
            'order_num': timestamp,
            'date': current_time,
            'status': '未生成',
            'payway': 'walletpay',
            'address': addrObj,
            'user': user,
            'totalPrice': Decimal('0.00'),
        }

        # 创建一个表单对象
        orderObj = Order.objects.create(**params)
        orderId = orderObj.id
        orderNum = orderObj.order_num

        # 是否为二手商品
        isUsed = False

        if option == 'single':
            item = json.loads(items)
            # 生成一个orderitem
            orderitemObj = OrderItem.objects.create(order=orderObj, **item)

            if orderitemObj.colorid == 0:
                isUsed = True

            orderItemList.append(orderitemObj)
        else:
            cartitemsList = jsonpickle.loads(items)
            for ci in cartitemsList:
                orderItemList.append(OrderItem.objects.create(order=orderObj, **ci))

        # 计算总价格
        totalPrice = 0
        if isUsed is False or isUsed == 'False':
            for o in orderItemList:
                totalPrice += o.getTotalPrice()
        else:
            totalPrice = orderitemObj.getUsedGoods().price

        orderObj.totalPrice = totalPrice
        orderObj.save()

        return render(request, 'order.html', {
            'orderItemList': orderItemList,
            'orderId': orderId,
            'orderNum': orderNum,
            'addrList': addrList,
            'totalPrice': totalPrice,
            'isUsed': isUsed})

    def post(self, request):
        addressId = request.POST.get('addressId', '')
        orderId = request.POST.get('orderId', '')
        isUsed = request.POST.get('isUsed', '')

        # 获取订单对象
        order = Order.objects.get(id=orderId)
        if not order:
            return JsonResponse({'success': False, 'error': '订单不存在'}, status=403)

        # 更新订单信息
        address = Address.objects.get(id=addressId)
        if not address:
            return JsonResponse({'success': False, 'error': '地址不存在'}, status=403)

        if isUsed == 'False' or isUsed is False:
            # 购买前判断库存是否充足
            for orderitem in order.orderitem_set.all():
                goods = orderitem.getGoods()
                color = orderitem.getColor()
                size = orderitem.getSize()
                inventory = Inventory.objects.get(goods=goods, color=color, size=size)
                if inventory.count < orderitem.count:
                    return JsonResponse({'success': False, 'error': '商品 ' + goods.gname + ' 的库存不够'})

        # 判断是否存在下架商品
        for orderitem in order.orderitem_set.all():
            if isUsed == 'True' or isUsed is True:
                usedgoods = orderitem.getUsedGoods()
                if usedgoods.isdelete:
                    return JsonResponse({'success': False, 'error': '商品 ' + usedgoods.gname + ' 已下架'})
            else:
                goods = orderitem.getGoods()
                if goods.isdelete:
                    return JsonResponse({'success': False, 'error': '商品 ' + goods.gname + ' 已下架'})

        order.status = '未支付'
        order.address = address
        order.save()

        return JsonResponse({'success': True})


class toPayView(View):
    def get(self, request):
        user = jsonpickle.decode(request.session.get('user'))
        if not user:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        orderId = request.GET.get('orderId')
        if not orderId:
            return JsonResponse({'error': 'Missing orderId'}, status=400)

        order = Order.objects.get(id=orderId)
        if not order:
            return JsonResponse({'error': 'Order not found'}, status=403)

        orderNum = order.order_num
        orderItemList = OrderItem.objects.filter(order=order)
        totalPrice = order.totalPrice
        address = order.address

        return render(request, 'toPay.html', {
            'user': user,
            'orderItemList': orderItemList,
            'orderId': orderId,
            'orderNum': orderNum,
            'totalPrice': totalPrice,
            'address': address})

    def post(self, request):
        user = jsonpickle.decode(request.session['user'])
        if not user:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        totalPrice = request.POST.get('totalPrice', '')
        if not totalPrice:
            return JsonResponse({'error': 'Missing total price'}, status=400)

        orderId = request.POST.get('orderId', '')
        if not orderId:
            return JsonResponse({'error': 'Missing orderId'}, status=400)

        order = Order.objects.get(id=orderId)

        orderItem = order.orderitem_set.first()
        if orderItem.colorid == 0:
            isUsed = True
        else:
            isUsed = False

        balance = user.balance
        totalPrice = Decimal(totalPrice)

        if order.status == '已支付':
            return JsonResponse({'success': False, 'error': '您已支付过了'})

        # 判断余额是否足够
        if balance < totalPrice:
            return JsonResponse({'success': False, 'error': '余额不足，请充值'})

        if isUsed == 'False' or isUsed is False:
            # 购买前判断库存是否充足
            for orderitem in order.orderitem_set.all():
                goods = orderitem.getGoods()
                color = orderitem.getColor()
                size = orderitem.getSize()
                inventory = Inventory.objects.get(goods=goods, color=color, size=size)

                if inventory.count < orderitem.count:
                    return JsonResponse({'success': False, 'error': '商品 ' + goods.gname + ' 的库存不够'})

                inventory.count -= orderitem.count
                inventory.save()

        # 判断是否存在下架商品
        for orderitem in order.orderitem_set.all():
            if isUsed == 'True' or isUsed is True:
                usedgoods = orderitem.getUsedGoods()
                if usedgoods.isdelete:
                    return JsonResponse({'success': False, 'error': '商品 ' + usedgoods.gname + ' 已下架'})
            else:
                goods = orderitem.getGoods()
                if goods.isdelete:
                    return JsonResponse({'success': False, 'error': '商品 ' + goods.gname + ' 已下架'})

        # 买家扣费
        user.balance -= totalPrice
        request.session['user'] = jsonpickle.encode(user)
        user.save()

        # 订单更新状态
        order.status = '已支付'
        order.save()

        if not isUsed:
            for orderitem in order.orderitem_set.all():
                # 卖家到账
                shop = orderitem.getShop()
                merchant = shop.getUserInfo()
                eachPrice = Decimal(orderitem.getTotalPrice())
                merchant.balance += eachPrice
                merchant.save()
        else:
            for orderitem in order.orderitem_set.all():
                # 二手商品售出后下架
                usedgoods = orderitem.getUsedGoods()
                usedgoods.isdelete = True
                usedgoods.save()

                # 卖家到账
                merchant = orderitem.getUsedGoods().user
                eachPrice = Decimal(orderitem.getUsedGoods().price)
                merchant.balance += eachPrice
                merchant.save()

        return JsonResponse({'success': True})


class orderListView(View):
    def get(self, request):
        user = jsonpickle.decode(request.session['user'])
        if not user:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        # .order_by('-id')用于倒序获取 order，使得新生成的order在前展示
        orderListAll = Order.objects.filter(user=user, status__in=['未支付', '已支付']).order_by('-id')
        orderListUnpaid = Order.objects.filter(user=user, status='未支付').order_by('-id')
        orderListPaid = Order.objects.filter(user=user, status='已支付').order_by('-id')

        if user.uidentity == 'campus-merchant':
            # 获取自己商店的订单
            myOrderItemList = []
            for orderitem in OrderItem.objects.all():
                if orderitem.getOrder().status != '已支付':
                    continue
                if orderitem.colorid == 0:
                    continue

                shop = orderitem.getShop()
                # 这个订单商品所属商店是该用户的
                if shop.getUserInfo() == user:
                    myOrderItemList.append(orderitem)

            myOrderItemList = sorted(myOrderItemList, key=lambda x: x.getOrder().id, reverse=True)

            return render(request, 'orderList.html', {
                'user': user,
                'orderListAll': orderListAll,
                'orderListUnpaid': orderListUnpaid,
                'orderListPaid': orderListPaid,
                'myOrderItemList': myOrderItemList})

        usedOrderItemList = []
        for orderitem in OrderItem.objects.all():
            if orderitem.getOrder().status != '已支付':
                continue

            if orderitem.colorid == 0 and orderitem.getUsedGoods().user == user:
                usedOrderItemList.append(orderitem)

        return render(request, 'orderList.html', {
            'user': user,
            'orderListAll': orderListAll,
            'orderListUnpaid': orderListUnpaid,
            'orderListPaid': orderListPaid,
            'usedOrderItemList': usedOrderItemList})
