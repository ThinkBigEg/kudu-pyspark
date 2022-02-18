FROM base-kudu

COPY ./ml-data/movies.dat /opt/spark/notebooks
COPY ./ml-data/ratings.dat /opt/spark/notebooks
COPY ./ml-data/users.dat /opt/spark/notebooks

CMD bash