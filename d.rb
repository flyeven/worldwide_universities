require 'nokogiri'
require 'open-uri'
require 'json'

detailDoc = Nokogiri::HTML(open("http://www.webometrics.info/en/detalles/tsaa.ru"))

dtrs = detailDoc.css('table#mytable tbody tr'){ |tr| tr }
dtr = dtrs[0]
WorldRanking = dtr.children[0].children[0].text
ContinentalRanking = dtr.children[1].children[0].text
CountryRank = dtr.children[2].children[0].text
Presence = dtr.children[3].children[0].text

puts "WorldRanking #{WorldRanking},#{ContinentalRanking},#{CountryRank}, #{Presence}"
