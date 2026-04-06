#game_manager.gd
extends Node2D
class_name GameManager

@export var number_of_stars : int = 100
@export var galaxy_x_bounds : Vector2i = Vector2i(20,1100)
@export var galaxy_y_bounds : Vector2i = Vector2i(20,600)
@export var star_color : Color = Color.YELLOW
@export var link_color : Color = Color.ALICE_BLUE

@onready var time_txt = $UI/Time

var galaxy : Galaxy
var game_timer : GameTimer
var input : InputManager

var is_paused : bool = true

# automatically called by Godot on start :)
func _ready() -> void:
	# create input manger
	input = InputManager.new()
	input.pressed_pause.connect(on_pause_pressed)
	add_child(input)
	
	# create time controller
	game_timer = GameTimer.new()
	add_child(game_timer)
	game_timer.initialize(time_txt)
	
	# generate galaxy
	galaxy = Galaxy.new()
	add_child(galaxy)
	var g_size = Vector4i(galaxy_x_bounds[0],galaxy_x_bounds[1],galaxy_y_bounds[0],galaxy_y_bounds[1])
	galaxy.generate_galaxy(number_of_stars, g_size)
	
	# render
	queue_redraw()

# draw all of the graphics
# called by queue_redraw()
func _draw() -> void:
	for c in galaxy.connections:
		draw_line(c[0].position,c[1].position,link_color,2.0)
	for s in galaxy.systems:
		draw_circle(s.position,5,star_color,true)

func on_pause_pressed() -> void:
	is_paused = !is_paused
	
	game_timer.handle_pause(is_paused)
