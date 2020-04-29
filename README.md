# Nessus

This repo contains the info needed to containerize Nessus.  

## Running

The container needs to be run with the `LICENSE` environment variable set, so that
it can properly register and operate.  This is pulled from the `nessus-secrets/license` secret.

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

By default, CircleCI builds this container and tags it into `logindotgov/<git sha>`
and `logindotgov/<branch>` when it sees changes.

## Kuberenetes deployment

Set the license key up with something like this:
```
kubectl create secret generic nessus-secrets --from-literal=license=<Nessus-License-String>
```

Then run `./deploy.sh`

If you are deploying this for the first time, then you will need to exec into the pod and
run `/opt/nessus/sbin/nessuscli adduser <username>` to add users.

## Automatic Deployment

This will be done with spinnaker.  Not sure how yet, though.
