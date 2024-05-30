require 'csv'

# Extract unique haplotypes for each population and haplogroup
def extract_unique_haplotypes(data)
  unique_haplotypes = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = [] } }
  data.each do |row|
    population = row['Population']
    haplogroup = row['HG']
    haplotype = row['Haplotype']
    unique_haplotypes[population][haplogroup] << haplotype unless unique_haplotypes[population][haplogroup].include?(haplotype)
  end
  unique_haplotypes
end

# Find shared haplotypes between populations for each haplogroup
def find_shared_haplotypes(unique_haplotypes)
  shared_haplotypes = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = [] } }
  unique_haplotypes.each_pair do |population, haplogroups|
    haplogroups.each_pair do |haplogroup, haplotypes|
      other_populations = unique_haplotypes.keys - [population]
      other_populations.each do |other_population|
        unique_haplotypes[other_population][haplogroup].each do |other_haplotype|
          haplotypes.each do |haplotype|
            shared_haplotypes[[population, other_population]][haplogroup] << [haplotype, other_haplotype] if similar_haplotypes?(haplotype, other_haplotype)
          end
        end
      end
    end
  end
  shared_haplotypes.reject { |(pop1, pop2), haplogroups| haplogroups.values.all?(&:empty?) }
end

# Check if two haplotypes are similar (differ by only one number)
def similar_haplotypes?(haplotype1, haplotype2)
  differences = 0
  haplotype1.split('-').zip(haplotype2.split('-')).each do |num1, num2|
    return false if (num1.to_i - num2.to_i).abs != 1
  end
  true
end

# Write shared haplotypes to a file
def write_shared_haplotypes(shared_haplotypes, filename)
  CSV.open(filename, 'w') do |csv|
    csv << ['Pop1', 'Pop2', 'HG', 'Similar haplotype 1', 'Similar haplotype 2']
    shared_haplotypes.each_pair do |(pop1, pop2), haplogroups|
      haplogroups.each_pair do |haplogroup, haplotypes|
        next if haplotypes.empty?
        haplotypes.each { |haplotype_pair| csv << [pop1, pop2, haplogroup, haplotype_pair[0], haplotype_pair[1]] }
      end
    end
  end
end

# Summarize shared haplotypes between populations for each haplogroup
def summarize_shared_haplotypes(shared_haplotypes)
  summary = Hash.new { |h, k| h[k] = Hash.new(0) }
  shared_haplotypes.each do |(pop1, pop2), haplogroups|
    haplogroups.each do |haplogroup, haplotypes|
      summary[[pop1, pop2]][haplogroup] = haplotypes.size
    end
  end
  summary
end

# Write summary of shared haplotypes to a file
def write_summary(summary, filename)
  CSV.open(filename, 'w') do |csv|
    csv << ['Pop1', 'Pop2', 'HG', 'Number of Similar haplotypes']
    summary.each_pair do |(pop1, pop2), haplogroups|
      haplogroups.each_pair { |haplogroup, count| csv << [pop1, pop2, haplogroup, count] }
    end
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

# Extract unique haplotypes for each population and haplogroup
unique_haplotypes = extract_unique_haplotypes(data)

# Find shared haplotypes between populations for each haplogroup
shared_haplotypes = find_shared_haplotypes(unique_haplotypes)

# Write shared haplotypes to a file
write_shared_haplotypes(shared_haplotypes, 'shared_haplotypes.csv')

# Summarize shared haplotypes between populations for each haplogroup
summary = summarize_shared_haplotypes(shared_haplotypes)

# Write summary of shared haplotypes to a file
write_summary(summary, 'shared_haplotypes_summary.csv')
