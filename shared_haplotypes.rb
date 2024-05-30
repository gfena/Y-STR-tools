require 'csv'

# Extract unique haplotypes for each population
def extract_unique_haplotypes(data)
  unique_haplotypes = Hash.new { |h, k| h[k] = [] }
  data.each do |row|
    population = row['Population']
    haplotype = row['Haplotype']
    unique_haplotypes[population] << haplotype unless unique_haplotypes[population].include?(haplotype)
  end
  unique_haplotypes
end

# Find shared haplotypes between populations
def find_shared_haplotypes(unique_haplotypes)
  shared_haplotypes = Hash.new { |h, k| h[k] = [] }
  unique_haplotypes.each_pair do |population, haplotypes|
    other_populations = unique_haplotypes.keys - [population]
    other_populations.each do |other_population|
      unique_haplotypes[other_population].each do |haplotype|
        shared_haplotypes[[population, other_population]] << haplotype if haplotypes.include?(haplotype)
      end
    end
  end
  shared_haplotypes.reject { |(pop1, pop2), haplotypes| haplotypes.empty? }
end

# Write shared haplotypes to a file
def write_shared_haplotypes(shared_haplotypes, filename)
  CSV.open(filename, 'w') do |csv|
    csv << ['Pop1', 'Pop2', 'Shared haplotype']
    shared_haplotypes.each_pair do |(pop1, pop2), haplotypes|
      next if pop1 >= pop2 # Skip if pop1 >= pop2
      haplotypes.each { |haplotype| csv << [pop1, pop2, haplotype] }
    end
  end
end

# Summarize shared haplotypes between populations
def summarize_shared_haplotypes(shared_haplotypes)
  summary = Hash.new(0)
  shared_haplotypes.each do |(pop1, pop2), haplotypes|
    summary[[pop1, pop2]] = haplotypes.size
  end
  summary
end

# Write summary of shared haplotypes to a file
def write_summary(summary, filename)
  CSV.open(filename, 'w') do |csv|
    csv << ['Pop1', 'Pop2', 'Number of Shared haplotypes']
    summary.each_pair { |(pop1, pop2), count| csv << [pop1, pop2, count] }
  end
end

# Calculate total number of unique haplotypes for each population
def calculate_total_unique_haplotypes(unique_haplotypes)
  total_unique_haplotypes = {}
  unique_haplotypes.each do |population, haplotypes|
    total_unique_haplotypes[population] = haplotypes.size
  end
  total_unique_haplotypes
end

# Write total number of unique haplotypes for each population to a file
def write_total_unique_haplotypes(total_unique_haplotypes, filename)
  CSV.open(filename, 'w') do |csv|
    csv << ['Population', 'Total Unique Haplotypes']
    total_unique_haplotypes.each { |population, count| csv << [population, count] }
  end
end

# Check if the input file is provided as a command-line argument
input_file = ARGV[0]

# Check if the input file is provided
if input_file.nil?
  puts "Usage: ruby shared_haplotypes.rb inputfile"
  exit
end

# Read input data from CSV file
data = CSV.read(input_file, headers: true)

# Extract unique haplotypes for each population
unique_haplotypes = extract_unique_haplotypes(data)

# Find shared haplotypes between populations
shared_haplotypes = find_shared_haplotypes(unique_haplotypes)

# Print results
write_shared_haplotypes(shared_haplotypes, 'shared_haplotypes.csv')

summary = summarize_shared_haplotypes(shared_haplotypes)

write_summary(summary, 'shared_haplotypes_summary.csv')

total_unique_haplotypes = calculate_total_unique_haplotypes(unique_haplotypes)

write_total_unique_haplotypes(total_unique_haplotypes, 'total_unique_haplotypes.csv')

