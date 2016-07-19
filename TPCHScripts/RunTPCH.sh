#!/bin/bash
#Script Usage : ./RunTPCH.sh SCALE_FACTOR

TARGET_DIR=hive-testbench1

if [ -z $1 ]
then
	echo "Usage: ./RunTPCH SCALE_FACTOR"
fi

if [ ! -d "$TARGET_DIR" ]; then
	git clone https://github.com/epkalyanr/hive-testbench.git $TARGET_DIR
else
	echo "Test bench already downloaded..."
fi

sudo chmod 777 -R $TARGET_DIR

cd $TARGET_DIR

./tpch-build.sh

./tpch-setup.sh $1

cd $TARGET_DIR/TPCHScripts

echo "Running TPCH Queries and Collecting PAT Data"

./GetPatData.sh $2 ./tpch-queryexec.sh

echo "Collecting PERF Data"
./CollectPerfData.sh