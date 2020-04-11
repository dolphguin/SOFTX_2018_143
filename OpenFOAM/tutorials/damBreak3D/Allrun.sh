#!/bin/bash

WM_PROJECT_DIR=/opt/openfoam6
source $WM_PROJECT_DIR/etc/bashrc
echo "version: " && foamVersion

cd ${0%/*} || exit 1    # Run from this directory

# Source tutorial run functions
. $WM_PROJECT_DIR/bin/tools/RunFunctions

#clean case
../../scripts/cleanCase.sh

# restore 0
cp -r org/ 0

runApplication blockMesh
#runApplication setSet -batch createObstacle.setSet

#runApplication topoSet
#runApplication subsetMesh -overwrite c0 -patch walls

# initialize field and set refinement repeatedly
echo "TopoSet"
topoSet >> log.topoSet

echo "subsetMesh"
subsetMesh -overwrite c0 -patch walls >> log.subsetMesh

# initialize field and set refinement repeatedly
for count in {1..3}
do

    echo "setFields"
    setFields >> log.$count.setFields

    echo "meshUpdater"
    meshUpdater -overwrite >> log.$count.meshUpdater
done

# decompose with constraint refinementHistory
runApplication decomposePar
runApplication decomposeParLevel

# Make constant/polyMesh folders
for fold in $(ls -d processor*)
do
    mkdir $fold/constant
    cp -r $fold/0/polyMesh $fold/constant
done

# Make .foam file
touch "${PWD##*/}.foam"

# run the solver
echo "run interFoam on 3 procs"
mpirun -np 3 interFoam -parallel > log.interFoam

#------------------------------------------------------------------------------
