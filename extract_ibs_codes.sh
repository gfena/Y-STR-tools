awk 'FNR==NR {map[$1]; next} $1 in map {print $1,$2,$3}' list.txt list_tofilter.txt > list_result.txt 
