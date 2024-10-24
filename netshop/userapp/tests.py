import unittest
from django.test.client import Client

from userapp.views import check_pattern, check_phonenumber, check_price
from userapp.models import UserInfo


class Test(unittest.TestCase):
    def test_check_pattern(self):
        self.assertTrue(check_pattern('aA12-_'))
        self.assertTrue(check_pattern('aaaZZZ666999---___'))

        self.assertFalse(check_pattern('aA 12-_'))
        self.assertFalse(check_pattern('1234_'))
        self.assertFalse(check_pattern('111222333444555666a'))
        self.assertFalse(check_pattern(''))

    def test_check_phonenumber(self):
        self.assertTrue(check_phonenumber('13401010101'))

        self.assertFalse(check_phonenumber('12401010101'))
        self.assertFalse(check_phonenumber('23401010101'))
        self.assertFalse(check_phonenumber('1340101010'))
        self.assertFalse(check_phonenumber('124010101010'))
        self.assertFalse(check_phonenumber('1340101010a'))

    def test_check_price(self):
        self.assertTrue(check_price('1001'))
        self.assertTrue(check_price('99999998.99'))
        self.assertTrue(check_price('0.01'))

        self.assertFalse(check_price('0'))
        self.assertFalse(check_price('-0.00'))
        self.assertFalse(check_price('-100.1'))
        self.assertFalse(check_price('-100.003'))
        self.assertFalse(check_price('-100.a'))
        self.assertFalse(check_price('99999999'))


if __name__ == '__main__':
    unittest.main()
