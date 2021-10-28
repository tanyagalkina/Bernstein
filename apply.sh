#!/bin/bash

tput bold

tput setaf 2;
printf 'DEPLOYING => cAdvisor .. dont know why .. it should be already there\n'
tput sgr0
 kubectl apply -f cadvisor.daemonset.yaml

tput bold 
tput setaf 1;
printf 'DEPLOYING => postgres ..\n'
tput sgr0
 kubectl apply -f postgres.secret.yaml \
    -f postgres.configmap.yaml \
-f postgres.volume.yaml \
-f postgres.deployment.yaml \
-f postgres.service.yaml

tput bold
tput setaf 3;
printf 'DEPLOYING => redis ..\n'
tput sgr0

kubectl apply -f redis.configmap.yaml \
    -f redis.deployment.yaml \
    -f redis.service.yaml

tput bold
tput setaf 4;
printf 'DEPLOYING => poll ..\n'
tput sgr0

kubectl apply -f poll.deployment.yaml \
    -f worker.deployment.yaml \
    -f result.deployment.yaml \
    -f poll.service.yaml \
    -f result.service.yaml \
    -f poll.ingress.yaml \
    -f result.ingress.yaml

tput bold
tput setaf 5;
printf 'DEPLOYING => traefik ..\n'
tput sgr0

kubectl apply -f traefik.rbac.yaml \
    -f traefik.deployment.yaml \
    -f traefik.service.yaml

tput bold
tput setaf 1;
printf 'Create database manually after first deploy\n'


## try to get inside the container first .. it does not let me . it says it has no admin )))
tput sgr0


#echo "CREATE TABLE votes \
#    (id text PRIMARY KEY, vote text NOT NULL);" \
#| kubectl exec -i <postgres-deployment-id> -c <postgres-container-id> \
#– psql -U <username>'

#kubectl exec -it $(kubectl get pod -o custom-columns=":metadata.name") -- sh


#echo "CREATE TABLE votes \
#    (id text PRIMARY KEY, vote text NOT NULL);" \
#| kubectl exec -i $(kubectl get pod -o custom-columns=":metadata.name" \
#| grep postgres) -c $(kubectl get deploy -o custom-columns=":spec.template.spec.container.name" \
#| grep postgres-deployment)  -psql -U admin

echo "CREATE TABLE votes \
    (id text PRIMARY KEY, vote text NOT NULL);" \
| kubectl exec -i $(kubectl get pods --no-headers -o custom-columns=":metadata.name" \
| grep postgres) -- psql -U root -d posgres-db

tput sgr0

tput bold
tput setaf 2;
printf 'Adds 2 fake DNS to /etc/hosts'

#echo "$(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=='ExternalIP')].address }')\
#    poll.dop.io result.dop.io" \
#    | sudo tee -a /etc/hosts
echo " $(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type =="ExternalIP")].address }') poll.dop.io result.dop.io" | sudo tee -a /etc/hosts
tput sgr0
