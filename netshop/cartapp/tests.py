from django.test import TestCase

class IndexPageTest(TestCase):
    def test_index_page(self):
        response = self.client.post('/cart/',{})

# Create your tests here.
