#!/bin/sh

set -e

cd "$(dirname "$0")"

cleanup() {
  rm -rf tmp
}
trap 'cleanup' EXIT

################################################################################
# common functions copied from other repository
################################################################################

prepare_publish() {
  branch=$1
  git clone --single-branch --branch "$branch" https://github.com/infoaOrganization/oxmysql.git tmp || (
    git init tmp &&
    git -C tmp remote add origin https://github.com/infoaOrganization/oxmysql.git &&
    git -C tmp checkout -b "$branch"
  )
  find tmp -type f | grep -v ^tmp/\\.git | xargs rm -f
  find tmp -type d | grep -v ^tmp/\\.git | grep -v ^tmp\$ | xargs rm -rf
}

finalize_publish() {
  branch=$1
  git -C tmp add .
  git -C tmp commit -m "release $(date +%Y-%m-%d)"
  git -C tmp push origin "$branch"
  cleanup
}

################################################################################
# release
################################################################################

sh build.sh

prepare_publish release

cp -r dist logger fxmanifest.lua ui.lua LICENSE README.md tmp
mkdir -p tmp/lib
cp lib/MySQL.lua tmp/lib
mkdir -p tmp/web
cp -r web/build tmp/web

finalize_publish release
