FROM ubuntu:15.10

RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y python-pip python-dev build-essential
RUN apt-get install -y git
RUN git clone https://github.com/tallus/python-civicrm
RUN cd python-civicrm && python setup.py install
RUN git clone https://github.com/edemocracy/ekklesia
RUN apt-get install -y libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tK
RUN cd ekklesia && make install
Run ps
RUN git clone https://github.com/ppschweiz/python-civi

COPY run.sh /run.sh
COPY members.ini.template /etc/members.ini.template
COPY invitations.ini.template /etc/invitations.ini.template
CMD ["/run.sh"]

