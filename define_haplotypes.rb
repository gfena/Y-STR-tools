require 'csv'

# Read input data from CSV file
data = CSV.read('Fulldataset_ready.csv', headers: true)

# Iterate over each row and concatenate the values with a hyphen separator
data.each do |row|
  haplotype_values = row.fields[7..-1] # Exclude the first 7 columns
  haplotype = haplotype_values.join('-')
  row['Haplotype'] = haplotype
end

# Write the updated data to a new CSV file
CSV.open('updated_data.csv', 'w') do |csv|
  csv << data.headers
  data.each { |row| csv << row }
end

