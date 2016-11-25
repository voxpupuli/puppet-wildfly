#!/bin/bash

profiles=( wildfly:8.0 wildfly:8.2.1 wildfly:9.0.2 wildfly:10.1.0 )
boxes=( default centos-72-x64 debian-78-x64 debian-82-x64 )
for test_profile in "${profiles[@]}"
do
  for box in "${boxes[@]}"
  do
    profile="${test_profile}" BEAKER_set="${box}" BEAKER_destroy="onpass" bundle exec rake beaker
  done
done
