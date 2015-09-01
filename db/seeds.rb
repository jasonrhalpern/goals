# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Tag.where(name: 'Business').first_or_create
Tag.where(name: 'Art').first_or_create
Tag.where(name: 'Overcoming Addiction').first_or_create
Tag.where(name: 'Running Marathon').first_or_create