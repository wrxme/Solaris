#game_manager.gd
extends Node2D
class_name GameManager

@export var number_of_stars : int = 100
@export var galaxy_x_bounds : Vector2i = Vector2i(20,1100)
@export var galaxy_y_bounds : Vector2i = Vector2i(20,600)
@export var star_color : Color = Color.YELLOW
@export var link_color : Color = Color.ALICE_BLUE


var galaxy : Galaxy

# automatically called by Godot on start :)
func _ready() -> void:
	var g = Galaxy.new()
	add_child(g)
	galaxy = g
	
	var g_size = Vector4i(galaxy_x_bounds[0],galaxy_x_bounds[1],galaxy_y_bounds[0],galaxy_y_bounds[1])
	galaxy.generate_galaxy(number_of_stars, g_size)
	
	queue_redraw()

# draw all of the graphics
# called by queue_redraw()
func _draw() -> void:
	for c in galaxy.connections:
		draw_line(c[0].position,c[1].position,link_color,2.0)
	for s in galaxy.systems:
		draw_circle(s.position,5,star_color,true)
