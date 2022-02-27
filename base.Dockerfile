FROM bde2020/spark-master:2.3.1-hadoop2.7


MAINTAINER Hussein Khaled <h.khaled@think-big.solutions>	


# Configuring environment variables for conda, spark and jupyter
ENV PATH /opt/conda/bin:$PATH
ENV SPARK_MASTER_URL local[2]
ENV SPARK_DRIVER_LOG /opt/spark/logs
ENV PYSPARK_DRIVER_PYTHON /opt/conda/envs/kudu/bin/jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS 'notebook --ip=0.0.0.0 --port=7777 --notebook-dir=/opt/spark/notebooks --no-browser --allow-root'



# Installing Miniconda 4.5.4 and creating virtual environment with following packages:
# Python 3.7
# Jupyter
RUN 	wget https://repo.anaconda.com/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh -O ~/miniconda.sh && \
    	/bin/bash ~/miniconda.sh -b -p /opt/conda && \
    	rm ~/miniconda.sh && \
    	/opt/conda/bin/conda clean -tipsy && \
    	ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    	echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
	conda create --name kudu python=3.7 jupyter && \
	echo "conda activate kudu" >> ~/.bashrc	

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50 && \
	echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list && \
	sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list && \
	apt-get -o Acquire::Check-Valid-Until=false update && \
	apt-get -y install ca-certificates

# Adding Kudu Cloudera Repository and installing Kudu
RUN	wget --no-check-certificate -qO - https://archive.cloudera.com/kudu/ubuntu/trusty/amd64/kudu/archive.key | apt-key add - && \
	wget -P /etc/apt/sources.list.d/ "http://archive.cloudera.com/kudu/ubuntu/trusty/amd64/kudu/cloudera.list" && \
	apt-get -o Acquire::Check-Valid-Until=false update -y && \
	apt-get -y install kudu kudu-master kudu-tserver libkuduclient0 libkuduclient-dev

#Referencing Pyspark to the virtual environment named kudu
RUN	echo "/spark/python" >> /opt/conda/envs/kudu/lib/python3.7/site-packages/pyspark.pth && \
	mkdir -p /opt/spark/notebooks

# Installing packages required to interface with kudu through python:
# Py4j
# Cython
# kudu-python 1.2
RUN	/opt/conda/envs/kudu/bin/pip install py4j && \
	/opt/conda/envs/kudu/bin/pip install Cython && \
	/opt/conda/envs/kudu/bin/pip install Cython kudu-python==1.2.0
	
ARG HADOOP_VERSION=hadoop-2.7.6
ARG HADOOP_PREFIX=/usr/local/hadoop
ARG HADOOP_CONF=${HADOOP_PREFIX}/etc/hadoop
ENV MY_HADOOP=hadoop-2.7.6
ARG HADOOP_ARCHIVE=${MY_HADOOP}.tar.gz

# ARG HADOOP_MIRROR_DOWNLOAD=http://archive.apache.org/dist/hadoop/core/$HADOOP_VERSION/$HADOOP_ARCHIVE
# RUN echo ${HADOOP_MIRROR_DOWNLOAD}

ARG HADOOP_MIRROR_DOWNLOAD=https://archive.apache.org/dist/hadoop/core/hadoop-2.7.6/hadoop-2.7.6.tar.gz


ARG HADOOP_RES_DIR=/opt/workspace/hadoop
RUN apt install -y openssh-server && \
	mkdir /opt/workspace && \
	curl ${CURL_OPTS} -o /opt/workspace/$HADOOP_ARCHIVE -O -L $HADOOP_MIRROR_DOWNLOAD && \
	tar -xzf /opt/workspace/${HADOOP_ARCHIVE} -C /usr/local && \
	ln -s /usr/local/$MY_HADOOP /usr/local/hadoop && \
	mkdir /var/hadoop && \
	mkdir /var/hadoop/hadoop-datanode && \
	mkdir /var/hadoop/hadoop-namenode && \
	mkdir /var/hadoop/mr-history && \
	mkdir /var/hadoop/mr-history/done && \
	mkdir /var/hadoop/mr-history/tmp

# ARG HADOOP_RES_DIR=/opt/workspace/hadoop

ENV HADOOP_PREFIX=/usr/local/hadoop
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF=/usr/local/hadoop/etc/hadoop
ENV HADOOP_YARN_HOME=${HADOOP_PREFIX}
ENV HADOOP_CONF_DIR=${HADOOP_PREFIX}/etc/hadoop
ENV YARN_LOG_DIR=${HADOOP_YARN_HOME}/logs
ENV YARN_IDENT_STRING=root
ENV HADOOP_IDENT_STRING=root
ENV HADOOP_MAPRED_IDENT_STRING=root
ENV HADOOP_MAPRED_HOME=${HADOOP_PREFIX}
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH=${HADOOP_PREFIX}/bin:${PATH}

ENV CORE_CONF_fs_defaultFS=hdfs://namenode:9000
ENV CORE_CONF_hadoop_http_staticuser_user=root
ENV CORE_CONF_hadoop_proxyuser_hue_hosts=*
ENV CORE_CONF_hadoop_proxyuser_hue_groups=*
ENV CORE_CONF_io_compression_codecs=org.apache.hadoop.io.compress.SnappyCodec

ENV HDFS_CONF_dfs_webhdfs_enabled=true
ENV HDFS_CONF_dfs_permissions_enabled=false
ENV HDFS_CONF_dfs_namenode_datanode_registration_ip___hostname___check=false

ENV YARN_CONF_yarn_log___aggregation___enable=true
ENV YARN_CONF_yarn_log_server_url=http://historyserver:8188/applicationhistory/logs/
ENV YARN_CONF_yarn_resourcemanager_recovery_enabled=true
ENV YARN_CONF_yarn_resourcemanager_store_class=org.apache.hadoop.yarn.server.resourcemanager.recovery.FileSystemRMStateStore
ENV YARN_CONF_yarn_resourcemanager_scheduler_class=org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler
ENV YARN_CONF_yarn_scheduler_capacity_root_default_maximum___allocation___mb=8192
ENV YARN_CONF_yarn_scheduler_capacity_root_default_maximum___allocation___vcores=4
ENV YARN_CONF_yarn_resourcemanager_fs_state___store_uri=/rmstate
ENV YARN_CONF_yarn_resourcemanager_system___metrics___publisher_enabled=true
ENV YARN_CONF_yarn_resourcemanager_hostname=resourcemanager
ENV YARN_CONF_yarn_resourcemanager_address=resourcemanager:8032
ENV YARN_CONF_yarn_resourcemanager_scheduler_address=resourcemanager:8030
ENV YARN_CONF_yarn_resourcemanager_resource__tracker_address=resourcemanager:8031
ENV YARN_CONF_yarn_timeline___service_enabled=true
ENV YARN_CONF_yarn_timeline___service_generic___application___history_enabled=true
ENV YARN_CONF_yarn_timeline___service_hostname=historyserver
ENV YARN_CONF_mapreduce_map_output_compress=true
ENV YARN_CONF_mapred_map_output_compress_codec=org.apache.hadoop.io.compress.SnappyCodec
ENV YARN_CONF_yarn_nodemanager_resource_memory___mb=16384
ENV YARN_CONF_yarn_nodemanager_resource_cpu___vcores=8
ENV YARN_CONF_yarn_nodemanager_disk___health___checker_max___disk___utilization___per___disk___percentage=98.5
ENV YARN_CONF_yarn_nodemanager_remote___app___log___dir=/app-logs
ENV YARN_CONF_yarn_nodemanager_aux___services=mapreduce_shuffle

ENV MAPRED_CONF_mapreduce_framework_name=yarn
ENV MAPRED_CONF_mapred_child_java_opts=-Xmx4096m
ENV MAPRED_CONF_mapreduce_map_memory_mb=4096
ENV MAPRED_CONF_mapreduce_reduce_memory_mb=8192
ENV MAPRED_CONF_mapreduce_map_java_opts=-Xmx3072m
ENV MAPRED_CONF_mapreduce_reduce_java_opts=-Xmx6144m
ENV MAPRED_CONF_yarn_app_mapreduce_am_env=HADOOP_MAPRED_HOME=/opt/hadoop-2.7.6/
ENV MAPRED_CONF_mapreduce_map_env=HADOOP_MAPRED_HOME=/opt/hadoop-2.7.6/
ENV MAPRED_CONF_mapreduce_reduce_env=HADOOP_MAPRED_HOME=/opt/hadoop-2.7.6/
# RUN cp -f  $HADOOP_CONF $HADOOP_RES_DIR/*

RUN hdfs namenode -format && \
	cp ${HADOOP_CONF}/mapred-site.xml.template ${HADOOP_CONF}/mapred-site.xml && \
	mkdir ~/logs && \
	mkdir ~/hadoop-data && \
	/etc/init.d/ssh start
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh  && /entrypoint.sh

VOLUME /var/lib/kudu/master /var/lib/kudu/tserver

EXPOSE 7777 7050 7051 7049

CMD ["bash"]







