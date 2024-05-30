input_file=$1
column_order=$2

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

