def replace_names(input_file, mapping_file, output_file)
  # Read mapping file into a hash
  mapping = {}
  File.foreach(mapping_file) do |line|
    id, pop = line.strip.split("\t")
    mapping[id] = pop
  end

  # Read input file, replace IDs with population names, and write to output file
  File.open(output_file, 'w') do |output|
    File.foreach(input_file) do |line|
      mapping.each do |id, pop|
        line.gsub!(id, pop)
      end
      output.puts line
    end
  end
end

# Check if command-line arguments are provided
if ARGV.length != 3
  puts "Usage: ruby replace_names.rb <input_file> <mapping_file> <output_file>"
  exit
end

# Assign command-line arguments to variables
input_file = ARGV[0]
mapping_file = ARGV[1]
output_file = ARGV[2]

replace_names(input_file, mapping_file, output_file)
