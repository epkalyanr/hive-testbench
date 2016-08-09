#!/bin/bash
# This script runs the hive queries on the data generated from the tpch suite and reports query execution times
# get home path
BENCH_HOME=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../" && pwd );
echo "\$BENCH_HOME is set to $BENCH_HOME";

BENCHMARK=hive-testbench
# Set path to the hive settings
HIVE_SETTING=$BENCH_HOME/$BENCHMARK/sample-queries-tpch/testbench.settings
# Set path to tpc-h queries
QUERY_DIR=$BENCH_HOME/$BENCHMARK/sample-queries-tpch

if [ -z $1 ]
then
	echo "Usage ./tpch-queryexec.sh SCALE_FACTOR"
	echo "SCALE_FACTOR set to a default value of 1000 since it was not specified"
	SCALE=1000
else
	SCALE="$1"
fi

DATABASE="tpch_partitioned_orc_$SCALE"
FILE_FORMAT=orc
TABLES="part partsupp supplier customer orders lineitem nation region"

# Create output directory
CURDATE="`date +%Y-%m-%d`"
RESULT_DIR=$BENCH_HOME/$BENCHMARK/results/
sudo mkdir $RESULT_DIR
sudo chmod -R 777 $RESULT_DIR

LOG_DIR=$BENCH_HOME/$BENCHMARK/logs/
sudo mkdir $LOG_DIR

# Initialize log file for data loading times
LOG_FILE_EXEC_TIMES="${BENCH_HOME}/${BENCHMARK}/logs/query_times.csv"
if [ ! -e "$LOG_FILE_EXEC_TIMES" ]
  then
    sudo touch "$LOG_FILE_EXEC_TIMES"
	sudo chmod 777 $LOG_FILE_EXEC_TIMES
    echo "STARTTIME,STOPTIME,DURATION_IN_SECONDS,DURATION,BENCHMARK,DATABASE,SCALE_FACTOR,FILE_FORMAT,QUERY" >> "${LOG_FILE_EXEC_TIMES}"
fi

if [ ! -w "$LOG_FILE_EXEC_TIMES" ]
  then
    echo "ERROR: cannot write to: $LOG_FILE_EXEC_TIMES, no permission"
    return 1
fi
#i=1
#while [ $i -le $NUM_QUERIES ]

for i in {1..1}
do	
	# Measure time for query execution
	# Start timer to measure data loading for the file formats
	STARTDATE="`date +%Y/%m/%d:%H:%M:%S`"
	STARTTIME="`date +%s`" # seconds since epochstart
	# Execute query
		ENGINE=hive
		printf -v j "%02d" $i
		echo "Hive query: ${i}"
		hive -i ${HIVE_SETTING} --database ${DATABASE} -f ${QUERY_DIR}/tpch_query${i}.sql > ${RESULT_DIR}/${DATABASE}_query${j}.txt 2>&1
	
	# Calculate the time
	STOPDATE="`date +%Y/%m/%d:%H:%M:%S`"
	STOPTIME="`date +%s`" # seconds since epoch
	DIFF_IN_SECONDS="$(($STOPTIME - $STARTTIME))"
	DIFF_ms="$(($DIFF_IN_SECONDS * 1000))"
	DURATION="$(($DIFF_IN_SECONDS / 3600 ))h $((($DIFF_IN_SECONDS % 3600) / 60))m $(($DIFF_IN_SECONDS % 60))s"
	# log the times in load_time.csv file
	echo "${STARTTIME},${STOPTIME},${DIFF_IN_SECONDS},${DURATION},${BENCHMARK},${DATABASE},${SCALE},${FILE_FORMAT},Query ${j}" >> ${LOG_FILE_EXEC_TIMES}

done