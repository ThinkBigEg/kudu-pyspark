FROM bde2020/spark-master:2.3.1-hadoop2.7


MAINTAINER Hussein Khaled <h.khaled@think-big.solutions>	

ENV PATH /opt/conda/bin:$PATH
ENV SPARK_MASTER_URL local[2]
ENV SPARK_DRIVER_LOG /opt/spark/logs
ENV PYSPARK_DRIVER_PYTHON /opt/conda/envs/kudu/bin/jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS 'notebook --ip=0.0.0.0 --port=7777 --notebook-dir=/opt/spark/notebooks --no-browser --allow-root'

RUN 	wget https://repo.anaconda.com/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh -O ~/miniconda.sh && \
    	/bin/bash ~/miniconda.sh -b -p /opt/conda && \
    	rm ~/miniconda.sh && \
    	/opt/conda/bin/conda clean -tipsy && \
    	ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    	echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
	conda create --name kudu python=3.7 jupyter && \
	echo "conda activate kudu" >> ~/.bashrc	

RUN	pip install py4j && \
	pip install Cython && \
	wget -qO - http://archive.cloudera.com/beta/kudu/ubuntu/trusty/amd64/kudu/archive.key | apt-key add - && \
	wget -P /etc/apt/sources.list.d/ "http://archive.cloudera.com/kudu/ubuntu/trusty/amd64/kudu/cloudera.list" && \
	apt-get update -y && \
	apt-get -y install kudu kudu-master kudu-tserver libkuduclient0 libkuduclient-dev && \
	pip install Cython kudu-python==1.2.0

RUN	echo "/spark/python" >> /opt/conda/envs/kudu/lib/python3.7/site-packages/pyspark.pth && \
	mkdir -p /opt/spark/notebooks

RUN	/opt/conda/envs/kudu/bin/pip install py4j && \
	/opt/conda/envs/kudu/bin/pip install Cython && \
	/opt/conda/envs/kudu/bin/pip install Cython kudu-python==1.2.0
	





VOLUME /var/lib/kudu/master /var/lib/kudu/tserver

EXPOSE 7777 8050 8051 7050 7051

COPY docker-entrypoint.sh /bin/

ENTRYPOINT ["/bin/docker-entrypoint.sh"]

RUN chmod +x /bin/docker-entrypoint.sh









