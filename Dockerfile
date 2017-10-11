FROM openresty/openresty:alpine-fat

RUN apk add --update icu-dev
RUN luarocks install busted

RUN mkdir /app
WORKDIR /app
COPY . /app
