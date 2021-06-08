require_relative 'helpers.rb'


names1 = "chocolate egg chicken toast avacado".split(' ')
names2 = "cake pudding muffin marshmallow".split(' ')


1000.times do

  dish_name = "#{names1.sample} #{names2.sample}"
  image_url = 'https://www.recipesmadeeasy.co.uk/wp-content/uploads/2015/11/Christmas-pudding-1200sq-1.jpg'

  run_sql("insert into dishes (name, image_url) values ('#{dish_name}', '#{image_url}');")

end


