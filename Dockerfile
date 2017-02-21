FROM ubuntu:16.04

RUN echo "A1"
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y python-pip python-dev build-essential git libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk
RUN pip install --upgrade pip
RUN git clone https://github.com/tallus/python-civicrm
RUN cd python-civicrm && python setup.py install
RUN echo "B5"
RUN git clone https://github.com/edemocracy/ekklesia
RUN cd ekklesia && make install
RUN git clone https://github.com/ppschweiz/python-civi
COPY run.sh /run.sh
COPY ekklesia.ini.template /ekklesia.ini.template
CMD ["/run.sh"]

