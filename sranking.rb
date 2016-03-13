require 'nokogiri'
require 'open-uri'
require 'json'
require 'pp'

json = File.read('universities.json')
us = JSON.parse(json)

# pp obj

schools = []
errorurls = []

us.each do |obj|

begin
  detailDoc = Nokogiri::HTML(open("http://www.webometrics.info/#{obj["detailurl"]}"))

  dtrs = detailDoc.css('table#mytable tbody tr'){ |tr| tr }
  dtr = dtrs[0]
  worldRanking = dtr.children[0].children[0].text
  continentalRanking = dtr.children[1].children[0].text
  countryRank = dtr.children[2].children[0].text
  presence = dtr.children[3].children[0].text

  rank = {continentalRanking: continentalRanking, countryRank: countryRank, presence: presence}

  obj.merge!(rank)

  schools << obj

  puts "Total schools added: #{schools.size}"
  puts "sleeping for 2 secs"
  sleep(2)

rescue => ex
  print ex.backtrace.join("\n")
  errorurls << obj["detailurl"]
end

end

file = File.new(File.join(File.dirname(__FILE__), 'sranking.json'), 'w')
file.write(schools.to_json)
file.close
# puts schools
print  errorurls

file1 = File.new(File.join(File.dirname(__FILE__), 'errors.json'), 'w')
# errs = errorurls.map { |o| Hash[o.each_pair.to_a] }.to_json
file1.write(errorurls.to_json)
file1.close
