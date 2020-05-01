FROM ubuntu:bionic

COPY nessus.sh /usr/bin/
COPY test.sh /usr/bin/
RUN mkdir -p /opt
COPY Nessus-7.2.3-ubuntu1110_amd64.deb /opt/Nessus.deb

EXPOSE 8834
CMD ["/usr/bin/nessus.sh"]
