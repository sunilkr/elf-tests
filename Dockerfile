FROM bintest:base

RUN apt-get install -y python3 python3-pip
RUN pip3 install junit-xml

COPY entry.sh test-debug.sh test-release.sh junit.py /usr/local/bin/
RUN chmod +x /usr/local/bin/*

CMD []