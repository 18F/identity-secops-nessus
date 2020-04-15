FROM ubuntu:bionic

COPY nessus.sh /usr/bin/
COPY Nessus.deb /tmp/
RUN apt-get install -y /tmp/Nessus.deb
RUN rm /tmp/Nessus.deb

# Make a backup of nessus so that when we mount a persistent volume on top of it,
# we can seed it from our backup.
RUN cd /opt/ && tar czf nessus.tar.gz nessus

EXPOSE 8834
CMD ["/usr/bin/nessus.sh"]
