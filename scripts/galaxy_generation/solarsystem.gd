# SolarSystem.gd
extends Node2D
class_name SolarSystem

# Identifiers
var id : int
var star_name : String

# Properties
var connections : Array
var owned_by : int

# Contents
var worlds : Array
var star : World

func _init(_id : int, star_types : Array[StarType], world_types : Array[WorldType]) -> void:
	id = _id
	generate_system(star_types, world_types)

func generate_system(star_types : Array[StarType], world_types : Array[WorldType]) -> void:
	# Create the star
	var star_type : StarType = star_types[randi_range(0,star_types.size() - 1)].duplicate()
	star_type.size = 1.5 * randf_range(star_type.size_range[0],star_type.size_range[1])
	star = World.new(star_type)
	add_child(star)
	worlds.append(star)
	
	# Star's Planet Zones
	var dist = star_type.size + 10
	var lum_scale = sqrt(star_type.luminosity)
	var scorch_distance = dist + (star_type.scorch_zone_size * lum_scale)
	var inner_distance = scorch_distance + (star_type.inner_zone_size * lum_scale)
	var hab_distance = inner_distance + (star_type.habitable_zone_size * lum_scale)
	
	var scorched_worlds := fetch_world_types(world_types,WorldType.SpawnZone.SCORCH)
	var inner_worlds := fetch_world_types(world_types,WorldType.SpawnZone.INNER)
	var habitable_worlds := fetch_world_types(world_types,WorldType.SpawnZone.HABITABLE)
	var frozen_worlds := fetch_world_types(world_types,WorldType.SpawnZone.FROZEN)
	var moons := fetch_world_types(world_types,WorldType.SpawnZone.MOON)
	
	while dist < 10 * star.size:
		dist += randf_range(45,200)
		
		# Depending on the distance from the star, decide plaent type
		var world_type : WorldType
		if dist < scorch_distance:
			world_type = scorched_worlds[randi_range(0,scorched_worlds.size() - 1)].duplicate()
		elif dist < inner_distance:
			world_type = inner_worlds[randi_range(0,inner_worlds.size() - 1)].duplicate()
		elif dist < hab_distance:
			world_type = habitable_worlds[randi_range(0,habitable_worlds.size() - 1)].duplicate()
		else:
			world_type = frozen_worlds[randi_range(0,frozen_worlds.size() - 1)].duplicate()
		
		world_type.size = randf_range(world_type.size_range[0],world_type.size_range[1])
		dist += world_type.size
		var w = World.new(world_type, dist)
		add_child(w)
		worlds.append(w)
		
		var w_dist = w.size + randf_range(10,20)
		if w.size > 15:
			if randf_range(0,1)<0.51:
				var moon_type = moons[randi_range(0,moons.size()-1)].duplicate()
				moon_type.size = randf_range(moon_type.size_range[0],moon_type.size_range[1])
				w.spawn_moon(moon_type,w_dist)
				
				w_dist += moon_type.size + randf_range(1,15)
		if w.size > 20:
			if randf_range(0,1)<0.51:
				var moon_type = moons[randi_range(0,moons.size()-1)].duplicate()
				moon_type.size = randf_range(moon_type.size_range[0],moon_type.size_range[1])
				w_dist += moon_type.size
				w.spawn_moon(moon_type,w_dist)

func fetch_world_types(world_types : Array[WorldType], type : WorldType.SpawnZone) -> Array[WorldType]:
	var output : Array[WorldType] = []
	for i in world_types:
		if i.planet_zone == type:
			output.append(i)
	return output

func add_connection(endpoint : SolarSystem) -> void:
	connections.append(endpoint)
