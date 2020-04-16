FROM ubuntu:bionic

COPY nessus.sh /usr/bin/
COPY test.sh /usr/bin/
RUN mkdir -p /opt
COPY Nessus.deb /opt/

EXPOSE 8834
CMD ["/usr/bin/nessus.sh"]
