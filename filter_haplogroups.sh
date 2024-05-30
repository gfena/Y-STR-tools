
#### Run R script to filter Haplogroups

in=/home/bioevo/Desktop/Giacomo/IberianRoma_PaternalDNA_Project/
out=/home/bioevo/Desktop/Giacomo/IberianRoma_PaternalDNA_Project/NETW10200/Inputfiles

script=/home/bioevo/Desktop/Giacomo/IberianRoma_PaternalDNA_Project/codes/filter_haplogroups_autoR.R

Rscript $script $in/H_tofilter.txt $out/H_tofilter
