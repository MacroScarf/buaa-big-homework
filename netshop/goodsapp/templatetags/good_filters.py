
import pytz
from django import template

register = template.Library()


# 用来将评论中用户的名字的后四个字符替换成*号
@register.filter(name='mask_username')
def mask_username(value):
    if len(value) > 4:
        return value[:-4] + '****'
    else:
        return '****'  # 如果用户名长度不足四位，就全部用 '*' 代替


# 用来将评论的rating转化为可迭代对象
@register.filter(name='star_range')
def star_range(value):
    return range(value)


# 用来将评论（5-rating）转化为可迭代对象
@register.filter(name='unstar_range')
def unstar_range(value, total=5):
    return range(total - value)


# 将时间转化为中文版
@register.filter(name='chinese_date')
def chinese_date(value):
    shanghai_tz = pytz.timezone('Asia/Shanghai')
    local_time = value.astimezone(shanghai_tz)
    return local_time.strftime('%Y年%m月%d日 %H:%M:%S')

# 对数字进行模糊处理，比如150显示成100+
@register.filter(name='format_num')
def format_num(value):
    if value < 100:
        return str(value)
    elif value < 1000:
        return f"{value // 100 * 100}+"
    else:
        return f"{value // 1000 * 1000}+"
