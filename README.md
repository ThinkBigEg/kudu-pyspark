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
 Open a new notebook and enter the following code 
 ```python
 

import kudu
from kudu.client import Partitioning
from datetime import datetime

# Connect to Kudu master server
client = kudu.connect(host='kudu.master', port=7051)

# Define a schema for a new table
builder = kudu.schema_builder()
builder.add_column('key').type(kudu.int64).nullable(False).primary_key()
builder.add_column('ts_val', type_=kudu.unixtime_micros, nullable=False, compression='lz4')
schema = builder.build()

# Define partitioning schema
partitioning = Partitioning().add_hash_partitions(column_names=['key'], num_buckets=3)

# Create new table
client.create_table('python-example', schema, partitioning)

# Open a table
table = client.table('python-example')

# Create a new session so that we can apply write operations
session = client.new_session()

# Insert a row
op = table.new_insert({'key': 1, 'ts_val': datetime.utcnow()})
session.apply(op)

# Upsert a row
op = table.new_upsert({'key': 2, 'ts_val': "2016-01-01T00:00:00.000000"})
session.apply(op)

# Updating a row
op = table.new_update({'key': 1, 'ts_val': ("2017-01-01", "%Y-%m-%d")})
session.apply(op)

# Delete a row
op = table.new_delete({'key': 2})
session.apply(op)

# Flush write operations, if failures occur, capture print them.
try:
    session.flush()
except kudu.KuduBadStatus as e:
    print(session.get_pending_errors())

# Create a scanner and add a predicate
scanner = table.scanner()
scanner.add_predicate(table['ts_val'] == datetime(2017, 1, 1))

# Open Scanner and read all tuples
# Note: This doesn't scale for large scans
result = scanner.open().read_all_tuples()
 ```
