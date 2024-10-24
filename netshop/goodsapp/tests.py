import jsonpickle
from django.test import TestCase
import django.test.client
import json
from django.test.client import Client
from goodsapp.views import format_num

# Create your tests here.

class GoodsTest(TestCase):
    def setUp(self):
        self.client = Client()


    def test_format_num(self):
        self.assertEqual(format_num(50),'50')
        self.assertNotEquals(format_num(50),'50+')
        self.assertEqual(format_num(120),'100+')
        self.assertNotEquals(format_num(120), '120')
        self.assertEqual(format_num(1200),'1000+')
        self.assertNotEquals(format_num(1200), '1200')

    def test_detailview_get(self):
        response = self.client.get('/goods/goodsdetails/2/')
        self.assertEqual(response.status_code, 404)
