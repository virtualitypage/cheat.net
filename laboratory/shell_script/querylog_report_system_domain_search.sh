#!/bin/bash

path="/Volumes/DevOps/GitHub/AdGuardHome_Filters"
domain_csv="/Volumes/DevOps/ops/domain_reserch/Query Log Report System Domain.csv"

# while IFS= read -r domain || [[ -n $domain ]]; do
#   grep $domain $path/*/*.txt | sed 's/.*://g'
# done < "$domain_csv"

while IFS= read -r domain || [[ -n $domain ]]; do
  grep -x "@@||$domain" $path/*/*.txt | sed 's/.*://g'
  grep -x "0.0.0.0 $domain" $path/*/*.txt | sed 's/.*://g'
done < "$domain_csv"
