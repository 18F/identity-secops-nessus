FROM alpine:edge
ARG BUCKET
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
RUN apk add aws-cli
RUN aws s3 cp s3://${BUCKET}/Nessus-8.10.0-ubuntu1110_amd64.deb /tmp/Nessus.deb


FROM ubuntu:bionic
ARG LICENSE

COPY nessus.sh /usr/bin/
COPY --from=0 /tmp/Nessus.deb /tmp/
RUN apt-get install -y /tmp/Nessus.deb
RUN rm /tmp/Nessus.deb

# Make a backup of nessus so that when we mount a persistent volume on top of it,
# we can seed it from our backup.
RUN cd /opt/ && tar czf nessus.tar.gz nessus
EXPOSE 8834
CMD ["/usr/bin/nessus.sh"]
