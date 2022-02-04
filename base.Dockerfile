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

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update
RUN apt-get -y install ca-certificates

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
	
VOLUME /var/lib/kudu/master /var/lib/kudu/tserver

EXPOSE 7777 7050 7051 7049

CMD ["bash"]







