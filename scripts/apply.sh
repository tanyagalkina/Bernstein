#!/bin/bash


print_col() {
    tput bold
    tput setaf $1
    echo $2
    tput sgr0
}


print_col 2  "DEPLOYING => cAdvisor .. dont know why .. it should be already there\n"
kubectl apply -f cadvisor.daemonset.yaml


 
print_col 1 'DEPLOYING => postgres ..\n'

kubectl apply -f postgres.secret.yaml \
    -f postgres.configmap.yaml \
-f postgres.volume.yaml \
-f postgres.deployment.yaml \
-f postgres.service.yaml

print_col 3 'DEPLOYING => redis ..\n'

kubectl apply -f redis.configmap.yaml \
    -f redis.deployment.yaml \
    -f redis.service.yaml

print_col 4  'DEPLOYING => poll ..\n'

kubectl apply -f poll.deployment.yaml \
    -f worker.deployment.yaml \
    -f result.deployment.yaml \
    -f poll.service.yaml \
    -f result.service.yaml \
    -f poll.ingress.yaml \
    -f result.ingress.yaml

print_col 5 'DEPLOYING => traefik ..\n'

kubectl apply -f traefik.rbac.yaml \
    -f traefik.deployment.yaml \
    -f traefik.service.yaml

print_col 1 'Create database manually after first deploy\n'

echo "CREATE TABLE IF NOT EXISTS votes \
    (id text PRIMARY KEY, vote text NOT NULL);" \
| kubectl exec -i $(kubectl get pod -o custom-columns=":metadata.name" \
| grep postgres) \
 -- psql -U OUTMANE -d postgres-db

print_col 2 'Adds 2 fake DNS to /etc/hosts'


echo "$(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type =="ExternalIP")].address }') poll.dop.io result.dop.io" | sudo tee -a /etc/hosts
