########### Giacomo F. Ena, April 2024
########### For help and info see Github repository
###########

require 'optparse'
require 'csv'

# Function to parse the input file
def parse_input(input_file)
  populations = {}
  File.foreach(input_file).with_index do |line, index|
    next if index.zero? # Skip header row

    columns = line.chomp.split("\t")
    population_name = columns[0]
    individual_id = index - 1
    genotype_data = columns[2..-1]

    populations[population_name] ||= []
    populations[population_name] << { id: individual_id, data: genotype_data }
  end
  populations
end

# Function to construct the output string
def construct_output(populations, locus_separator, missing_data_identifier)
  output = "[Profile]\n Title=\" \"\n"
  output << " NbSamples=#{populations.size}\n"
  output << " GenotypicData=1\n GameticPhase=0\n"
  output << " DataType=STANDARD\n LocusSeparator=#{locus_separator}\n MissingData='#{missing_data_identifier}'\n\n[DATA]\n\n"

  populations.each do |population_name, individuals|
    output << "[[Samples]]\n"
    output << "   SampleName=\"#{population_name}\"\n"
    output << "   SampleSize=#{individuals.size}\n"
    output << "   SampleData={\n"

individuals.each do |individual|
      index_spaces = 10 - (Math.log10(individual[:id] + 1).to_i + 1) # Calculate the number of spaces needed for indentation
      index_indentation = ' ' * index_spaces # Create the indentation string based on the number of spaces needed

      # Print the line with the index number
      output << "#{index_indentation}#{individual[:id] + 1} 1 #{individual[:data].join(' ')}\n"
      # Print the line with indentation, but without the index number
      output << "#{index_indentation}#{' ' * (4 + Math.log10(individual[:id] + 1).to_i)}#{individual[:data].join(' ')}\n"
end
    
    output << "}\n"
  end

  output
end

# Main script
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby csv2arp.rb <input_file> <output_file> [options]"

  opts.on("-t SEPARATOR", "Specify the separator, TAB or WHITESPACE") do |separator|
    options[:separator] = separator
  end

  opts.on("-m IDENTIFIER", "Specify the missing data identifier, 0 or 99") do |identifier|
    options[:missing_data] = identifier
  end
end.parse!

input_file, output_file = ARGV

unless input_file && output_file && options[:separator] && options[:missing_data]
  puts "Usage: ruby csv2arp.rb <input_file> <output_file> -t <separator> -m <missing_data_identifier>"
  exit 1
end

populations = parse_input(input_file)
output = construct_output(populations, options[:separator], options[:missing_data])

File.open(output_file, "w") { |file| file.write(output) }
puts "Output written to #{output_file}"

