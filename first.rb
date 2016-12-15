require 'csv'
# get CSV file from command line argumnet
filename = ARGV.first
csv_input = open(filename)

#convert 10star ratings to 5star scale
def convertRatings(rating)
  if rating == 10
    return 5
  elsif rating >= 7
    return 4
  elsif rating >= 5
    return 3
  elsif rating >= 2
    return 2
  elsif rating == 1
    return 1
  end
end

#build 2d array of csv data
csv_array = CSV.read(csv_input)

puts csv_array.inspect

#create keys in a hash for each new dimensionExternalId found and push the reviewIds into an array in that hash for the corresponding value
dimensionExternalId = {}

csv_array.each do |row|
  if dimensionExternalId.key?(row[1])
    puts "dimensionExternalId[row[1]]: #{dimensionExternalId[row[1]]}"
    if dimensionExternalId[row[1]].key?(convertRatings(row[2].to_i))
      puts 'working up top'
      dimensionExternalId[(row[1])][(convertRatings(row[2].to_i))].push(row[0])
    else
      puts "creating array for #{dimensionExternalId[row[1]][convertRatings(row[2].to_i)]}"
      dimensionExternalId[row[1]][convertRatings(row[2].to_i)] = []
      dimensionExternalId[row[1]][convertRatings(row[2].to_i)].push(row[0])
    end
  else
    puts "creating #{dimensionExternalId[row[1]]} hash, array, and pushing #{row[0]}"
    dimensionExternalId[row[1]] = {}
    dimensionExternalId[row[1]][convertRatings(row[2].to_i)] = []
    dimensionExternalId[row[1]][convertRatings(row[2].to_i)].push(row[0])
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
