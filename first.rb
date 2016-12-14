require 'csv'
# get CSV file from command line argumnet
filename = ARGV.first
csv_input = open(filename)

#build 2d array of csv data
csv_array = CSV.read(csv_input)

puts csv_array.inspect

#create keys in a hash for each new dimensionExternalId found and push the reviewIds in the corresponding array
dimensionExternalId = {}

csv_array.each do |row|
  if dimensionExternalId.key?(row[1])
    dimensionExternalId[row[1]].push(row[0])
  else
    dimensionExternalId[row[1]] = []
    dimensionExternalId[row[1]].push(row[0])
  end
end

puts dimensionExternalId.inspect

#loop through dimensionExternalId hash and create a file for each key.  Then write each reviewID from that dimensionExternalId in the file
dimensionExternalId.each do |dimensionExternalIdKey, reviewArray|
  outputFile = File.open("#{dimensionExternalIdKey}.txt", "w")
  dimensionExternalId["#{dimensionExternalIdKey}"].each do |review|
    outputFile.puts(review)
  end
  outputFile.close
end
