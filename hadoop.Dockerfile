FROM base-kudu

LABEL Author="Vasu Goel <ivan.s.ermilov@gmail.com>"

### Setup namenode
ENV HDFS_CONF_dfs_namenode_name_dir=file:///name
RUN mkdir -p /name
VOLUME /name

ENV CLUSTER_NAME=test

ADD name.sh /name.sh
RUN chmod a+x /name.sh

EXPOSE 9870

### Setup datanode
ENV HDFS_CONF_dfs_datanode_data_dir=file:///data
RUN mkdir -p /data
VOLUME /data

ENV CLUSTER_NAME=test

ADD data.sh /data.sh
RUN chmod a+x /data.sh

EXPOSE 9864


### Resource Manager
ADD resource.sh /resource.sh
RUN chmod a+x /resource.sh

EXPOSE 8088


### Node manager

ADD nodemanager.sh /nodemanager.sh
RUN chmod a+x /nodemanager.sh

EXPOSE 8042


### History server


ENV YARN_CONF_yarn_timeline___service_leveldb___timeline___store_path=/timeline
RUN mkdir -p /timeline
VOLUME /timeline

ADD history.sh /history.sh
RUN chmod a+x /history.sh

EXPOSE 8188
RUN namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'` && \
    datadir=`echo $HDFS_CONF_dfs_datanode_data_dir | perl -pe 's#file://##'`

ADD hadoop.sh /hadoop.sh
RUN chmod a+x /hadoop.sh

# RUN $HADOOP_PREFIX/sbin/hadoop-daemon.sh start namenode && \
#     $HADOOP_PREFIX/sbin/hadoop-daemon.sh start datanode && \
#     $HADOOP_PREFIX/sbin/yarn-daemon.sh start resourcemanager && \
#     $HADOOP_PREFIX/sbin/yarn-daemon.sh start nodemanager && \
#     $HADOOP_PREFIX/sbin/yarn-daemon.sh start timelineserver

EXPOSE 9870 9864 8088 8042 8188

CMD /hadoop.sh