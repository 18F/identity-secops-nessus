# Nessus

This repo contains the info needed to containerize Nessus.  

## Running

The container needs to be run with the `LICENSE` environment variable set, so that
it can properly register and operate.

The container is also meant to be run with a persistent volume attached to /opt/nessus.
Every time the container is launched, it will either install (if empty) or upgrade
the software from the Nessus.deb package.

If the system hasn't been registered, it will register the license key
and start running.  Users will need to be added by `kubectl exec`-ing into the pod and using
`/opt/nessus/sbin/nessuscli adduser <username>` to add them.  They should be persisted in the volume
after that.

## Building

If you are building by hand, you can do it like this:
```
export BUCKET=your-artifacts-bucket-name
aws s3 cp s3://${BUCKET}/Nessus-7.2.3-ubuntu1110_amd64.deb Nessus.deb
docker build .
```

Codebuild's buildspec.yml is where you configure which .deb is installed
in automatic deploys.  If you need AWS resources created, you can add them
in `main.tf`, as that code is run as a module when https://github.com/18F/identity-secops
is deployed.

## Kuberenetes deployment

Set the license key up with something like this:
```
aws secretsmanager create-secret --name nessus-license --secret-string <Nessus-License-String>
```

Then run `k8s/deploy.sh`

If you are deploying this for the first time, then you will need to exec into the pod and
run `/opt/nessus/sbin/nessuscli adduser <username>` to add users.

## Automatic Deployment

There is a codepipeline thing set up in `main.tf` that watches master and deploys
when there are changes.  If there are infrastructure changes in the terraform code,
the https://github.com/18F/identity-secops deploy must be run first.  Once we
get codepipeline really working, we will try to automate this too.

## Status

This is currently for testing only, not production.
