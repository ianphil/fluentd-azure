FROM fluent/fluentd

USER root

# below RUN includes two plugins as examples
# elasticsearch and record-reformer are not required
# you may customize including plugins as you wish

RUN apk add --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo -u fluent gem install \
        fluent-plugin-elasticsearch \
        fluent-plugin-record-reformer \
 && sudo -u fluent gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* \
           /home/fluent/.gem/ruby/2.3.0/cache/*.gem

COPY config/fluent.conf /fluentd/etc/fluent.conf
USER fluent

EXPOSE 24284