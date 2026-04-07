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

func _init(star_types : Array[StarType], world_types : Array[WorldType]) -> void:
	generate_system(star_types, world_types)

func generate_system(star_types : Array[StarType], world_types : Array[WorldType]) -> void:
	# Create the star
	var type : StarType = star_types[randi_range(0,star_types.size() - 1)]
	type.size = randf_range(type.size_range[0],type.size_range[0])
	star = World.new(type)
	add_child(star)
	worlds.append(star)
	#
	#var dist = 10
	#while dist < 400:
		#dist += randf_range(45,150)
		#
		#var world_size = randf_range(8,20)
		#var w = World.new(type, dist)
		#add_child(w)
		#worlds.append(w)

func add_connection(endpoint : SolarSystem) -> void:
	connections.append(endpoint)
