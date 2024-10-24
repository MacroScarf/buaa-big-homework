import json
import math
import os
import re

import jsonpickle
from django.core.files.storage import default_storage
from django.core.paginator import Paginator
from django.http import JsonResponse
from django.shortcuts import render
from django.views import View
from django.core import serializers
from goodsapp.models import Category, Goods, Color, Size, Inventory, GoodsDetailName, GoodDetail
from orderapp.models import OrderItem
from shopapp.models import Shop
from userapp.models import FollowShop


class ShopView(View):
    def get(self, request, shopid=1, num=1):
        categoryList = Category.objects.all()
        shop = Shop.objects.get(id=shopid)
        shoper = shop.getUserInfo()  # 这个是店主
        if 'user' not in request.session:
            userid = 0
        else:
            userid = jsonpickle.decode(request.session['user']).id

        if userid == shoper.id:  # 面对用户自己的店铺
            ifsameorfollow = 0
        else:  # 面对别人的店铺
            if FollowShop.objects.filter(user_id=userid, shop_id=shopid).exists():  # 已经收藏过了
                ifsameorfollow = 1
            else:  # 还没有收藏过
                ifsameorfollow = 2

        goodsList = shop.getGoods()

        num = int(num)
        paginator_obj = Paginator(goodsList, 15)
        page_obj = paginator_obj.page(num)
        begin = num - int(math.ceil(10.0 / 2))
        if begin < 1:
            begin = 1
        end = begin + 9
        if end > paginator_obj.num_pages:
            end = paginator_obj.num_pages
        if end < 10:
            begin = 1
        else:
            begin = end - 9
        page_list = range(begin, end + 1)

        return render(request, 'shop.html', {
            'shop': shop, 'goodsList': page_obj,
            'page_list': page_list, 'num': num, 'userid': userid,
            'categoryList': categoryList, 'IfSameOrFollow': ifsameorfollow
        })

    def post(self, request, shopid=1):
        action = request.POST.get('action', '')
        if action == 'favoriteshop':
            if 'user' not in request.session:
                return JsonResponse({'success': False, 'error': '未登录，请先登录！'})

            user = jsonpickle.decode(request.session['user'])
            shop_user_id = Shop.objects.get(id=shopid).getUserInfo().id

            if user.id == shop_user_id:
                return JsonResponse({'success': False, 'error': '收藏失败,不能收藏自己的店铺！'})
            else:
                if FollowShop.objects.filter(user_id=user.id, shop_id=shopid).exists():

                    return JsonResponse({'success': False, 'error': '已经收藏过，不能再收藏！'})
                else:
                    FollowShop.objects.create(user_id=user.id, shop_id=shopid)
                    f = Shop.objects.get(id=shopid).fan_num
                    Shop.objects.filter(id=shopid).update(fan_num=f + 1)

                    return JsonResponse({'success': True, 'message': '收藏成功！'})

        elif action == 'cancelfavoriteshop':
            if 'user' not in request.session:
                return JsonResponse({'success': False, 'error': '出现错误！'})

            user = jsonpickle.decode(request.session['user'])
            FollowShop.objects.filter(user_id=user.id, shop_id=shopid).delete()
            f = Shop.objects.get(id=shopid).fan_num
            Shop.objects.filter(id=shopid).update(fan_num=f - 1)

            return JsonResponse({'success': True, 'message': '取消关注成功！'})

        elif action == 'addgood':
            #TODO
            #防护攻击，需要判断发送请求的人是不是店主
            gname = request.POST.get('gname', '')
            gdesc = request.POST.get('gdesc', '')
            oldprice = request.POST.get('oldprice', '')
            price = request.POST.get('price', '')
            categoryname = request.POST.get('category', '')

            shopid = request.POST.get('shopid', '')  # 商店id
            shop = Shop.objects.get(id=shopid)  # 商店实例
            user = jsonpickle.decode(request.session['user'])  # 店主实例

            goodimage = request.FILES.get('goodimage', '')
            colorname = request.POST.get('colorname', '')
            count = request.POST.get('count', '')
            sizename = request.POST.get('size', '')

            detailnum = request.POST.get('detailnum')
            detailname1 = request.POST.get('detailname1', '')
            detailname2 = request.POST.get('detailname2', '')
            detailname3 = request.POST.get('detailname3', '')

            if detailnum == '1':
                if detailname1 == '':
                    return JsonResponse({'success': False, 'error': '有商品详情名为空！'})
                elif len(detailname1) >= 10:
                    return JsonResponse({'success': False, 'error': '商品详情名过长！'})
            elif detailnum == '2':
                if detailname1 == '' or detailname2 == '':
                    return JsonResponse({'success': False, 'error': '有商品详情名为空！'})
                elif len(detailname1) >= 10 or len(detailname2) >= 10:
                    return JsonResponse({'success': False, 'error': '商品详情名过长！'})
            elif detailnum == '3':
                if detailname1 == '' or detailname2 == '' or detailname3 == '':
                    return JsonResponse({'success': False, 'error': '有商品详情名为空！'})
                elif len(detailname1) >= 10 or len(detailname2) >= 10 or len(detailname3) >= 10:
                    return JsonResponse({'success': False, 'error': '商品详情名过长！'})

            goodsdetailimage1 = request.FILES.get('goodimage1', '')
            goodsdetailimage2 = request.FILES.get('goodimage2', '')
            goodsdetailimage3 = request.FILES.get('goodimage3', '')

            if not gname:
                return JsonResponse({'success': False, 'error': '商品名称不能为空'})
            if Goods.objects.filter(gname=gname, isdelete=False).exists():
                return JsonResponse({'success': False, 'error': '商品名称已存在'})
            if len(gname) > 40:
                return JsonResponse({'success': False, 'error': '商品名称过长'})

            if not gdesc:
                return JsonResponse({'success': False, 'error': '商品详情描述不能为空'})
            if len(gdesc) > 50:
                return JsonResponse({'success': False, 'error': '商品详情描述过长'})

            pattern = re.compile(r'^\d+(\.\d{1,2})?$')

            if not oldprice:
                return JsonResponse({'success': False, 'error': '原价不能为空'})
            if not pattern.match(oldprice) or float(oldprice) <= 0:
                return JsonResponse({'success': False, 'error': '请输入有效的原价'})
            if float(oldprice) > 9999999.99:
                return JsonResponse({'success': False, 'error': '原价过大'})

            if not price:
                return JsonResponse({'success': False, 'error': '现价不能为空'})
            if not pattern.match(price) or float(price) <= 0:
                return JsonResponse({'success': False, 'error': '请输入有效的现价'})
            if float(price) > 9999999.99:
                return JsonResponse({'success': False, 'error': '现价过大'})
            if float(price) >= float(oldprice):
                return JsonResponse({'success': False, 'error': '现价需要小于原价'})

            if not user:
                return JsonResponse({'success': False, 'error': 'User not authenticated'})

            if not colorname:
                return JsonResponse({'success': False, 'error': '默认款式不能为空'})
            if len(colorname) > 9:
                return JsonResponse({'success': False, 'error': '款式名称过长'})

            if not sizename:
                return JsonResponse({'success': False, 'error': '规格不能为空'})
            if len(sizename) > 36:
                return JsonResponse({'success': False, 'error': '规格名称过长！'})
            sizenamelist = sizename.split()
            if len(sizenamelist) > 5:
                return JsonResponse({'success': False, 'error': '规格数量过多！最多不超过4个规格！'})

            def check_string_lengths(lst):
                for string in lst:
                    if len(string) > 9:
                        return False
                return True

            if not check_string_lengths(sizenamelist):
                return JsonResponse({'success': False, 'error': '某个规格名称过长！最多不超过9个字符！'})

            def has_duplicates(lst):
                return len(lst) == len(set(lst))

            if not has_duplicates(sizenamelist):
                return JsonResponse({'success': False, 'error': '有相同的规格名称！'})

            if not count:
                return JsonResponse({'success': False, 'error': '库存不能为空'})
            if not count.isdigit() or int(count) <= 0:
                return JsonResponse({'success': False, 'error': '库存输入错误，只能是正整数'})
            if int(count) > 9999999:
                return JsonResponse({'success': False, 'error': '库存过大'})

            if goodimage:
                file_name = default_storage.save('color/' + os.path.basename(goodimage.name), goodimage)
                colorurl = '/media/' + file_name
                color = Color.objects.create(colorname=colorname, colorurl=colorurl)
                category = Category.objects.get(cname=categoryname)
                good = Goods.objects.create(gname=gname, gdesc=gdesc, price=price, oldprice=oldprice, category=category,
                                            shop=shop)
                sizelist = [Size.objects.create(sname=sizename) for sizename in sizenamelist]
                inventorylist = [
                    Inventory.objects.create(size_id=size.id, goods_id=good.id, count=count, color_id=color.id) for size
                    in sizelist]

                if detailnum == '1':
                    goodsdetailname1 = GoodsDetailName.objects.create(gdname=detailname1)
                    detailimagename1 = default_storage.save(os.path.basename(goodsdetailimage1.name), goodsdetailimage1)
                    gdurl1 = '/media/' + detailimagename1
                    gooddetail1 = GoodDetail.objects.create(gdurl=gdurl1, goodsdname_id=goodsdetailname1.id,
                                                            goods_id=good.id)
                elif detailnum == '2':
                    goodsdetailname1 = GoodsDetailName.objects.create(gdname=detailname1)
                    detailimagename1 = default_storage.save(os.path.basename(goodsdetailimage1.name), goodsdetailimage1)
                    gdurl1 = '/media/' + detailimagename1
                    gooddetail1 = GoodDetail.objects.create(gdurl=gdurl1, goodsdname_id=goodsdetailname1.id,
                                                            goods_id=good.id)
                    goodsdetailname2 = GoodsDetailName.objects.create(gdname=detailname2)
                    detailimagename2 = default_storage.save(os.path.basename(goodsdetailimage2.name), goodsdetailimage2)
                    gdurl2 = '/media/' + detailimagename2
                    gooddetail2 = GoodDetail.objects.create(gdurl=gdurl2, goodsdname_id=goodsdetailname2.id,
                                                            goods_id=good.id)
                elif detailnum == '3':
                    goodsdetailname1 = GoodsDetailName.objects.create(gdname=detailname1)
                    detailimagename1 = default_storage.save(os.path.basename(goodsdetailimage1.name), goodsdetailimage1)
                    gdurl1 = '/media/' + detailimagename1
                    gooddetail1 = GoodDetail.objects.create(gdurl=gdurl1, goodsdname_id=goodsdetailname1.id,
                                                            goods_id=good.id)

                    goodsdetailname2 = GoodsDetailName.objects.create(gdname=detailname2)
                    detailimagename2 = default_storage.save(os.path.basename(goodsdetailimage2.name), goodsdetailimage2)
                    gdurl2 = '/media/' + detailimagename2
                    gooddetail2 = GoodDetail.objects.create(gdurl=gdurl2, goodsdname_id=goodsdetailname2.id,
                                                            goods_id=good.id)

                    goodsdetailname3 = GoodsDetailName.objects.create(gdname=detailname3)
                    detailimagename3 = default_storage.save(os.path.basename(goodsdetailimage3.name), goodsdetailimage3)
                    gdurl3 = '/media/' + detailimagename3
                    gooddetail3 = GoodDetail.objects.create(gdurl=gdurl3, goodsdname_id=goodsdetailname3.id,
                                                            goods_id=good.id)

                return JsonResponse({'success': True, 'message': '添加商品成功'})
            else:
                return JsonResponse({'success': False, 'error': '添加商品失败'})

        elif action == 'deletegood':
            goodsid = int(request.POST.get('goodsid', '0'))
            goodObj = Goods.objects.get(id=goodsid)
            if not goodObj:
                return JsonResponse({'success': False, 'error': '商品不存在'})
            if goodObj.isdelete:
                return JsonResponse({'success': False, 'error': '商品已下架'})
            flag = False
            orderItems = OrderItem.objects.filter(goodsid=goodsid)
            if orderItems.exists():
                for oi in orderItems:
                    if oi.order.status == '未支付':
                        flag = True
                        break

            if flag:
                # 有未支付订单
                return JsonResponse({'success': False, 'error': '顾客有未支付订单'})
            else:
                goodObj.isdelete = True
                goodObj.isHot = False
                goodObj.save()

                # 清空库存
                inventorylist = Inventory.objects.filter(goods=goodObj)
                for inventory in inventorylist:
                    inventory.count = 0
                    inventory.save()

                # 更新 cookies
                c_goodsid = request.COOKIES.get('rem', '')
                goodsIdList = [gid for gid in c_goodsid.split() if gid.strip() and gid != str(goodsid)]
                response = JsonResponse({'success': True, 'message': '删除成功'})
                response.set_cookie('rem', ' '.join(goodsIdList), max_age=3 * 24 * 60 * 60)
                return response

        elif action == 'setHotgood':
            goodsid = int(request.POST.get('goodsid', '0'))
            goodObj = Goods.objects.get(id=goodsid)
            if not goodObj:
                return JsonResponse({'success': False, 'error': '商品不存在'})
            if goodObj.isHot:
                goodObj.isHot = False
                goodObj.save()
                return JsonResponse({'success': True, 'message': '取消热门商品成功', 'set': False})
            if Goods.objects.filter(shop=goodObj.shop, isHot=True).count() >= 4:
                return JsonResponse({'success': False, 'error': '该商店的热门商品数不能超过4个'})
            goodObj.isHot = True
            goodObj.save()
            return JsonResponse({'success': True, 'message': '设置热门商品成功', 'set': True})

        elif action == 'requestModify':
            # 修改商品时前端申请获取选择商品的一些款式、规格、库存信息
            goodsid = int(request.POST.get('goodsid', '0'))
            goodObj = Goods.objects.get(id=goodsid)
            if not goodObj:
                return JsonResponse({'success': False, 'error': '商品不存在'})
            inventorylist = Inventory.objects.filter(goods=goodObj)
            if not inventorylist:
                return JsonResponse({'success': False, 'error': '款式或规格不存在'})
            inventorylist_array = []
            size_array = []  # 规格表
            color_array = []  # 款式表

            for item in inventorylist:
                size = item.size.sname
                color = item.color.colorname
                count = item.count
                inventorylist_array.append({'size': size, 'color': color, 'count': count})
                if size not in size_array:
                    size_array.append(size)
                if color not in color_array:
                    color_array.append(color)

            inventorylist_array = json.dumps(inventorylist_array, ensure_ascii=False)
            size_array = json.dumps(size_array, ensure_ascii=False)
            color_array = json.dumps(color_array, ensure_ascii=False)

            return JsonResponse({'success': True, 'message': '获取商品数据成功', 'inventorylist': inventorylist_array,
                                 'colorlist': color_array, 'sizelist': size_array})

        elif action == 'modifygood':
            # 修改商品
            goodsid = int(request.POST.get('goodsid'))
            newGname = request.POST.get('newGname')
            newGdsec = request.POST.get('newGdsec')
            newPrice = request.POST.get('newPrice')
            newInventory = request.POST.get('newInventory')
            modifyColor = request.POST.get('modifyColor')
            modifySize = request.POST.get('modifySize')
            goodObj = Goods.objects.get(id=goodsid)

            if not goodObj:
                return JsonResponse({'success': False, 'error': '商品不存在'})

            pattern = re.compile(r'^\d+(\.\d{1,2})?$')

            if newPrice:
                if not pattern.match(newPrice) or float(newPrice) <= 0:
                    return JsonResponse({'success': False, 'error': '请输入有效的现价'})
                if float(newPrice) > 9999999.99:
                    return JsonResponse({'success': False, 'error': '现价过大'})

            if newInventory:
                if not newInventory.isdigit() or int(newInventory) <= 0:
                    return JsonResponse({'success': False, 'error': '新库存输入错误，只能是正整数'})
                if int(newInventory) > 9999999:
                    return JsonResponse({'success': False, 'error': '新库存过大'})

            if len(newGname) > 40:
                return JsonResponse({'success': False, 'error': '商品名称过长'})
            if Goods.objects.filter(gname=newGname, isdelete=False).exists():
                return JsonResponse({'success': False, 'error': '商品名称已存在'})

            # 修改
            if newGname:
                goodObj.gname = newGname
            if newGdsec:
                goodObj.gdesc = newGdsec
            if newPrice:
                goodObj.oldprice = goodObj.price
                goodObj.price = newPrice
            if newInventory:
                if not modifyColor:
                    return JsonResponse({'success': False, 'error': '修改库存时要选择款式'})
                if not modifySize:
                    return JsonResponse({'success': False, 'error': '修改库存时要选择规格'})

                inventory = Inventory.objects.get(goods=goodObj, color__colorname=modifyColor, size__sname=modifySize)
                inventory.count = int(newInventory)
                inventory.save()
            goodObj.save()

            return JsonResponse({'success': True, 'message': '修改成功'})

        elif action == 'addColor':
            goodsid = int(request.POST.get('goodsid'))
            goodObj = Goods.objects.get(id=goodsid)
            if not goodObj:
                return JsonResponse({'success': False, 'error': '商品不存在'})

            new_color = request.POST.get('newColor')
            count = request.POST.get('count')
            img = request.FILES.get('colorImg')
            if not count.isdigit() or int(count) <= 0:
                return JsonResponse({'success': False, 'error': '库存只能为正整数'})
            if int(count) > 9999999:
                return JsonResponse({'success': False, 'error': '新库存过大'})

            if not img:
                return JsonResponse({'success': False, 'error': '请上传图片'})
            if Inventory.objects.filter(goods=goodObj, color__colorname=new_color):
                return JsonResponse({'success': False, 'error': '该款式已存在'})
            file_name = default_storage.save('color/' + os.path.basename(img.name), img)
            colorurl = '/media/' + file_name
            color = Color.objects.create(colorname=new_color, colorurl=colorurl)

            # 获取其中一个款式，然后就可以获得商品对应的所有规格了
            first_inventory = Inventory.objects.filter(goods=goodObj).first()
            first_color = first_inventory.color

            for item in Inventory.objects.filter(goods=goodObj, color=first_color):
                Inventory.objects.create(goods=goodObj, color=color, size=item.size, count=int(count))

            return JsonResponse({'success': True, 'message': '添加款式成功'})
