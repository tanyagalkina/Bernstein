#!/bin/bash

tput bold
tput setaf 3;

printf 'DELETING SERVICES .. \n'
tput sgr0


kubectl delete configmap postgres-configmap
kubectl delete configmap redis-configmap
kubectl delete secret postgres-secret
kubectl delete deployment --all
kubectl delete service --all
kubectl delete pod --all
kubectl delete daemonset cadvisor-daemonset -n kube-system
kubectl delete  ingress --all
kubectl delete  persistentvolumeclaims postgres-pers-volume-claim
kubectl delete  persistentvolume postgres-volume

kubectl delete deploy traefik-ingress-controller -n kube-public
kubectl delete clusterrole traefik-ingress-controller
kubectl delete clusterrolebinding traefik-ingress-controller
kubectl delete serviceaccount traefik-ingress-controller -n kube-public
kubectl delete service traefik-ingress-service -n kube-public


