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

# This will avoid getting DOSed by unicode.org because of the unicode npm package.
minimal_apt_get_install unicode-data

# Unpack the application and run npm install.
pushd $target_dir
run run tar -x --owner app -f \
  /pd_build/release.tar .

PYTHON=$(which python2.7) run yarn install

# Install zip command
run apt-get update
run apt-get --yes --force-yes install zip

# Generate static html files using grunt
run yarn run grunt

# Perform a release build of the source code. (-> lib)
run yarn run release

# Install the config file
run mkdir -p $conf_dir && \
  cp /pd_build/config/bluebutton.json $conf_dir/bluebutton.json

# Create the log
run mkdir -p $log_dir && \
  touch $log_dir/bluebutton.log && chown -R app:app $log_dir

# Create the data space (attachments)
run mkdir -p $data_dir/attachments && chown -R app:app $data_dir

# Install the script that runs the api service
run mkdir /etc/service/bluebutton
run cp /pd_build/runit/bluebutton /etc/service/bluebutton/run

# Have CRON run in this container
run rm /etc/service/cron/down