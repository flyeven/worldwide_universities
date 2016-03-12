require 'nokogiri'
require 'open-uri'
require 'json'

def getDetails(url)
  detailDoc = Nokogiri::HTML(open("http://www.webometrics.info/#{url}"))

  dtrs = detailDoc.css('table#mytable tbody tr'){ |tr| tr }
  dtr = dtrs[0]
  worldRanking = dtr.children[0].children[0].text
  continentalRanking = dtr.children[1].children[0].text
  countryRank = dtr.children[2].children[0].text
  presence = dtr.children[3].children[0].text

  puts "WorldRanking #{worldRanking},#{continentalRanking},#{countryRank}, #{presence}"
end

schools = []
(0..0).map do |page|
  doc = Nokogiri::HTML(open("http://www.webometrics.info/en/world?page=#{page}"))
  trs = doc.css('table.sticky-enabled tbody tr'){ |tr| tr}
  puts "Parsing page: #{page}"
  trs.map do |tr|
    rank = tr.children[0].children[0].text # get url
    url = tr.children[1].children[0].attributes['href'].value # get url
    school = tr.children[1].children[0].children[0].text # school name
    detailurl = tr.children[2].children[0].attributes['href'].value # get url
    country_code = tr.children[3].children[0].children[0].attributes['src'].value.split('/').last.split('.').first # country code

    schools << {rank: rank, name: school, url: url, detailurl: detailurl, country_code: country_code }
    getDetails(detailurl)
  end

  puts "Total schools added: #{schools.size}"
  puts "Done Parsing page: #{page}"
  puts "sleeping for 10 secs"
  sleep(10)
end

# file = File.new(File.join(File.dirname(__FILE__), 'us.json'), 'w')
# file.write(schools.to_json)
# file.close
# puts schools
