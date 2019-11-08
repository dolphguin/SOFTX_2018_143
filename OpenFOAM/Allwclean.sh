#!/bin/sh

cd ${0%/*} || exit 1


cd src/dynamicMesh/
wclean
cd -

cd src/dynamicFvMesh/
wclean
cd -

cd src/twoPhaseProperties/
wclean
cd -

cd applications/utilities/meshUpdater/
wclean
cd -

# linked vs the original OF dynamicMesh library
cd applications/utilities/meshUpdaterOrig/
wclean
cd -

cd applications/utilities/initSurfaceFields/
wclean
cd -

cd applications/utilities/decomposeParLevel/
wclean
cd -

cd applications/utilities/reconstructParLevel/
wclean
cd -

