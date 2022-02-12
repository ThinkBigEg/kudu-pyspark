@REM set SPARK_VERSION="2.3.0"
@REM set HADOOP_VERSION="2.7"
@REM set JUPYTERLAB_VERSION="2.1.5"

echo %Building the Images%

docker build -f base.Dockerfile -t base-kudu .
docker build -f kudu-master.Dockerfile -t kudu-master .
docker build -f kudu-tserver.Dockerfile -t kudu-tserver .
docker build -f kudu-client.Dockerfile -t kudu-client .
docker build -f hadoop.Dockerfile -t hadoop .
docker build -f namenode.Dockerfile -t namenode .
docker build -f datanode.Dockerfile -t datanode .
docker build -f resource.Dockerfile -t resourcemanager .
docker build -f nodemanager.Dockerfile -t nodemanager .
docker build -f historyserver.Dockerfile -t historyserver .
