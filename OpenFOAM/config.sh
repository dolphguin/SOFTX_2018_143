#!/bin/bash

source bash_settings

LASTCOMMIT=$(git show --summary | head -1 | sed 's/commit //g')

echo "Preconfiguring environment"
echo "Project name: $PROJECT_NAME"
echo "Branch version: $VERSION"
echo "Last commit: $LASTCOMMIT"
echo ""

echo "Set OpenFOAM location as $WM_PROJECT_DIR"
OF_SCRIPTS=()

OF_SCRIPTS+=($(egrep -lR 'WM_PROJECT_DIR=' .))

declare -p OF_SCRIPTS  > /dev/null 2>&1

# Consistently set the OpenFOAM version
for SCRIPT in ${OF_SCRIPTS[@]}; do

    if [ "$SCRIPT" == "./bash_settings" ] \
    || [ "$SCRIPT" == "./config.sh" ] \
    || [ "$SCRIPT" == "./Allwmake.sh" ] \
    || [ "$SCRIPT" == "./Allwclean.sh" ]
    then
        continue
    fi

    echo "Set OpenFOAM location in $SCRIPT"

    PATTERN=$(grep 'WM_PROJECT_DIR=' $SCRIPT)

    NEWPATTERN="WM_PROJECT_DIR=$WM_PROJECT_DIR"

    if [ "$PATTERN" != "$NEWPATTERN" ]; then
        echo "    $PATTERN -> $NEWPATTERN"
        sed -i "s|$PATTERN|$NEWPATTERN|g" $SCRIPT
    fi

done

echo ""

