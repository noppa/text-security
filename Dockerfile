FROM python:3.9.0a5-alpine3.10
ENV PATH="/root/.local/bin:$PATH"
RUN apk update
RUN apk add build-base g++ libxslt-dev libxml2 autoconf automake
RUN pip install --user afdko

# Copy submodule dependencies to container.
COPY ./t1utils /t1utils
COPY ./adobe-blank /adobe-blank
COPY ./adobe-blank-2 /adobe-blank-2

# Install t1utils for generating pfa file for the font.
WORKDIR /t1utils
RUN autoreconf -i
RUN ./configure
RUN make
RUN make install

WORKDIR /