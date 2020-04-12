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

# wmake initField utility
wmake init3dField

# initialize field and set refinement repeatedly (maxRefLevel+1)
for count in {1..3}
do
    init3dField/init3dField > log.$count.init3dField
    meshUpdater -overwrite > log.$count.meshUpdater
done

# decompose with constraint refinementHistory
runApplication decomposePar

# Make constant/polyMesh folders
for fold in $(ls -d processor*)
do
    mkdir $fold/constant
    cp -r $fold/0/polyMesh $fold/constant
done

# Make .foam file
touch "${PWD##*/}.foam"

# run the solver
echo "run interFoam on 4 procs"
mpirun -np 4 interFoam -parallel > log.interFoam

#------------------------------------------------------------------------------
