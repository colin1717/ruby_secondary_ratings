#This script creates the necessary input files for the Service Request - Modify Review Rating Entry.
#Specfically for clients switching from a 10Star ratings scale to 5Star ratings.  This Request addresses the secondary ratings values.
#It will output the needed files in the same directory the script runs in
#The script expects a CSV input file to be passed as an argument variable when the script is exectued

#To generate the input file run the following SQL query:
# SELECT rv.id, rre.DimensionExternalID AS 'Name', CAST(rre.Score AS CHAR) AS 'Value', P.Name
#    FROM Client c
#        JOIN ReviewVersion rv
#            ON c.ID = rv.ClientID
#        JOIN ReviewRatingEntry rre
#            ON rv.ID = rre.ReviewVersionID
#        JOIN Product P
#            ON rv.ProductId = P.ID
#    WHERE c.Name = 'CLIENT_NAME_GOES_HERE'
#    ORDER BY rre.DimensionExternalID

#Script by Colin Hancock

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

#create keys in a hash for each new dimensionExternalId found and push the reviewIds into an array in that hash for the corresponding value
dimensionExternalId = {}

csv_array.each do |row|
  if dimensionExternalId.key?(row[1])
    # puts "dimensionExternalId[row[1]]: #{dimensionExternalId[row[1]]}"
    if dimensionExternalId[row[1]].key?(convertRatings(row[2].to_i))
      # puts 'working up top'
      dimensionExternalId[(row[1])][(convertRatings(row[2].to_i))].push(row[0])
    else
      # puts "creating array for #{dimensionExternalId[row[1]][convertRatings(row[2].to_i)]}"
      dimensionExternalId[row[1]][convertRatings(row[2].to_i)] = []
      dimensionExternalId[row[1]][convertRatings(row[2].to_i)].push(row[0])
    end
  else
    # puts "creating #{dimensionExternalId[row[1]]} hash, array, and pushing #{row[0]}"
    dimensionExternalId[row[1]] = {}
    dimensionExternalId[row[1]][convertRatings(row[2].to_i)] = []
    dimensionExternalId[row[1]][convertRatings(row[2].to_i)].push(row[0])
  end
end

puts "dimensionExternalId: #{dimensionExternalId.inspect}"

#loop through dimensionExternalId hash. Loop thorugh valueObject hash and create a file for each valueObjectKey per dimensionExternalId. This corresponds to the distributed values for secondarry ratings for a review.
#write a line of text in each document for the reviewIds whose values need to go in that document
dimensionExternalId.each do |dimensionExternalIdKey, valueObject|

  valueObject.each do |valueObjectKey, valueArray|
    outputFile = File.open("#{dimensionExternalIdKey}-#{valueObjectKey}.txt", "w")
    valueArray.each do |valueId|
      puts "#{dimensionExternalIdKey}-#{valueObjectKey}: #{valueId}"
      outputFile.puts(valueId)
    end
    outputFile.close
  end

end

puts '<<=========================================================>>'
puts "      Created files to modify #{csv_array.length} secondary ratings"
puts '<<=========================================================>>'
