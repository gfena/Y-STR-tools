# count haplogroups

sort countHG.txt | uniq -c | awk '{print $2 ": " $1 }'

awk '{ counts[$1]++ } END { for (group in counts) print group ": " counts[group] }' countHG.txt

awk '{ counts[$1 OFS $2]++ } END { for (key in counts) { split(key, arr, OFS); print arr[1] ": " arr[2] ": " counts[key] } }' countHG.txt > HGfreq.txt

awk '{ counts[$1 OFS $2]++; pop_counts[$1]++ } END { for (key in counts) { split(key, arr, OFS); print arr[1] ": " arr[2] ": " counts[key] } for (pop in pop_counts) { print pop ": Total " pop_counts[pop] } }' countHG.txt > HGfreq1.txt

## count pops

sort pops_to_count.txt | uniq -c
