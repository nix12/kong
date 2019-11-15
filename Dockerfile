FROM ubuntu:bionic
LABEL maintainer="Kong Core Team <team-core@konghq.com>"

ENV KONG_VERSION 1.4.0

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl perl unzip \
  && rm -rf /var/lib/apt/lists/* \
  && curl -fsSLo kong.deb https://bintray.com/kong/kong-deb/download_file?file_path=kong-${KONG_VERSION}.bionic.$(dpkg --print-architecture).deb \
  && apt-get purge -y --auto-remove ca-certificates curl \
  && dpkg -i kong.deb \
  && rm -rf kong.deb

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

COPY kong.conf /kong.conf

RUN chmod +x /kong.conf

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8000 8443 8001 8444

STOPSIGNAL SIGQUIT

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.6.0/wait /wait

RUN chmod +x /wait

CMD ["kong", "docker-start"]
