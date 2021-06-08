# i want show the names of the dishes in our goodfoodhunting database

require 'pg'
require 'pry'


# connecting to create a connection
db = PG.connect(dbname: 'goodfoodhunting')

# returns an array of hashes - sort of
# always returns something that works like an array of hashes
dishes = db.exec("SELECT * FROM dishes;")


dishes.each do |dish|
  puts dish["image_url"]
end


db.close
