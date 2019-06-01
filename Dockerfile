FROM python:3.6
LABEL MAINTAINER=hahadaxia
ENV TZ=Asia/Shanghai
#EXPOSE 5000
RUN apt-get update
RUN apt-get install --no-install-recommends -y curl gnupg git  supervisor software-properties-common wget
RUN curl https://openresty.org/package/pubkey.gpg | apt-key add -
RUN add-apt-repository -y "deb http://openresty.org/package/debian $(lsb_release -sc) openresty"
RUN apt-get update

RUN apt-get install -y openresty
COPY ./deploy /webeye/deploy
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r /webeye/deploy/requirements.txt -U
RUN cp /webeye/deploy/nginx/*.conf /usr/local/openresty/nginx/conf/
RUN cp /webeye/deploy/supervisor/*.conf /etc/supervisor/conf.d/
COPY ./api /webeye/api
COPY ./configure /webeye/configure
COPY ./controllers /webeye/controllers
COPY ./utils  /webeye/utils
COPY ./app.py /webeye/app.py
WORKDIR /webeye
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]