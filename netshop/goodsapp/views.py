import json

import jsonpickle
from django.http import JsonResponse, HttpResponseRedirect
from django.shortcuts import render
from django.views import View
from goodsapp.models import Category, Goods, Comment, UsedGoods
from django.core.paginator import Paginator
import math
import jieba
from django.db.models import Count, Q
from datetime import datetime
from django.utils import timezone
from orderapp.models import Order, OrderItem
from shopapp.models import Shop
from collections import Counter
import pytz

from userapp.models import FavoriteGood, UserFootprint, UserInfo


# Create your views here.
class IndexView(View):
    def get(self, request, cid=1, num=1):
        categoryList = Category.objects.all()
        cid = int(cid)
        num = int(num)

        if cid == 12:
            goodsList = UsedGoods.objects.filter(category_id=cid).order_by('category_id')
        else:
            goodsList = Goods.objects.filter(category_id=cid).order_by('category_id')  # category_id是外键字段

        pageinator_obj = Paginator(goodsList, 15)

        page_obj = pageinator_obj.page(num)

        begin = num - int(math.ceil(10.0 / 2))
        if begin < 1:
            begin = 1
        end = begin + 9
        if end > pageinator_obj.num_pages:
            end = pageinator_obj.num_pages

        if end < 10:
            begin = 1
        else:
            begin = end - 9

        page_list = range(begin, end + 1)
        return render(request, 'index.html',
                      {'categoryList': categoryList, 'cid': cid, 'goodsList': page_obj, 'page_list': page_list,
                       'num': num})


def recommend_view(func):
    def _wrapper(detailview, request, goodsid, *args, **kwargs):
        c_goodsid = request.COOKIES.get('rem', '')
        goodsIdList = [gid for gid in c_goodsid.split() if gid.strip()]
        goodsObjList = [Goods.objects.get(id=vgoodid) for vgoodid in goodsIdList if vgoodid != goodsid][:4]
        response = func(detailview, request, goodsid, goodsObjList, *args, **kwargs)
        if goodsid in goodsIdList:
            goodsIdList.remove(goodsid)
            goodsIdList.insert(0, goodsid)
        else:
            goodsIdList.insert(0, goodsid)
        response.set_cookie('rem', ' '.join(goodsIdList), max_age=3 * 24 * 60 * 60)
        return response

    return _wrapper


class DetailView(View):
    @recommend_view
    def get(self, request, goodsid, recommend_list=[]):
        goodsid = int(goodsid)
        try:
            goods = Goods.objects.get(id=goodsid)
        except Goods.DoesNotExist:
            return render(request, 'error.html', {'message': 'Goods not found'})  # 处理当前商品不存在的情况

        addrList = []
        if 'user' not in request.session:
            userid = 0
        else:
            userid = jsonpickle.decode(request.session['user']).id
            user = jsonpickle.decode(request.session['user'])
            addrList = user.address_set.all()

        if FavoriteGood.objects.filter(user_id=userid, good_id=goodsid).exists():  # 已经收藏了改商品
            ifcollect = 1
        else:  # 没有收藏过该商品
            ifcollect = 0

        # 获取商品所属商店
        shop = Goods.objects.get(id=goodsid).shop
        if userid != 0:
            if not UserFootprint.objects.filter(user_id=userid, goods_id=goodsid).exists():
                UserFootprint.objects.create(user_id=userid, goods_id=goodsid)
            else:
                footprint = UserFootprint.objects.get(user_id=userid, goods_id=goodsid)
                footprint.timestamp = timezone.now()
                footprint.save()

        return render(request, 'detail.html',
                      {'goods': goods,
                       'recommend_list': recommend_list,
                       'ifcollect': ifcollect,
                       'shop': shop,
                       'addrList': addrList,
                       'userid':userid
                       })

    def post(self, request, goodsid):
        # 接下来的内容是处理商品收藏
        action = request.POST.get('action', '')
        if action == 'collectgood':
            user = jsonpickle.decode(request.session['user'])
            FavoriteGood.objects.create(user_id=user.id, good_id=goodsid)
            return JsonResponse({'status': 'success', 'message': '收藏成功！'})
        elif action == 'cancelcollectgood':
            user = jsonpickle.decode(request.session['user'])
            FavoriteGood.objects.filter(user_id=user.id, good_id=goodsid).delete()
            return JsonResponse({'status': 'success', 'message': '取消收藏成功！'})

        # 下面是切换评论或者商品详情
        type = request.POST.get('type', 'details')
        goodsid = int(goodsid)
        try:
            goods = Goods.objects.get(id=goodsid)
        except Goods.DoesNotExist:
            return render(request, 'error.html', {'message': 'Goods not found'})  # 处理当前商品不存在的情况

        if type == 'details':
            return render(request, 'detail/displayDetail.html', {'goods': goods})
        elif type == 'comments':
            comments = Comment.objects.filter(goods=goods)
            try:
                user = jsonpickle.decode(request.session['user'])
                # 查询该用户是否购买过该商品
                orders = Order.objects.filter(user=user).exclude(status='待支付')
                order_items = OrderItem.objects.filter(order__in=orders, goodsid=goodsid)

                isbuy = order_items.exists()
            except Exception:
                isbuy = False
                print("Not logged in")
            return render(request, 'detail/displayComment.html', {'comments': comments, 'isbuy': isbuy})


class usedGoodDetailView(View):
    def get(self, request, ugid):
        addrList = []
        if 'user' not in request.session:
            userid = 0
        else:
            userid = jsonpickle.decode(request.session['user']).id
            user = jsonpickle.decode(request.session['user'])
            addrList = user.address_set.all()

        usedgood = UsedGoods.objects.get(id=ugid)
        good_owner = UserInfo.objects.get(id=usedgood.user_id)

        return render(request, 'usedgoodDetail.html', {
            'usedgood': usedgood,
            'good_hoster': good_owner,
            'userid': userid,
            'addrList': addrList})

    def post(self, requset):
        pass


class SearchView(View):
    def get(self, request):
        # 只有从搜索框发出的请求用GET
        type = request.GET.get('type', 'goods')
        final_results = self.order_by_count(request)
        return render(request, 'search/searchRes.html', {'results': final_results, 'type': type,
                                                         'searchContent': request.GET.get('searchContent', '')})

    def post(self, request):
        # 更换不同排序都用POST请求
        sort = request.POST.get('sort', '')
        type = request.POST.get('type', 'goods')
        print(sort)
        final_results = []
        if sort == 'aec' or sort == 'desc':
            final_results = self.order_by_price(request)
        elif sort == 'sales':
            final_results = self.order_by_sales(request)
        elif sort == 'rating':
            final_results = self.order_by_rating(request)
        elif sort == 'fan-num':
            final_results = self.order_by_fan_num(request)
        else:
            try:
                final_results = jsonpickle.decode(request.session['results'])
            except Exception:
                final_results = []

        if type == 'shops':
            return render(request, 'search/shopRes.html', {'results': final_results, 'type': type})
        else:
            return render(request, 'search/goodRes.html', {'results': final_results, 'type': type})

    def order_by_count(self, request):
        type = request.GET.get('type', 'goods')
        content = request.GET.get('searchContent', '')
        # 使用 jieba 对搜索关键词进行分词处理
        search_terms = list(jieba.cut_for_search(content))
        final_results = []
        # 判断搜索类型
        if type == 'goods':
            combined_results = []
            print("==============================================================")
            for term in search_terms:
                results1 = Goods.objects.filter(Q(gname__icontains=term), isdelete=False)
                results2 = Goods.objects.filter(Q(gdesc__icontains=term), isdelete=False)
                results3 = Goods.objects.filter(Q(category__cname__icontains=term), isdelete=False)
                results4 = UsedGoods.objects.filter(Q(gname__icontains=term), isdelete=False)
                results5 = UsedGoods.objects.filter(Q(gdesc__icontains=term), isdelete=False)
                results6 = UsedGoods.objects.filter(Q(category__cname__icontains=term), isdelete=False)

                # 合并结果，不去重
                combined_results += list(results1) + list(results2) + list(results3) + list(results4) + list(
                    results5) + list(results6)
            # 统计重复次数
            results_counter = Counter(combined_results)
            # 按重复次数排序
            sorted_results = sorted(results_counter.items(), key=lambda x: x[1], reverse=True)
            # 获取去重后的结果列表
            for result, count in sorted_results:
                final_results.append(result)
        elif type == 'shops':
            combined_results = []
            for term in search_terms:
                results = Shop.objects.filter(Q(sname__icontains=term))
                combined_results += list(results)
            results_counter = Counter(combined_results)
            sorted_results = sorted(results_counter.items(), key=lambda x: x[1], reverse=True)
            for result, count in sorted_results:
                final_results.append(result)
        # 将结果保存到上下文
        request.session['results'] = jsonpickle.encode(final_results)
        request.session['lastSearchType'] = type
        return final_results

    def order_by_price(self, request):
        # 只有在使用搜索栏的时候使用这个函数
        sort = request.POST.get('sort', '')
        results = jsonpickle.decode(request.session['results'])
        if sort == 'desc':
            final_results = sorted(results, key=lambda x: x.price, reverse=True)
        else:
            final_results = sorted(results, key=lambda x: x.price)
        return final_results

    def order_by_sales(self, request):
        results = jsonpickle.decode(request.session['results'])
        if request.POST.get('type', 'goods') == 'shops':
            final_results = sorted(results, key=lambda x: x.getTotalSalesVolume(), reverse=True)
            return final_results
        else:
            final_results = sorted(results, key=lambda x: x.getSalesVolume(), reverse=True)
            return final_results

    def order_by_rating(self, request):
        results = jsonpickle.decode(request.session['results'])
        if request.POST.get('type', 'goods') == 'shops':
            final_results = sorted(results, key=lambda x: x.rating, reverse=True)
            return final_results
        else:
            final_results = sorted(results, key=lambda x: x.getRating(), reverse=True)
            return final_results

    def order_by_fan_num(self, request):
        results = jsonpickle.decode(request.session['results'])
        final_results = sorted(results, key=lambda x: x.fan_num, reverse=True)
        return final_results


class CommentView(View):
    def post(self, request, goodsid):
        goodsid = int(goodsid)
        rating = int(request.POST.get('rating', '1'))
        content = request.POST.get('content', '')
        # 保证用户已经登录，未登录的用户不能评论
        user = jsonpickle.decode(request.session['user'])
        shanghai_tz = pytz.timezone('Asia/Shanghai')
        current_time = datetime.now(shanghai_tz)

        comment = Comment.objects.create(user=user, content=content, rating=rating, date=current_time, goods_id=goodsid)
        comment.save()

        # 更新商店的评分
        Goods.objects.get(id=goodsid).shop.updateRating()

        return JsonResponse({'success': True})
