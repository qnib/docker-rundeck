#!/bin/bash

mkdir -p /opt/rundeck/server/config
confd -onetime -backend=env
