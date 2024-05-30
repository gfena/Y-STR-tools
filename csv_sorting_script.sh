#!/bin/bash

# Usage: reorder_columns.sh input_file column_order > output_file

input_file=$1
column_order=$2

awk -v order="$column_order" '
BEGIN {
    # Split the column order into an array
    split(order, order_array, ",")

    # Create a mapping of old column indices to new column indices
    for (i = 1; i <= length(order_array); i++) {
        column_map[order_array[i]] = i
    }
}

{
    # Reorder the columns based on the specified order
    line = ""
    for (i = 1; i <= NF; i++) {
        line = line $column_map[i] == 0 ? "" : $column_map[i] " "
    }
    print line
}
' "$input_file"


chmod +x reorder_columns.sh

./reorder_columns.sh input.txt 3,1,2 > output.txt


################################## OR

old order: DYS456	DYS389I	DYS390	DYS389II	DYS458	DYS19	DYS385a	DYS385b	DYS393	DYS391	DYS439	DYS635	DYS392	GATA-H4	DYS437	DYS438	DYS448

new order:
DYS393	DYS390	DYS19	DYS391	385a	385b	426	388	DYS439	DYS389I	DYS392	DYS389II	DYS458	459a	459b	455	454	447	DYS437	DYS448	449	464a	464b	464c	464d	460	GATA-H4	YCAIIa	YCAIIb	DYS456	607	576	570	CDYa	CDYb	442	DYS438	531	578	395a	395b	590	537	641	472	406	511	425	413a	413b	557	594	436	490	534	450	444	481	520	446	617	568	487	572	640	492	565	461	462	A10	DYS635	1B07	441	445	452	463	485	495	505	508	522	532	533	540	556	643

#!/bin/bash

test_toSort.csv

# Usage: reorder_columns.sh input_file column_order > output_file

input_file=test_toSort.csv
column_order="DYS393	DYS390	DYS19	DYS391	385a	385b	426	388	DYS439	DYS389I	DYS392	DYS389II	DYS458	459a	459b	455	454	447	DYS437	DYS448	449	464a	464b	464c	464d	460	GATA-H4	YCAIIa	YCAIIb	DYS456	607	576	570	CDYa	CDYb	442	DYS438	531	578	395a	395b	590	537	641	472	406	511	425	413a	413b	557	594	436	490	534	450	444	481	520	446	617	568	487	572	640	492	565	461	462	A10	DYS635	1B07	441	445	452	463	485	495	505	508	522	532	533	540	556	643"

awk -v order="$column_order" '
BEGIN {
    # Split the column order into an array
    split(order, order_array, "\t")

    # Create a mapping of old column names to new column indices
    for (i = 1; i <= NF; i++) {
        column_map[$i] = i
    }
}

{
    # Reorder the columns based on the specified order
    line = ""
    for (i = 1; i <= length(order_array); i++) {
        line = line $column_map[order_array[i]] " "
    }
    print line
}
' "$input_file"


bash reorder_columns.sh test_toSort.csv "DYS393	DYS390	DYS19	DYS391	385a	385b	426	388	DYS439	DYS389I	DYS392	DYS389II	DYS458	459a	459b	455	454	447	DYS437	DYS448	449	464a	464b	464c	464d	460	GATA-H4	YCAIIa	YCAIIb	DYS456	607	576	570	CDYa	CDYb	442	DYS438	531	578	395a	395b	590	537	641	472	406	511	425	413a	413b	557	594	436	490	534	450	444	481	520	446	617	568	487	572	640	492	565	461	462	A10	DYS635	1B07	441	445	452	463	485	495	505	508	522	532	533	540	556	643" > Sorted_output.txt

######## other
#!/bin/bash

# Usage: reorder_columns.sh input_file > output_file

input_file=$1

awk '
BEGIN {
    # Define the mapping of old column names to new column names
    mapping["DYS456"] = "DYS393"
    mapping["DYS389I"] = "DYS390"
    mapping["DYS390"] = "DYS19"
    mapping["DYS389II"] = "DYS391"
    mapping["DYS458"] = "385a"
    mapping["DYS19"] = "385b"
    mapping["DYS385a"] = "426"
    mapping["DYS385b"] = "388"
    mapping["DYS393"] = "DYS439"
    mapping["DYS391"] = "DYS389I"
    mapping["DYS439"] = "DYS392"
    mapping["DYS635"] = "DYS389II"
    mapping["DYS392"] = "DYS458"
    mapping["GATA-H4"] = "459a"
    mapping["DYS437"] = "459b"
    mapping["DYS438"] = "455"
    mapping["DYS448"] = "454"
    # ... continue mapping all columns ...

    # Set the input and output field separators
    FS = "\t"
    OFS = "\t"
}

{
    # Reorder the columns based on the mapping
    line = ""
    for (i = 1; i <= NF; i++) {
        line = line mapping[$i] ? mapping[$i] OFS : ""
    }
    print line
}
' "$input_file"

./reorder_columns.sh input.txt > output.txt



