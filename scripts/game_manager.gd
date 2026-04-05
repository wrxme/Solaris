#game_manager.gd
extends Node2D
class_name GameManager

var galaxy : Galaxy

# automatically called by Godot on start :)
func _ready() -> void:
	var g = Galaxy.new()
	add_child(g)
	galaxy = g
	
	galaxy.generate_galaxy(100)
	
	queue_redraw()

# draw all of the graphics
# called by queue_redraw()
func _draw() -> void:
	for c in galaxy.connections:
		draw_line(c[0].position,c[1].position,Color.ALICE_BLUE,2.0)
	for s in galaxy.systems:
		draw_circle(s.position,5,Color.YELLOW,true)
