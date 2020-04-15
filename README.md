# Nessus

This repo contains the info needed to containerize Nessus.  The container is meant to be run with a persistent volume attached to /opt/nessus.  If that directory is empty, then it will unpack a tarball
with an empty install there.  If the system hasn't been initialized, it will register the license key
and start running.  Users will need to be added by ssh-ing into the pod and using
`/opt/nessus/sbin/nessuscli adduser <username>` to add them.  They should be persisted in the volume
after that.

## Building

The container needs to be built with something like:
```
docker build --build-arg AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  --build-arg AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  --build-arg BUCKET=login-gov-secops-artifacts-secops-dev .
```

The AWS keys should have permissions sufficient for you to read from the artifacts bucket specified,
and probably also to push to ECR too.

## Status

This is currently for testing only, not production.
