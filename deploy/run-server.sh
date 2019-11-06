#!/usr/bin/env bash

cd "${GOPATH}"/src/github.com/ankurgel/duss || exit
cp releases/duss_linux_amd64 "${GOPATH}"/bin/
cp deploy/conf.d/duss.conf /etc/supervisor/conf.d/

# Run supervisor
supervisord -n -c /etc/supervisor/supervisord.conf
s