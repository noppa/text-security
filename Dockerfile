FROM python:3.9.0a5-alpine3.10
ENV PATH="/root/.local/bin:$PATH"
RUN apk update

# Dependencies for t1utils
RUN apk add build-base g++ libxslt-dev libxml2 autoconf automake
# Dependencies for woff2
RUN apk add cmake brotli libbrotlidec

# makeotf, sfntedit, etc.
RUN pip install --user afdko

# Copy submodule dependencies to container.
COPY ./t1utils /t1utils
COPY ./adobe-blank /adobe-blank
COPY ./adobe-blank-2 /adobe-blank-2
COPY ./woff2 /woff2

# Install t1utils for generating pfa file for the font.
WORKDIR /t1utils
RUN autoreconf -i
RUN ./configure
RUN make
RUN make install

# Install woff2
WORKDIR /woff2
RUN mkdir out
WORKDIR /woff2/out
RUN cmake ..
RUN make
RUN make install

WORKDIR /