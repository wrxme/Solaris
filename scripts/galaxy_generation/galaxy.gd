# galaxy.gd
extends Node2D
class_name Galaxy

var systems : Array
var connections : Array

func _init(gen_settings : GalaxyGenerationSettings) -> void:
	generate_galaxy(gen_settings)

func generate_galaxy(gen_settings : GalaxyGenerationSettings) -> void:
	generate_stars(
		gen_settings.number_of_stars, 
		gen_settings.galaxy_size, 
		gen_settings.min_dist_between_stars,
		gen_settings.star_types,
		gen_settings.world_types
	)
	generate_system_connections(
		gen_settings.bonus_link_percentage,
		gen_settings.max_system_connections,
		gen_settings.max_bonus_link_length
	)
	update_connections_within_systems()

func generate_stars(n_stars : int, size : Vector4i, min_dist : float, star_types : Array[StarType], world_types : Array[WorldType]) -> void:
	for i in range(0, n_stars):
		var s = SolarSystem.new(star_types, world_types)
		add_child(s)
		systems.append(s)
		
		s.id = i
		s.position = Vector2(randi_range(size[0], size[1]), randi_range(size[2], size[3]))
		
		# Ensure stars can't be placed too close to each other
		var flag: bool = true
		var max_attempts: int = 100
		var attempts: int = 0
		while flag and attempts < max_attempts:
			attempts += 1
			var new_pos = Vector2(randi_range(size[0], size[1]), randi_range(size[2], size[3]))
			   
			var is_valid = true
			for j in systems:
				if j.position.distance_to(new_pos) < min_dist:
					is_valid = false
					break
			
			if is_valid:
				s.position = new_pos
				flag = false

# This function is still kind of cooked
func generate_system_connections(bonus_link_percentage : float, max_system_connections : int, max_bonus_link_length : float) -> void:
	var possible_connections : Dictionary = {}
	
	# get every possible connection and its length
	for i in systems:
		for j in systems:
			if i != j:
				var c : Array
				if i.id < j.id:
					c = [i, j]
				else:
					c = [j, i]
				if not possible_connections.has(c):
					var dist = j.position.distance_to(i.position)
					possible_connections[c] = dist
	
	# sort all connections by length
	var sorted_paths : Array = possible_connections.keys()
	sorted_paths.sort_custom(func(a, b):
		return possible_connections[a] < possible_connections[b]
		)
	
	var c_atlas := {} # key = star id, value = number of connections
	
	var union = Union.new(systems.size())
	var added_connections = 0
	for c in range(sorted_paths.size()):
		if added_connections > systems.size() - 1:
			break
	
		if union.find(sorted_paths[c][0].id) != union.find(sorted_paths[c][1].id):
			union.unite(sorted_paths[c][0].id,sorted_paths[c][1].id)
			connections.append(sorted_paths[c])
			added_connections += 1
			
			# if it doesn't have a value, create one
			if c_atlas.get(sorted_paths[c][0].id):
				c_atlas.set(sorted_paths[c][0].id,c_atlas.get(sorted_paths[c][0].id) + 1)
			else:
				c_atlas.set(sorted_paths[c][0].id,1)
			
			if c_atlas.get(sorted_paths[c][1].id):
				c_atlas.set(sorted_paths[c][1].id,c_atlas.get(sorted_paths[c][1].id) + 1)
			else:
				c_atlas.set(sorted_paths[c][1].id,1)
	
	# add 5% of connections back
	var bonus_connections := 0
	for i in range(sorted_paths.size() - bonus_connections):
		if bonus_connections > ceil(bonus_link_percentage * (sorted_paths.size() - added_connections)):
			break
		
		if sorted_paths[i] in connections:
			continue
		
		var dist = sorted_paths[i][0].position.distance_to(sorted_paths[i][1].position)
		if dist < max_bonus_link_length:
			if c_atlas[sorted_paths[i][0].id] < max_system_connections and c_atlas[sorted_paths[i][1].id] < max_system_connections:
				connections.append(sorted_paths[i])
				bonus_connections += 1
				
				c_atlas.set(sorted_paths[i][0].id,c_atlas.get(sorted_paths[i][0].id) + 1)
				c_atlas.set(sorted_paths[i][1].id,c_atlas.get(sorted_paths[i][1].id) + 1)

func update_connections_within_systems() -> void:
	for i in connections:
		i[0].add_connection(i[1])
		i[1].add_connection(i[0])
