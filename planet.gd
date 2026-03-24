extends Node
class_name World

# World
var world_id : int
var world_name : String
var world_type : String
var distance_from_star : float

# Star
var star_luminosity : float
var star_type : String
var habitable_min : float = 5
var habitable_max : float = 7
var snow_line : float = 15


func generate(id:int, dist:float, lum:float, type:String="") -> void:
	world_id = id
	distance_from_star = dist
	star_luminosity = lum
	
	if type != "":
		world_type = type
		return
	
	if world_id == 0:
		world_type = "star"
		
		star_type = determine_star_type()
		return
	
	habitable_min *= sqrt(star_luminosity)
	habitable_max *= sqrt(star_luminosity)
	snow_line *= sqrt(star_luminosity)
	world_type = determine_planet_type()


func identify() -> String:
	var output = str(world_id) + "| world type: " + world_type
	
	if world_type != "star":
		output += " | distance: " + str(distance_from_star) + " clicks"
	elif world_type != "asteroid belt":
		output += " - " + star_type + " | luminosity: " + str(star_luminosity)
	
	return output

func determine_planet_type() -> String:
	if distance_from_star < habitable_min:
		if randi_range(0,10) > 2:
			return "scorched"
		else:
			return "gas giant"
	elif distance_from_star < habitable_max:
		if randi_range(0,25) > 24:
			return "gas_giant"
		elif randi_range(0,10) > 7:
			return "ocean"
		else:
			return "terrestrial"
	elif distance_from_star < snow_line:
		if randi_range(0,10) > 8:
			return "dwarf planet"
		else:
			return "gas giant"
	elif distance_from_star >= snow_line:
		if randi_range(0,10) > 2:
			return "dwarf planet"
		else:
			return "gas giant"
	return "unknown planet"

func determine_star_type() -> String:
	if randi_range(0,30) > 29:
		star_luminosity = 0.0
		return "black hole"
	elif randi_range(0,20) > 19:
		star_luminosity = 0.0
		return "neutron star"
	elif randi_range(0,20) > 15:
		star_luminosity = 0.5
		return "white dwarf"
	else:
		star_luminosity = randf_range(0.5,5)
		return "yellow star"
