# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


meshes = Mesh.create([{origin: 'A', destination: 'B', map_name: 'first_route', 	distance: 10},
 					  {origin: 'B', destination: 'D', map_name: 'second_route', distance: 15},
 					  {origin: 'A', destination: 'C', map_name: 'third_route', 	distance: 20},
 					  {origin: 'C', destination: 'D', map_name: 'fourth_route', distance: 30},
 					  {origin: 'B', destination: 'E', map_name: 'fifth_route', 	distance: 50},
 					  {origin: 'D', destination: 'E', map_name: 'sixth_route', 	distance: 30}
 					  ])
