#!/bin/bash
BENCH_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd );
echo "\$BENCH_HOME is set to $BENCH_HOME";

BENCHMARK=hive-testbench
if [ $# -eq 0 ]
then
	echo "Usage ./GetTezApplication.sh RESULTS_DIR PERFDATA_OUTPUTDIR SERVER"
	echo "Default Values will be used if you do not provide command line parameters"
fi

if [ -z $1 ]
then
	RESULTS_DIR=$BENCH_HOME/$BENCHMARK/results/
else
	RESULTS_DIR=$1
fi

if [ -z $2 ]
then
	PERFDATA_OUTPUTDIR=$BENCH_HOME/$BENCHMARK/PerfData/
else
	PERFDATA_OUTPUTDIR=$2
fi

if [ -z $3 ]
then
	SERVER=http://localhost:8188/ws/v1/timeline
else
	SERVER=$3
fi

echo "RESULTS_DIR is set to $RESULTS_DIR"
echo "PERFDATA_OUTPUTDIR is set to $PERFDATA_OUTPUTDIR"
echo "SERVER is set to $SERVER"

mkdir $PERFDATA_OUTPUTDIR
				
file="$PERFDATA_OUTPUTDIR/dagids.txt"
count=1
mkdir $PERFDATA_OUTPUTDIR/tezapplication

while read -r line
do
        echo "Getting TEZ_APPLICATION for $line"
		line=${line/dag/tez_application}
		line=${line:0:-2}
		echo "Tez application id is $line"
        sudo curl  $SERVER/TEZ_APPLICATION/$line > $PERFDATA_OUTPUTDIR/tezapplication/tezapplication_tpch_query_$count.txt
        ((count++))
done < $file
