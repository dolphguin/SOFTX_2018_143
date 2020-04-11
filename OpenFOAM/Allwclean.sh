#!/bin/bash

WM_PROJECT_DIR=/opt/openfoam6
source $WM_PROJECT_DIR/etc/bashrc
echo "version: " && foamVersion

#source $PWD/etc/bashrc
source $PWD/bash_settings

cd ${0%/*} || exit 1


cleanApplication()
{
    wclean $1
    if [ -d $1/Make/linux* ]; then
        cleanApplication $1/Make/linux*
    fi
}

for MODEL in \
"src/dynamicMesh" \
"src/dynamicFvMesh" \
"src/twoPhaseProperties" \
"applications/utilities/meshUpdater" \
"applications/utilities/meshUpdaterOrig" \
"applications/utilities/initSurfaceFields" \
"applications/utilities/decomposeParLevel" \
"applications/utilities/reconstructParLevel"
do
    if [ -d $MODEL ]; then
        cleanApplication $MODEL
    fi
done
