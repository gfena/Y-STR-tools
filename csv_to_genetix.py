
input_file = "input_to_convert.csv"
output_file = "arlequin_updated_file.csv"

# Read the input file
with open(input_file, 'r') as f:
    lines = f.readlines()

# Open the output file for writing
with open(output_file, 'w') as f:
    prev_pop = None
    for line in lines:
        pop = line.strip()
        # Check if the current population is different from the previous one
        if pop != prev_pop:
            f.write("pop\n")  # Insert "pop" as a separate row
        f.write(pop + '\n')   # Write the current population to the output file
        prev_pop = pop

print("Updated file created:", output_file)
