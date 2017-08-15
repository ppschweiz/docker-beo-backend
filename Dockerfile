FROM ubuntu:16.04

RUN echo "A2"
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y python3-pip python-pip python-dev build-essential git libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk
RUN pip install --upgrade pip
RUN echo "C1"
RUN git clone https://github.com/ppschweiz/python-civicrm
RUN cd python-civicrm && python3 setup.py install
RUN echo "B10"
#RUN git clone https://github.com/edemocracy/ekklesia
RUN git clone https://github.com/edemocracy/ekklesia && cd ekklesia && git reset --hard 2f55224885429c3be68d83ef4a5d5b98a85c43f6
RUN cd ekklesia && make install
RUN git clone https://github.com/ppschweiz/python-civi
RUN pip install pymysql psycopg2
COPY run.sh /run.sh
COPY push.sh /push.sh
COPY init.sh /init.sh
COPY ekklesia.ini.template /ekklesia.ini.template
CMD ["/run.sh"]

