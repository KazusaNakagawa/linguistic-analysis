FROM ubuntu:20.04

ENV PYTHON_VERSION=3.9.5
ENV MECAB_VERSION=0.996
ENV IPADIC_VSERSION=20070801

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential  \
    libbz2-dev  \
    libdb-dev \
    libffi-dev  \
    libgdbm-dev  \
    liblzma-dev  \
    libncursesw5-dev  \
    libreadline-dev \
    libsqlite3-dev  \
    libssl-dev  \
    mecab \
    sudo \
    uuid-dev  \
    vim \
    wget  \
    zlib1g-dev

# root権限意外でも扱えるようにする
WORKDIR /opt

# Python: { take_time: 2871.9s }
RUN wget --no-check-certificate https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz && \
    tar -xf Python-$PYTHON_VERSION.tgz &&\
    cd Python-$PYTHON_VERSION && \
     ./configure --enable-optimizations && \
    make && \
    make install &&\
    rm -f /opt/Python-$PYTHON_VERSION.tgz

# MeCab 本体・IPA 辞書
# Ref: https://taku910.github.io/mecab/
# eccape 対応: {「""」 で囲む.}, { ファイル名をつける: mecab-0.996.tar.gz}
RUN wget -O mecab-$MECAB_VERSION.tar.gz \
    --no-check-certificate "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE" && \
    tar zxfv mecab-$MECAB_VERSION.tar.gz
#    tar zxfv mecab-$MECAB_VERSION.tar.gz && \
#    cd mecab-$MECAB_VERSION && \
#    ./configure && \
#    make && \
#    make check && \
#    # su  && \
#    make install && \
#    rm -f mecab-$MECAB_VERSION.tar.gz \

RUN wget -O mecab-ipadic-2.7.0-$IPADIC_VSERSION.tar.gz \
    --no-check-certificate "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM"
# 手動対応 ... make が上手くいかない
#RUN tar zxfv mecab-ipadic-2.7.0-$IPADIC_VSERSION.tar.gz  && \
#    cd mecab-ipadic-2.7.0-$IPADIC_VSERSION && \
#    ./configure --with-charset=utf8
#    sudo make install
#    make && \
#    # su && \
#    make install

# Cabocha

# 不要なものは削除
RUN apt-get autoremove -y

RUN pip3 install --upgrade pip
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .
WORKDIR /

CMD ["/usr/bin/bash"]
