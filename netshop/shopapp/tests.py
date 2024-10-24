# Create your tests here.
import jsonpickle
from django.test import TestCase
import django.test.client
from shopapp.models import Shop
from userapp.models import UserInfo
import json
from django.test.client import Client


class RegisterTest(TestCase):

    def setUp(self):
        user = UserInfo.objects.create(uname='12345', pwd='10086111', uidentity='student')
        Shop.objects.create(sname='Taoduoduo', slogourl='', user=user)
        self.client = Client()

    def test_get_shop(self):
        response = self.client.get('/shop/1/shopdetail/')
        self.assertEqual(response.context['IfSameOrFollow'], 2)
        self.assertEqual(response.context['userid'], 0)

    def test_post_shop(self):
        client = django.test.client.Client()
        post_data = {
            'sname': 'Taoduoduo',
            'action': 'favoriteshop',
        }
        user = UserInfo.objects.get(uname='12345')
        self.client.session['user'] = jsonpickle.encode(user)
        response = client.post('/shop/1/shopdetail/', data=post_data)
        content = json.loads(response.content)
        self.assertFalse(content['success'])
        self.assertEqual(content['error'], '未登录，请先登录！')
