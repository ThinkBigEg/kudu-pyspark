#   Kudu-Pyspark using Docker by [![N|Solid](https://think-big.solutions/img/logo.png)](https://think-big.solutions)

![logo](http://getkudu.io/img/logo.png) ![logo](https://www.docker.com/sites/default/files/social/docker_facebook_share.png) 

### NOTE: This image is for testing use not for production use

## Apache Kudu

Kudu is a columnar storage manager developed for the Apache Hadoop platform. Kudu shares the common technical properties of Hadoop ecosystem applications: it runs on commodity hardware, is horizontally scalable, and supports highly available operation.

## Image Components:
 - Spark
 - Kudu
 - Miniconda
 - Python 3.7
 - Cython
 - Kudu-Python
 - Jupyter
 
 ## Containers built in docker-compose:
  - 1 Kudu Master
  - 3 Kudu Tablet servers
  - Kudu Client to open jupyter notebook to connect to the kudu cluster
  
 ## Tutorial 
 ### Clone the repository
 ```sh
 git clone "https://github.com/ThinkBigEg/kudu-pyspark"
 cd kudu-pyspark
 ```
 ### Build the image
 ```sh
 docker build . --tag kudu-python
 ```
 ### Build the containers
 ```sh
 docker-compose up -d
 ```
 ### Open the kudu-client container
 ```sh
 docker-compose run -p 7777:7777 bash
 ```
 ### Open jupyter notebook
 ```sh
 ./spark/bin/pyspark --packages  org.apache.kudu:kudu-spark2_2.11:1.4.0
 ```
 Open on your browser http://0.0.0.0:7777 and enter the token appeared in the output of the command
 ```console
     Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://(16fba75ea1ef or 127.0.0.1):7777/?token=592c2d27c4c59ee85acde071c1b33c7e377a3bf979fc9121
 ```
