#!/bin/sh

CLUSTER="$1"
if [ ! -d "$CLUSTER" ] ; then
	CLUSTER="default"
fi

kubectl delete -k k8s/$1

