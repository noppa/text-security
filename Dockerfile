FROM nikolaik/python-nodejs:python3.8-nodejs12-alpine
ENV PATH="/root/.local/bin:$PATH"
RUN apk update
RUN apk add build-base g++ libxslt-dev libxml2 autoconf automake
ADD . /workdir
WORKDIR /workdir
RUN pip install --user afdko
RUN ls
WORKDIR /workdir/t1utils
RUN autoreconf -i
RUN ./configure
RUN make
RUN make install
WORKDIR /workdir