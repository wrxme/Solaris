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

func _init() -> void:
	generate_system()

func generate_system() -> void:
	# Create the star
	star = World.new("star", 30.0, 0)
	add_child(star)
	worlds.append(star)
	
	var dist = 10
	while dist < 400:
		dist += randf_range(45,150)
		
		var size = randf_range(8,20)
		var w = World.new("Unknown", size, dist)
		add_child(w)
		worlds.append(w)

func add_connection(endpoint : SolarSystem) -> void:
	connections.append(endpoint)
