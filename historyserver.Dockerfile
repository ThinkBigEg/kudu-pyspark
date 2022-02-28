FROM base-kudu

LABEL Author="Vasu Goel <ivan.s.ermilov@gmail.com>"

HEALTHCHECK CMD curl -f http://localhost:8188/ || exit 1

ENV YARN_CONF_yarn_timeline___service_leveldb___timeline___store_path=/hadoop/yarn/timeline
RUN mkdir -p /hadoop/yarn/timeline
VOLUME /hadoop/yarn/timeline

ADD history.sh /history.sh
RUN chmod a+x /history.sh

EXPOSE 8188

CMD ["/history.sh"]