FROM python:3.9.0a5-alpine3.10
ENV PATH="/root/.local/bin:$PATH"
RUN apk update

RUN apk add build-base g++ libxslt-dev libxml2 autoconf automake woff2

# Copy submodule dependencies to container.
COPY ./t1utils /t1utils
COPY ./ttf2eot /ttf2eot
COPY ./adobe-blank-2 /adobe-blank-2
COPY ./adobe-notdef /adobe-notdef

# makeotf, sfntedit, etc.
RUN pip install --user afdko

RUN pip install --user cssmin

# Install t1utils for generating pfa file for the font.
WORKDIR /t1utils
RUN autoreconf -i
RUN ./configure
RUN make
RUN make install

WORKDIR /ttf2eot
RUN make

WORKDIR /