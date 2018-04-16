FROM ubuntu:16.04
LABEL maintainer="Michael Lynch <michael@mtlynch.io>"

ARG CRFPP_REPO=https://github.com/mtlynch/crfpp.git
ARG TAGGER_REPO=https://github.com/mtlynch/ingredient-phrase-tagger.git

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y build-essential git python2.7 python-pip

RUN git clone "$CRFPP_REPO" && \
    cd crfpp && \
    ./configure && \
    make && \
    make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf && \
    ldconfig && \
    cd ..

RUN git clone "$TAGGER_REPO" && \
    cd ingredient-phrase-tagger && \
    python setup.py install && \
    cd ..

# Clean up.
RUN rm -rf /var/lib/apt/lists/* && \
    rm -Rf /usr/share/doc && \
    rm -Rf /usr/share/man && \
    apt-get autoremove -y && \
    apt-get clean

WORKDIR /app
