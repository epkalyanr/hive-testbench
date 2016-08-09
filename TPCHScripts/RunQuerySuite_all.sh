#!/bin/bash
for i in {1..22}
do	
	./GetPatData.sh "Microsoft@1" ./tpch_queryexecute_all.sh $i tpch_query_$i
done