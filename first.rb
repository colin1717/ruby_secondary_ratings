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
  # puts "row[0]: #{row[0]}"
  # puts "row[1]: #{row[1]}"
  # puts "row[2]: #{row[2]}"
  #
  # puts "dimensionExternalId: #{dimensionExternalId.inspect}"
  if dimensionExternalId.key?(row[1])
    puts "dimensionExternalId[row[1]]: #{dimensionExternalId[row[1]]}"
    if dimensionExternalId[row[1]].key?(row[2])
      puts 'working up top'
      dimensionExternalId[(row[1])][(row[2])].push(row[0])
    else
      puts "creating array for #{dimensionExternalId[row[1]][row[2]]}"
      dimensionExternalId[row[1]][row[2]] = []
      dimensionExternalId[row[1]][row[2]].push(row[0])
    end
  else
    puts "creating #{dimensionExternalId[row[1]]} hash, array, and pushing #{row[0]}"
    dimensionExternalId[row[1]] = {}
    dimensionExternalId[row[1]][row[2]] = []
    dimensionExternalId[row[1]][row[2]].push(row[0])
  end
end

puts dimensionExternalId.inspect

# #loop through dimensionExternalId hash and create a file for each key.  Then write each reviewID from that dimensionExternalId in the file
# dimensionExternalId.each do |dimensionExternalIdKey, reviewArray|
#   outputFile = File.open("#{dimensionExternalIdKey}.txt", "w")
#   dimensionExternalId["#{dimensionExternalIdKey}"].each do |review|
#     outputFile.puts(review)
#   end
#   outputFile.close
# end
