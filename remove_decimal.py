import csv
import argparse

# Function to process the input file and remove decimal parts from numeric values
def process_file(input_file, output_file):
    with open(input_file, 'r') as f_in, open(output_file, 'w', newline='') as f_out:
        reader = csv.reader(f_in, delimiter='\t')  # Assuming tab-separated data
        writer = csv.writer(f_out, delimiter='\t')
        
        for row in reader:
            modified_row = []
            for item in row:
                try:
                    # If the item can be converted to a float, remove the decimal part
                    modified_item = str(int(float(item)))
                except ValueError:
                    # If conversion to float fails, keep the item as is (non-numeric)
                    modified_item = item
                modified_row.append(modified_item)
            writer.writerow(modified_row)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process input file and remove decimal parts from numeric values.")
    parser.add_argument("input_file", help="Path to the input CSV file")
    parser.add_argument("output_file", help="Path to the output CSV file")
    args = parser.parse_args()

    process_file(args.input_file, args.output_file)
