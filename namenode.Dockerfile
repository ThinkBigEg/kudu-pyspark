FROM base-kudu

LABEL Author="Vasu Goel <ivan.s.ermilov@gmail.com>"

HEALTHCHECK CMD curl -f http://localhost:9870/ || exit 1

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name

ENV CLUSTER_NAME=test

ADD name.sh /name.sh
RUN chmod a+x /name.sh

EXPOSE 9870

CMD ["/name.sh"]