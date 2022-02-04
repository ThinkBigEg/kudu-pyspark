FROM base-kudu

LABEL Author="Vasu Goel"

EXPOSE 8050

CMD kudu-tserver \
    -fs_wal_dir /var/lib/kudu/tserver \
    -use_hybrid_clock=false \
    -fs_wal_dir=/var/lib/kudu/tserver \
    -fs_data_dirs=/var/lib/kudu/tserver \
    -tserver_master_addrs ${KUDU_MASTER} \
    -logtostderr