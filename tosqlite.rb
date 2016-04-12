require 'nokogiri'
require 'open-uri'
require "sqlite3"
require 'json'
require 'pp'

def updateWRWU()
  # Open a database
  fdb = SQLite3::Database.new "flyabroadstudy.db"

  # Create a table
  rows = fdb.execute <<-SQL
  CREATE TABLE `wrwu` (
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

  wdb = SQLite3::Database.open "wwuniversities.db"

  rows = wdb.execute <<-SQL
      SELECT ul.university_name, ul.country_code, ul.world_ranking, ur.continental_rank, ur.country_rank, ur.presence_rank, ul.domain, ul.detail_url
      FROM wrwu ul
      LEFT JOIN wwuniversities ur
      ON ul.detail_url=ur.detail_url
      SQL

  rows.each  do |row|
    fdb.execute("INSERT INTO wrwu ( university_name, country_code, world_ranking, continental_rank, country_rank, presence_rank, domain, detail_url)
            VALUES (?, ?,?,?,?, ?,?,?)", row)
  end

end

updateWRWU()

def printErrors()
  # db = SQLite3::Database.new "wrwu.db"

  json = File.read('errors.json')
  errors = JSON.parse(json)

  errors.each do |err|

    begin
      detailDoc = Nokogiri::HTML(open("http://www.webometrics.info/#{err}"))

      dtrs = detailDoc.css('table#mytable tbody tr'){ |tr| tr }
      dtr = dtrs[0]
      worldRanking = dtr.children[0].children[0].text
      continentalRanking = dtr.children[1].children[0].text
      countryRank = dtr.children[2].children[0].text
      presence = dtr.children[3].children[0].text

      rank = {url: err, continentalRanking: continentalRanking, countryRank: countryRank, presence: presence}

      p rank

      # sleep(2)

    rescue => ex
      puts "#{err}:" + ex.message
    end

  end
end

# printErrors()

def WRWU()

  jsonu = File.read('universities.json',:encoding => 'UTF-8')
  universities = JSON.parse(jsonu)

  db = SQLite3::Database.open "wwuniversities.db"

  # {"rank":"1","name":"Harvard University","url":"http://www.harvard.edu/","detailurl":"/en/detalles/harvard.edu","country_code":"us"}
  rows = db.execute <<-SQL
  CREATE TABLE `wrwu` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `university_name` text,
    `country_code` text,
    `world_ranking` integer,
    `domain` text,
    `detail_url` text
  )
  SQL

  begin

    universities.each do |university|

      db.execute("INSERT INTO wrwu ( university_name, country_code, world_ranking, domain, detail_url)
              VALUES (?, ?,?,?,?)", [university['name'], university['country_code'],university['rank'],university['url'],university['detailurl']])
    end
    rescue Exception => e
      puts e.message
    end

end

# WRWU()

def errordetails()

  json = File.read('errors.json')
  errors = JSON.parse(json)

  # Open a database
  db = SQLite3::Database.open "wwuniversities.db"

  # Create a table
  rows = db.execute <<-SQL
  CREATE TABLE `errors` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `detail_url` text
  )
  SQL

  # rank: rank, name: school, url: url, detailurl: detailurl, country_code: country_code
  # continentalRanking: continentalRanking, countryRank: countryRank, presence: presence

    begin

      errors.each do |err|

        db.execute("INSERT INTO errors ( detail_url )
                VALUES (?)", err)
      end
    rescue Exception => e
      puts e.message
    end

end

# errordetails()

def completed()

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

end

# ensure
#   begin
#
#   rescue Exception => e
#     puts e.message
#   end
# end
