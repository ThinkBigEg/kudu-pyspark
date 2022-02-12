#!/bin/bash

$HADOOP_PREFIX/sbin/hadoop-daemon.sh start namenode
$HADOOP_PREFIX/sbin/hadoop-daemon.sh start datanode
$HADOOP_PREFIX/sbin/yarn-daemon.sh start resourcemanager
$HADOOP_PREFIX/sbin/yarn-daemon.sh start nodemanager
$HADOOP_PREFIX/sbin/yarn-daemon.sh start timelineserver

while true; do sleep 1000; done