#!/bin/bash
#Script Usage : ./RunTPCH.sh SCALE_FACTOR CLUSTER_SSH_PASSWORD

TARGET_DIR=hive-testbench

if [ -z $1 ]
then
	echo "Usage: ./RunTPCH SCALE_FACTOR CLUSTER_SSH_PASSWORD"
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

cd ./TPCHScripts

echo "Running TPCH Queries and Collecting PAT Data"

./GetPatData.sh $2 ./tpch-queryexec.sh

echo "collecting perf data"
./CollectPerfData.sh