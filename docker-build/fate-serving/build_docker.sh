########################################################
# Copyright 2019-2020 program was created VMware, Inc. #
# SPDX-License-Identifier: Apache-2.0                  #
########################################################

#!/usr/bin/env bash
set -e

BASEDIR=$(dirname "$0")
cd $BASEDIR
WORKINGDIR=`pwd`

PREFIX=federatedai
TAG=2.0.4-release
version=2.0.4

source_code_dir=$(cd `dirname ${WORKINGDIR}`; pwd)

download() {
  mkdir -p cache
  rm -rf cache/*

  for module in "serving-proxy" "serving-server" "serving-admin"
  do
      wget -P cache/ https://github.com/FederatedAI/FATE-Serving/releases/download/v${version}/fate-${module}-${version}-release.zip
  done;
}

buildModule() {
  for module in "serving-proxy" "serving-server" "serving-admin"
  do
      echo "### START BUILDING ${module} ###"
      docker build --build-arg version=${version} --build-arg PREFIX=${PREFIX} -t ${PREFIX}/${module}:${TAG} -f ${module}/Dockerfile cache
      echo "### FINISH BUILDING ${module} ###"
      echo ""
  done;
}

pushImage() {
  ## push image
  for module in "serving-proxy" "serving-server" "serving-admin"
  do
      echo "### START PUSH ${module} ###"
      docker push ${PREFIX}/${module}:${TAG}
      echo "### FINISH PUSH ${module} ###"
      echo ""
  done;
}

while [ "$1" != "" ]; do
    case $1 in
         modules)
                 buildModule
                 ;;
         download)
                 download
                 ;;
         all)
                 download
                 buildModule
                 ;;
         push)
                pushImage
                ;;
    esac
    shift
done