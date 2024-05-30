

### NETWORK PIPELINE

scripts=/home/bioevo/Desktop/Giacomo/IberianRoma_PaternalDNA_Project/codes

# convert to no decimal if present

in=r1b.txt
out=r1b_nodec.txt

python3 $scripts/remove_decimal.py $in $out

#### Run R script to filter Haplogroups

in=/home/bioevo/Desktop/Giacomo/IberianRoma_PaternalDNA_Project/
out=/home/bioevo/Desktop/Giacomo/IberianRoma_PaternalDNA_Project/NETW10200/Inputfiles

Rscript $scripts/filter_haplogroups_auto.R $in/r1b_nodec.txt $out/r1b_

### convert to ych format

ruby script_convertv4.2.rb -i ./Inputfiles/r1b.txt -o ./Inputfiles/r1b.ych

