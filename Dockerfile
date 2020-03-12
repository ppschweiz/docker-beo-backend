FROM python:3.5-slim-buster

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		git \
		gnupg \
		dirmngr \
	; \
	rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/ppschweiz/python-civicrm
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		liblcms2-dev \
		libtiff5-dev \
		libwebp-dev \
		tcl8.6-dev \
		tk8.6-dev \
		zlib1g-dev \
	; \
	cd python-civicrm; \
	python3 setup.py install; \
	rm -rf /var/lib/apt/lists/*

RUN git clone -b 17.04 https://github.com/ppschweiz/ekklesia.git
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		gcc \
	; \
	make -C ekklesia install; \
	apt-get purge -y --auto-remove gcc; \
	rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/ppschweiz/python-civi
RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		gcc \
		libmariadb-dev \
		libpq-dev \
	; \
	pip install pymysql psycopg2; \
	apt-get purge -y --auto-remove gcc; \
	rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
COPY run-once.sh /run-once.sh
COPY push.sh /push.sh
COPY init.sh /init.sh
COPY static.sh /static.sh
COPY ekklesia.ini /ekklesia.ini

CMD ["/run.sh"]
