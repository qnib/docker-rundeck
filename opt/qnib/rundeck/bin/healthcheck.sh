#!/usr/local/bin/dumb-init /bin/bash

nmap localhost -p 4440 |grep open
