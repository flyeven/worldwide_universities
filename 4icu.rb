# http://www.4icu.org/reviews/rankings/university-ranking-2.htm

require 'nokogiri'
require 'open-uri'
require 'json'
require 'pp'

json = File.read('us.json')
us = JSON.parse(json)

us.each do |obj|
  rank = {worldRanking:3,fadfa:4} 
  obj.merge!(rank)
  pp obj
end

# pp obj
