#!/bin/sh

CLUSTER="$1"
if kubectl config current-context | grep -E "cluster\/${CLUSTER}$" >/dev/null ; then
	echo "applying to $CLUSTER"
else
	echo "could not find $CLUSTER in our context:"
	echo "found $(kubectl config current-context), was searching for $CLUSTER in it"
	exit 1
fi

if kubectl get secret nessus-secrets >/dev/null ; then
	echo "nessus-secret does not exist.  Probably should create it with something like:"
	echo "kubectl create secret generic nessus-secrets --from-literal=license=<LICENSE>"
	exit 1
fi

kubectl apply -k "k8s/$1"
