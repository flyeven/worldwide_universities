require "sqlite3"
require 'json'
require 'pp'

json = File.read('sranking.json')
wwus = JSON.parse(json)

# Open a database
db = SQLite3::Database.new "wwuniversities.db"

# Create a table
rows = db.execute <<-SQL
CREATE TABLE `wwuniversities` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `university_name` text,
  `country_code` text,
  `world_ranking` integer,
  `continental_rank` integer,
  `country_rank` integer,
  `presence_rank` integer,
  `domain` text,
  `detail_url` text
)
SQL

# rank: rank, name: school, url: url, detailurl: detailurl, country_code: country_code
# continentalRanking: continentalRanking, countryRank: countryRank, presence: presence

begin

  wwus.each do |university|

    db.execute("INSERT INTO wwuniversities ( university_name, country_code, world_ranking, continental_rank, country_rank, presence_rank, domain, detail_url)
            VALUES (?, ?,?,?,?, ?,?,?)", [university['name'], university['country_code'],university['rank'],university['continentalRanking'],university['countryRank'],university['presence'],university['url'],university['detailurl']])
  end
  rescue Exception => e
    puts e.message
  end


# ensure
#   begin
#
#   rescue Exception => e
#     puts e.message
#   end
# end
