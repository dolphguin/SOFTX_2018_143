#!/bin/bash

WM_PROJECT_DIR=/opt/openfoam6
source $WM_PROJECT_DIR/etc/bashrc
echo "version: " && foamVersion

#source $PWD/etc/bashrc
source $PWD/bash_settings

./config.sh

#cd ${0%/*} || exit 1

for MODEL in \
"src/dynamicMesh" \
"src/dynamicFvMesh" \
"src/twoPhaseProperties"
do
    if [[ -d $MODEL ]]; then
        wmake -j $1 libso $MODEL
    fi
done


for MODEL in \
"applications/utilities/meshUpdater" \
"applications/utilities/meshUpdaterOrig" \
"applications/utilities/initSurfaceFields" \
"applications/utilities/decomposeParLevel" \
"applications/utilities/reconstructParLevel"
do
    if [[ -d $MODEL ]]; then
        wmake -j $1 $MODEL
    fi
done
