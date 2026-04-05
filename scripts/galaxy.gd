# galaxy.gd
extends Node2D
class_name Galaxy

var systems : Array
var connections : Array

# automatically called by Godot on start :)
func _ready() -> void:
	generate_galaxy(100)
	generate_system_connections()
	queue_redraw()

# Generate n_stars number of solar systems
func generate_galaxy(n_stars : int) -> void:
	for i in range(0, n_stars):
		var s = SolarSystem.new()
		s.id = i
		s.position = Vector2(randi_range(20,1000),randi_range(10,650))
		add_child(s)
		systems.append(s)

# I'll be honest this algorithm is uuuugly
# like it works but it is NOT ideal
func generate_system_connections() -> void:
	var unconnected_stars = []
	var connected_stars = []
	
	connected_stars.append(systems[0])
	unconnected_stars.append_array(systems.slice(1))
	
	# add one unconnected star to the connected stars
	connected_stars.append(unconnected_stars[0])
	unconnected_stars.remove_at(0)
	
	# take a random connected star and connect it to the nearest
	# unconnected star until all the stars are connected
	while !unconnected_stars.is_empty():
		var c = connected_stars[randi_range(0, connected_stars.size() - 1)]
		
		var nearest_star : SolarSystem
		var nearest_star_distance : float = INF
		
		# check every connection to find the shortest one
		for i in unconnected_stars:
			var dist = (c.position - i.position).length()
			
			if dist < nearest_star_distance:
				nearest_star = i
				nearest_star_distance = dist
		
		connections.append([c, nearest_star])
		
		connected_stars.append(nearest_star)
		unconnected_stars.erase(nearest_star)

# draw all of the graphics
# called by queue_redraw()
func _draw() -> void:
	for c in connections:
		draw_line(c[0].position,c[1].position,Color.ALICE_BLUE,2.0)
	for s in systems:
		draw_circle(s.position,5,Color.YELLOW,true)
