# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import re
from decimal import Decimal, InvalidOperation

import jsonpickle
from django.core.files.storage import default_storage
from django.http import HttpResponseRedirect, HttpResponse, JsonResponse
from django.shortcuts import render, redirect
from django.views import View

from goodsapp.models import Goods, UsedGoods, UsedGoodsDetail
from shopapp.models import Shop
from userapp.models import UserInfo, Address, FavoriteGood, FollowShop, UserFootprint
from utils.code import *

from django.contrib.auth import login


def check_pattern(var):
    # 判断账号密码是否符合规范：大小写字母、数字、短横线和下划线
    pattern = re.compile(r'^[a-zA-Z0-9_-]{6,18}$')
    return pattern.fullmatch(var) is not None


def check_phonenumber(var):
    # 判断电话号码是否符合规范
    pattern = re.compile(r'^1[3-9]\d{9}$')
    return pattern.fullmatch(var) is not None


def check_price(var):
    # 判断金钱相关是否符合规范：不大于99999999的正数，最多两位小数
    pattern = re.compile(r'^\d+(\.\d{1,2})?$')
    return pattern.fullmatch(var) and 0 < float(var) < 99999999


class RegisterView(View):
    def get(self, request):
        return render(request, 'register.html')

    def post(self, request):
        # 获取请求参数
        account = request.POST.get('account', '')
        password = request.POST.get('password', '')
        password2 = request.POST.get('password2', '')
        hex_pwd = request.POST.get('hex_pwd', '')
        identity = request.POST.get('identity', '')
        if identity == '学生':
            identity = 'student'
        elif identity == '校园商户':
            identity = 'campus-merchant'
        print(account)
        # 数据库中查询当前用户是否存在
        if UserInfo.objects.filter(uname=account).exists():
            return JsonResponse({'success': False, 'error': '用户已存在'},status=400)

        # 判断用户名是否符合规范
        if not check_pattern(account):
            return JsonResponse({'success': False, 'error': '用户名格式不正确'},status=400)

        # 判断密码是否符合规范
        if not check_pattern(password):
            return JsonResponse({'success': False, 'error': '密码格式不正确'},status=400)

        # 判断两次密码是否相同
        if password != password2:
            return JsonResponse({'success': False, 'error': '两次输入的密码不一致'},status=400)

        # 将用户名和密码插入到数据库
        user = UserInfo.objects.create(uname=account, pwd=hex_pwd, uidentity=identity)

        # 判断注册成功与否
        if user:
            # 将当前注册用户对象保存到session中
            request.session['user'] = jsonpickle.encode(user)
            return JsonResponse({'success': True})

        return JsonResponse({'success': False, 'error': '注册失败'},status=400)


class LoginView(View):
    def get(self, request):
        return render(request, 'login.html')

    def post(self, request):
        # 获取请求参数
        account = request.POST.get('account', '')
        pwd = request.POST.get('password', '')
        code = request.POST.get('code', '')
        session_code = request.session.get('sessionCode', '')

        # 数据库中查询当前用户是否存在
        if not UserInfo.objects.filter(uname=account).exists():
            return JsonResponse({'success': False, 'error': '用户未注册'},status=400)

        # 判断密码是否匹配
        if not UserInfo.objects.filter(uname=account, pwd=pwd).exists():
            return JsonResponse({'success': False, 'error': '密码错误'},status=400)

        # 判断验证码是否正确
        if code != session_code:
            return JsonResponse({'success': False, 'error': '验证码错误'},status=400)

        # 将当前用户对象保存到session中
        userList = UserInfo.objects.filter(uname=account, pwd=pwd)
        request.session['user'] = jsonpickle.encode(userList[0])
        return JsonResponse({'success': True})


class LoadCodeView(View):
    def get(self, request):
        # 调用工具包下的函数生成验证码
        img, txt = gene_code()

        # 将txt保存到session
        request.session['sessionCode'] = txt

        # 响应页面
        return HttpResponse(img, content_type='image/png')


class LogoutView(View):
    def get(self, request):
        request.session.clear()
        return JsonResponse({'flag': True})


class CenterView(View):
    def get(self, request):
        # 获取请求路径中的 'option' 参数，用于确定要调用的方法
        option = request.GET.get('option', '')
        if option == 'address':
            return AddressView.as_view()(request)
        elif option == 'openShop':
            return OpenShopView.as_view()(request)
        elif option == 'recharge':
            return RechargeView.as_view()(request)
        elif option == 'myShop':
            return MyShopView.as_view()(request)
        elif option == 'myCollect':
            return MyCollectView.as_view()(request)
        elif option == 'myFollow':
            return MyFollowView.as_view()(request)
        elif option == 'footprint':
            return FootprintView.as_view()(request)
        elif option == 'usedGoods':
            return UsedGoodsView.as_view()(request)
        else:
            user = jsonpickle.decode(request.session['user'])
            identitylist = {'identity': ''}
            if user.uidentity == 'student':
                identitylist['identity'] = '学生'
            if user.uidentity == 'campus-merchant':
                identitylist['identity'] = '校园商户'
            return render(request, 'center.html', identitylist)

    def post(self, request):
        option = request.POST.get('option', '')
        print(option)
        if option == 'address':
            return AddressView.as_view()(request)
        elif option == 'openShop':
            return OpenShopView.as_view()(request)
        elif option == 'recharge':
            return RechargeView.as_view()(request)
        elif option == 'myShop':
            return MyShopView.as_view()(request)
        elif option == 'usedGoods':
            return UsedGoodsView.as_view()(request)
        else:
            return render(request, 'center.html')


class AddressView(View):
    def get(self, request):
        # action = request.GET.get('action', '')
        return self.get_address_list(request)

    def post(self, request):
        action = request.GET.get('action', '')
        if action == 'setdefault':
            return self.set_default_address(request)
        elif action == 'add':
            return self.add_address(request)
        elif action == 'modify':
            return self.modify_address(request)
        elif action == 'delete':
            return self.delete_address(request)
        else:
            return JsonResponse({'error': 'Invalid action'}, status=400)

    def get_address_list(self, request):
        # 获得地址
        user = jsonpickle.decode(request.session['user'])
        if user is None:
            return HttpResponseRedirect('/user/login/')
        addresslist = Address.objects.filter(userinfo=user)
        return render(request, 'address.html', {'addressList': addresslist})

    def set_default_address(self, request):
        # 修改默认地址
        user = jsonpickle.decode(request.session['user'])
        # 如果没有登录，就返回错误
        if user is None:
            return JsonResponse({'error': 'User not authenticated'}, status=403)
        addressid = request.POST.get('id')
        if not addressid:
            return JsonResponse({'error': 'No address ID provided'}, status=400)
        try:
            address = Address.objects.get(id=addressid, userinfo=user)
            # 将现在的默认地址 isdefault 设置为 False
            Address.objects.filter(userinfo=user, isdefault=True).update(isdefault=False)
            # 将选中的地址的 isdefault 设置为 True
            address.isdefault = True
            address.save()
            return JsonResponse({'success': True})
        except Address.DoesNotExist:
            return JsonResponse({'error': 'Address not found'}, status=404)

    def add_address(self, request):
        user = jsonpickle.decode(request.session['user'])
        if user is None:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        aname = request.POST.get('aname')
        aphone = request.POST.get('aphone')
        addr = request.POST.get('addr')

        if not aname:
            return JsonResponse({'success': False, 'error': '收货人姓名不能为空'})
        if not aphone:
            return JsonResponse({'success': False, 'error': '电话号码不能为空'})
        if not addr:
            return JsonResponse({'success': False, 'error': '收货地址不能为空'})

        if len(aname) > 20:
            return JsonResponse({'success': False, 'error': '收货人姓名过长'})
        if not check_phonenumber(aphone):
            return JsonResponse({'success': False, 'error': '电话号码格式不合法'})
        if len(addr) > 50:
            return JsonResponse({'success': False, 'error': '收货地址过长'})

        address_count = Address.objects.filter(userinfo=user).count()
        if address_count >= 9:
            return JsonResponse({'success': False, 'error': '您的收货地址数量已经达到最大'})

        isdefault = False
        # 如果是第一个地址，就设为默认的
        if Address.objects.filter(userinfo=user, isdefault=True):
            new_address = Address.objects.create(
                aname=aname,
                aphone=aphone,
                addr=addr,
                userinfo=user
            )
        else:
            isdefault = True
            new_address = Address.objects.create(
                aname=aname,
                aphone=aphone,
                addr=addr,
                isdefault=True,
                userinfo=user
            )

        return JsonResponse({'success': True, 'id': new_address.id, 'isdefault': isdefault})

    def modify_address(self, request):
        user = jsonpickle.decode(request.session['user'])
        if user is None:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        addressid = request.POST.get('id')
        aname = request.POST.get('aname')
        aphone = request.POST.get('aphone')
        addr = request.POST.get('addr')

        # 用于debug
        # print(f"Received data: id={addressid}, aname={aname}, aphone={aphone}, addr={addr}")

        if not addressid:
            return JsonResponse({'error': 'Missing required fields'}, status=400)

        if not aname:
            return JsonResponse({'success': False, 'error': '收货人姓名不能为空'})
        if not aphone:
            return JsonResponse({'success': False, 'error': '电话号码不能为空'})
        if not addr:
            return JsonResponse({'success': False, 'error': '收货地址不能为空'})

        if len(aname) > 20:
            return JsonResponse({'success': False, 'error': '收货人姓名过长'})
        if not check_phonenumber(aphone):
            return JsonResponse({'success': False, 'error': '电话号码格式不合法'})
        if len(addr) > 50:
            return JsonResponse({'success': False, 'error': '收货地址过长'})

        try:
            address = Address.objects.get(id=addressid, userinfo=user)
            address.aname = aname
            address.aphone = aphone
            address.addr = addr
            address.save()
            return JsonResponse({'success': True, 'address': {
                'id': address.id, 'aname': address.aname, 'aphone': address.aphone, 'addr': address.addr}})
        except Address.DoesNotExist:
            return JsonResponse({'error': 'Address not found'}, status=404)

    def delete_address(self, request):
        user = jsonpickle.decode(request.session['user'])
        if user is None:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        addressid = request.POST.get('id')
        if not addressid:
            return JsonResponse({'error': 'No address ID provided'}, status=400)

        try:
            address = Address.objects.get(id=addressid, userinfo=user)
            address.delete()
            return JsonResponse({'success': True})
        except Address.DoesNotExist:
            return JsonResponse({'error': 'Address not found'}, status=404)


class OpenShopView(View):
    def get(self, request):
        user = jsonpickle.decode(request.session.get('user'))

        if not user:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        return render(request, 'openShop.html', {'user': user})

    def post(self, request):
        sname = request.POST.get('sname')
        user = jsonpickle.decode(request.session['user'])
        shop_logo = request.FILES.get('shop_logo')

        if not user:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        if not sname:
            return JsonResponse({'success': False, 'error': '店铺名称不能为空'})

        if Shop.objects.filter(sname=sname).exists():
            return JsonResponse({'success': False, 'error': '店铺名称已存在'})

        if len(sname) > 15:
            return JsonResponse({'success': False, 'error': '店铺名称过长'})

        shops_count = Shop.objects.filter(user=user).count()
        if shops_count >= 6:
            return JsonResponse({'success': False, 'error': '您拥有的店铺数量已经达到最大'})

        if shop_logo:
            file_name = default_storage.save(os.path.join('shop_logo', os.path.basename(shop_logo.name)), shop_logo)
            slogourl = '/media/' + file_name
        else:
            slogourl = '/static/images/shop_logo.png'

        shop = Shop.objects.create(sname=sname, user=user, slogourl=slogourl)

        if shop:
            return JsonResponse({'success': True})
        else:
            return JsonResponse({'success': False, 'error': '创建店铺失败'})


class RechargeView(View):
    def get(self, request):
        user = jsonpickle.decode(request.session['user'])

        if not user:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        return JsonResponse({'success': True})

    def post(self, request):
        user = jsonpickle.decode(request.session['user'])

        if not user:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        balance = user.balance
        money_str = request.POST.get('money')

        if check_price(money_str):
            money = Decimal(money_str)
            new_balance = balance + money

            if new_balance > Decimal(9999999.99):
                return JsonResponse({'success': False, 'error': '充值金额过大，或已达到最大余额'})

            user.balance = new_balance
            request.session['user'] = jsonpickle.encode(user)
            user.save()

            return JsonResponse({'success': True, 'balance': new_balance})
        else:
            return JsonResponse({'success': False, 'error': '请输入有效的充值金额'})


class MyShopView(View):
    def get(self, request):
        user = jsonpickle.decode(request.session['user'])
        if not user:
            return HttpResponseRedirect('/user/login/')
        shopList = Shop.objects.filter(user_id=user.id)
        return render(request, 'myShop.html', {'shopList': shopList})

    def post(self, request):
        user = jsonpickle.decode(request.session['user'])
        if not user:
            return JsonResponse({'error': 'User not authenticated'}, status=403)

        return render(request, 'myShop.html')


class MyCollectView(View):
    def get(self, request):
        user = jsonpickle.decode(request.session['user'])
        if not user:
            return HttpResponseRedirect('/user/login/')
        collectlist = FavoriteGood.objects.filter(user_id=user.id)
        goodsidlist = [collect.good_id for collect in collectlist]
        goodslist = [Goods.objects.get(id=goodsid) for goodsid in goodsidlist]
        return render(request, 'myCollect.html', {'goodslist': goodslist})


class MyFollowView(View):
    def get(self, request):
        user = jsonpickle.decode(request.session['user'])
        if not user:
            return HttpResponseRedirect('/user/login/')
        followlist = FollowShop.objects.filter(user_id=user.id)
        shopsidlist = [follow.shop_id for follow in followlist]
        shopslist = [Shop.objects.get(id=shopsid) for shopsid in shopsidlist]
        return render(request, 'myFollow.html', {'shopslist': shopslist})


class FootprintView(View):
    def get(self, request):
        user = jsonpickle.decode(request.session['user'])
        if not user:
            return HttpResponseRedirect('/user/login/')

        footprints = UserFootprint.objects.filter(user=user).order_by('-timestamp')  # 按时间倒序排序
        goods_list = [Goods.objects.get(id=fp.goods_id) for fp in footprints]

        return render(request, 'footprint.html', {'goods_list': goods_list})


class UsedGoodsView(View):
    def get(self, request):
        user = jsonpickle.decode(request.session['user'])
        if not user:
            return HttpResponseRedirect('/user/login/')

        usedGoodsList = UsedGoods.objects.filter(user=user)

        return render(request, 'UsedGoods.html', {'usedGoodsList': usedGoodsList})

    def post(self, request):
        action = request.POST.get('action', '')

        if action == 'addusedgood':
            user = jsonpickle.decode(request.session['user'])
            if not user:
                return HttpResponseRedirect('/user/login/')

            usedGoodsList = UsedGoods.objects.filter(user=user)
            usedGoodsNameList = [good.gname for good in usedGoodsList]

            ugname = request.POST.get('ugname', '')
            ugdesc = request.POST.get('ugdesc', '')
            ugprice = request.POST.get('ugprice', '')
            ugimg = request.FILES.get('ugimg', '')
            ugdetail = request.FILES.get('ugdetail', '')

            if len(ugname) > 99:
                return JsonResponse({'success': False, 'error': '商品名称过长'})
            elif ugname in usedGoodsNameList:
                return JsonResponse({'success': False, 'error': '商品名称重合'})
            if len(ugdesc) > 99:
                return JsonResponse({'success': False, 'error': '商品详情描述过长'})
            if not check_price(ugprice):
                return JsonResponse({'success': False, 'error': '商品价格不合法'})

            usedgood = UsedGoods.objects.create(user_id=user.id, gname=ugname, gdesc=ugdesc, price=ugprice,
                                                category_id=12)
            usedgoodimage1 = default_storage.save(os.path.basename(ugimg.name), ugimg)
            ugdurl1 = '/media/' + usedgoodimage1
            usedgooddetail1 = UsedGoodsDetail.objects.create(ugdurl=ugdurl1, ugdname='1', usedgoods_id=usedgood.id)

            usedgoodimage2 = default_storage.save(os.path.basename(ugdetail.name), ugdetail)
            ugdurl2 = '/media/' + usedgoodimage2
            usedgooddetail2 = UsedGoodsDetail.objects.create(ugdurl=ugdurl2, ugdname='2', usedgoods_id=usedgood.id)

            return JsonResponse({'success': True, 'message': '添加商品成功'})

        elif action == 'modifyusedgood':
            user = jsonpickle.decode(request.session['user'])
            if not user:
                return HttpResponseRedirect('/user/login/')

            # 要修改的商品的id
            ugid = request.POST.get('ugid', '')
            # 要修改的商品
            usedgood = UsedGoods.objects.get(id=ugid)
            # 要修改的商品的旧名
            oldusedgoodname = usedgood.gname
            # 该用户的二手商品列表
            usedGoodsList = UsedGoods.objects.filter(user=user)
            # 该用户的二手商品的名称列表
            usedGoodsoldNameList = [good.gname for good in usedGoodsList]
            usedGoodsnewNameList = [name for name in usedGoodsoldNameList if oldusedgoodname not in name]

            ugname = request.POST.get('ugname', '')
            ugdesc = request.POST.get('ugdesc', '')
            ugprice = request.POST.get('ugprice', '')
            send_ugimg = request.FILES.get('ugimg', '')
            send_ugdetail = request.FILES.get('ugdetail', '')

            if len(ugname) > 99:
                return JsonResponse({'success': False, 'error': '商品名称过长'})
            elif ugname in usedGoodsnewNameList:
                return JsonResponse({'success': False, 'error': '商品名称重合'})
            if len(ugdesc) > 99:
                return JsonResponse({'success': False, 'error': '商品详情描述过长'})
            if not check_price(ugprice):
                return JsonResponse({'success': False, 'error': '商品价格不合法'})

            usedgood.gname = ugname
            usedgood.gdesc = ugdesc
            usedgood.price = ugprice
            usedgood.save()

            ugimg = usedgood.usedgoodsdetail_set.first()
            usedgoodimage1 = default_storage.save(os.path.basename(send_ugimg.name), send_ugdetail)
            ugdurl1 = '/media/' + usedgoodimage1
            ugimg.ugdurl = ugdurl1
            ugimg.save()

            ugdetail = usedgood.usedgoodsdetail_set.all()[1]
            usedgoodimage2 = default_storage.save(os.path.basename(send_ugdetail.name), send_ugdetail)
            ugdurl2 = '/media/' + usedgoodimage2
            ugdetail.ugdurl = ugdurl2
            ugdetail.save()

            return JsonResponse({'success': True, 'message': '修改商品成功'})

        elif action == 'deleteusedgood':
            user = jsonpickle.decode(request.session['user'])
            if not user:
                return HttpResponseRedirect('/user/login/')

            # 要修改的商品的id
            ugid = request.POST.get('ugid', '')
            usedgood = UsedGoods.objects.get(id=ugid)
            if not usedgood.getOrderStatus():
                return JsonResponse({'success': False, 'message': '有未支付订单！'})

            UsedGoods.objects.filter(id=ugid).update(isdelete=True)

            return JsonResponse({'success': True, 'message': '删除商品成功'})

        elif action == 'upusedgood':
            user = jsonpickle.decode(request.session['user'])
            if not user:
                return HttpResponseRedirect('/user/login/')

            # 要修改的商品的id
            ugid = request.POST.get('ugid', '')
            UsedGoods.objects.filter(id=ugid).update(isdelete=False)

            return JsonResponse({'success': True, 'message': '重新上架二手商品成功！'})
