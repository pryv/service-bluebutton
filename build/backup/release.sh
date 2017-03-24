#!/bin/bash
set -e
source /pd_build/buildconfig

target_dir="/app/bin"
log_dir="/app/log"
conf_dir="/app/conf"
data_dir="/app/data"

header "Install application from release.tar"

run mkdir -p $target_dir
run chown app $target_dir

# Unpack the application and run npm install.
pushd $target_dir
run tar -x --owner app -f \
  /pd_build/release.tar .

PYTHON=$(which python2.7) run yarn install

# Generate static html files using grunt
run npm run grunt

# Perform a release build of the source code. (-> lib)
run npm run release

# Install the config file
run mkdir -p $conf_dir && \
  cp /pd_build/config/backup.json $conf_dir/backup.json

# Create the log
run mkdir -p $log_dir && \
  touch $log_dir/backup.log && chown -R app:app $log_dir

# Create the data space (attachments/previews)
run mkdir -p $data_dir/attachments && mkdir -p $data_dir/previews && \
  chown -R app:app $data_dir

# Install the script that runs the api service
run mkdir /etc/service/backup && \
  cp /pd_build/runit/backup /etc/service/backup/run
