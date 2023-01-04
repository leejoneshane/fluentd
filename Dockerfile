FROM fluent/fluentd

ADD grok /fluentd/grok

RUN apk add --no-cache geoip mc libmaxminddb \
    && apk add --no-cache --update --virtual .build-deps sudo build-base ruby-dev geoip-dev libmaxminddb-dev \
    && gem install \
        fluent-plugin-elasticsearch \
        fluent-plugin-rewrite-tag-filter \
        fluent-plugin-grok-parser \
        fluent-plugin-geoip \
    && gem sources --clear-all \
    && apk del .build-deps \
    && rm -rf /home/fluent/.gem/ruby/2.4.0/cache/*.gem \
    && mkdir /fluentd/buffer

COPY /etc/fluent.conf /fluentd/etc/
