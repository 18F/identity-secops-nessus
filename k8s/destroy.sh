#!/bin/sh

kubectl delete deployment nessus
kubectl delete PersistentVolumeClaim nessus-pv-claim
kubectl delete PersistentVolume nessus-pv-volume
