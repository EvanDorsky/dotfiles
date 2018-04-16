#!/bin/bash

ssh-keygen -f ~/.ssh/id_rsa -q -N ""

hname=$(hostname)
machinename=(${hname//./ })
curl -u "evan.dorsky@icloud.com" --data "{\"title\":\"$machinename\",\"key\":\"$(cat ~/.ssh/id_rsa.pub)\"}" https://api.github.com/user/keys
