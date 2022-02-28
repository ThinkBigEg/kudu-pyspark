FROM base-kudu

LABEL Author="Vasu Goel <ivan.s.ermilov@gmail.com>"

HEALTHCHECK CMD curl -f http://localhost:8088/ || exit 1

ADD resource.sh /resource.sh
RUN chmod a+x /resource.sh

EXPOSE 8088

CMD ["/resource.sh"]