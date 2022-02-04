FROM base-kudu

LABEL Author="Vasu Goel"

EXPOSE 8051 

CMD kudu-master -fs_wal_dir /var/lib/kudu/master \
        -use_hybrid_clock=false \
        -fs_wal_dir=/var/lib/kudu/master \
        -fs_data_dirs=/var/lib/kudu/master \
        -logtostderr


