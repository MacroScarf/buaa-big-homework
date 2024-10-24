from django.http import HttpResponse, HttpResponseRedirect, JsonResponse
from django.shortcuts import render
from django.views import View

from cartapp.cartmanager import *
import json


# Create your views here.
class CartView(View):
    def post(self, request):
        # 保证数据实时保存到session中
        request.session.modified = True
        # 获取当前用户操作类型变量值
        flag = request.POST.get('flag', '')
        # 判断用户当前操作类型
        if flag == 'add':
            # 获取cartManage对象
            cartManager = getCartManager(request)
            # 加入购物车操作
            cartManager.add(**request.POST.dict())
            return JsonResponse({'success': True})
        elif flag == 'plus':
            cartManager = getCartManager(request)
            # 增加商品数量
            cartManager.update(step=1, **request.POST.dict())
        elif flag == 'minus':
            cartManager = getCartManager(request)
            cartManager.update(step=-1, **request.POST.dict())
        elif flag == 'delete':
            cartManager = getCartManager(request)
            cartManager.delete(**request.POST.dict())
        elif flag == 'judge':
            cartManager = getCartManager(request)
            result = cartManager.judge(**request.POST.dict())
            return JsonResponse(result)
        # 重定向
        return HttpResponseRedirect('/cart/queryAll/')


def queryAll(request):
    if not request.session.get('user'):
        return HttpResponseRedirect('/user/login/')

    # 获取cartManager对象
    cartManager = getCartManager(request)

    # 获取当前登录用户购物项表中的所有信息
    cartItemList = cartManager.queryAll().order_by('-id')

    # 获取当前登录用户的地址信息json数组
    user = jsonpickle.loads(request.session.get('user'))
    addrList = user.address_set.all()
    addrListJson = json.dumps(list(addrList.values_list('id', 'addr')))

    # 传递给模板
    return render(request, 'cart.html', {
        'cartItemList': cartItemList,
        'addrListJson': addrListJson,
    })
