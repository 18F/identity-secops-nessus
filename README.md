# Nessus

This repo contains the info needed to containerize Nessus.

The container needs to be built with something like:
```
docker build --build-arg AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID --build-arg AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY --build-arg BUCKET=login-gov-secops-artifacts-secops-dev .
```

The AWS keys should have permissions sufficient for you to read from the artifacts bucket specified,
and probably also to push to ECR too.

This is currently for testing only, not production.
