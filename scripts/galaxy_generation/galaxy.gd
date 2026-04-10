# galaxy.gd
extends Node
class_name Galaxy

var systems : Array
var connections : Array

func _init(gen_settings : GalaxyGenerationSettings) -> void:
	generate_galaxy(gen_settings)

func generate_galaxy(gen_settings : GalaxyGenerationSettings) -> void:
	generate_stars(gen_settings)
	generate_system_connections(
		gen_settings.bonus_link_percentage,
		gen_settings.max_system_connections,
		gen_settings.max_bonus_link_length
	)
	update_connections_within_systems()

func generate_stars(gen_settings : GalaxyGenerationSettings) -> void:
	for i in range(0, gen_settings.number_of_stars):
		var s = SolarSystem.new(i, gen_settings.star_types, gen_settings.world_types)
		add_child(s)
		systems.append(s)
		
		var x_min = gen_settings.galaxy_size[0]
		var x_max = gen_settings.galaxy_size[1]
		var y_min = gen_settings.galaxy_size[2]
		var y_max = gen_settings.galaxy_size[3]
		s.position = get_random_star_position(x_min,x_max,y_min,y_max)
		
		# Ensure stars can't be placed too close to each other
		var flag: bool = true
		var max_attempts: int = 100
		var attempts: int = 0
		while flag and attempts < max_attempts:
			attempts += 1
			var new_pos = get_random_star_position(x_min,x_max,y_min,y_max)
			   
			var is_valid = true
			for j in systems:
				if j.position.distance_to(new_pos) < gen_settings.min_dist_between_stars:
					is_valid = false
					break
			
			if is_valid:
				s.position = new_pos
				flag = false

func get_random_star_position(x_min:float,x_max:float,y_min:float,y_max:float) -> Vector2:
	var x_pos = randf_range(x_min, x_max)
	var y_pos = randf_range(y_min, y_max)
	return(Vector2(x_pos,y_pos))

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
