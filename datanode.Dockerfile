FROM base-kudu

LABEL Author="Vasu Goel <ivan.s.ermilov@gmail.com>"

HEALTHCHECK CMD curl -f http://localhost:9870/ || exit 1

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

ENV CLUSTER_NAME=test

ADD data.sh /data.sh
RUN chmod a+x /data.sh

EXPOSE 9864

CMD ["/data.sh"]