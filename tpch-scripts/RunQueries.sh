#!/bin/bash
#script usage ./RunQueries.sh SCALE_FACTOR
if [ $# -ne 1 ]
then
	echo "Usage: ./RunQueries.sh SCALE_FACTOR"
	exit 1
fi

BENCH_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../" && pwd );
echo "\$BENCH_HOME is set to $BENCH_HOME";

BENCHMARK=hive-testbench

RESULT_DIR=$BENCH_HOME/$BENCHMARK/results/
mkdir $RESULT_DIR
chmod -R 777 $RESULT_DIR

LOG_DIR=$BENCH_HOME/$BENCHMARK/logs/
mkdir $LOG_DIR

# Initialize log file for data loading times
LOG_FILE_EXEC_TIMES="${BENCH_HOME}/${BENCHMARK}/logs/query_times.csv"
if [ ! -e "$LOG_FILE_EXEC_TIMES" ]
  then
	touch "$LOG_FILE_EXEC_TIMES"
	chmod 777 $LOG_FILE_EXEC_TIMES
    echo "STARTTIME,STOPTIME,DURATION_IN_SECONDS,DURATION,BENCHMARK,DATABASE,SCALE_FACTOR,FILE_FORMAT,QUERY" >> "${LOG_FILE_EXEC_TIMES}"
fi

if [ ! -w "$LOG_FILE_EXEC_TIMES" ]
  then
    echo "ERROR: cannot write to: $LOG_FILE_EXEC_TIMES, no permission"
    return 1
fi

for i in {1..22}
do
./TpchQueryExecute.sh $1 $i
done
