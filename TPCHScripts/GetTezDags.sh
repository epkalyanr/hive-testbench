#!/bin/bash
BENCH_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd );
echo "\$BENCH_HOME is set to $BENCH_HOME";

BENCHMARK=hive-testbench
if [ $# -eq 0 ]
then
	echo "Usage ./GetTezDagIds.sh RESULTS_DIR PERFDATA_OUTPUTDIR SERVER"
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

file="$PERFDATA_OUTPUTDIR/qids.txt"
count=01
mkdir $PERFDATA_OUTPUTDIR/dags
while read -r line
do
        echo "Getting dag for $line"
        printf -v j "%02d" $count
        curl  $SERVER/TEZ_DAG_ID?primaryFilter=callerId:$line > $PERFDATA_OUTPUTDIR/dags/tpch_query_dag_$j.txt
        ((count++))
done < $file
