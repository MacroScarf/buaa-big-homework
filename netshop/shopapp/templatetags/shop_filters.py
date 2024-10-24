import pytz
from django import template

register = template.Library()


# 对数字进行模糊处理，比如150显示成100+
@register.filter(name='format_num')
def format_num(value):
    if value < 10:
        return str(value)
    elif value < 100:
        return "10+"
    elif value < 1000:
        return f"{value // 100 * 100}+"
    else:
        return f"{value // 1000 * 1000}+"
