FROM base-kudu

LABEL Author="Vasu Goel <ivan.s.ermilov@gmail.com>"

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

ADD nodemanager.sh /nodemanager.sh
RUN chmod a+x /nodemanager.sh

EXPOSE 8042

CMD ["/nodemanager.sh"]