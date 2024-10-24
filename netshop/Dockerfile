FROM python:3.12
LABEL authors="Cirno"

RUN sed -i s/deb.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list.d/debian.sources

RUN apt-get update
RUN apt-get install -y gcc g++
RUN apt-get install -y vim

RUN mkdir -p /usr/src/app/djtest

COPY . /usr/src/app/djtest

WORKDIR /usr/src/app/djtest

RUN pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple/
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ -r requirements.txt

RUN python manage.py test
RUN if [ $? -eq 0 ]; then \
    echo "========测试通过，继续构建========" ; \
  else \
    echo "=========测试失败=========" && exit 1; \
  fi

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]