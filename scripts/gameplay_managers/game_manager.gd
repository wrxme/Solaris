#game_manager.gd
extends Node2D
class_name GameManager

@export var galaxy_generation_settings : GalaxyGenerationSettings

@onready var time_txt = $UI/Time
@onready var system_txt = $UI/sys

var galaxy : Galaxy
var game_timer : GameTimer
var input : InputManager

var is_paused : bool = true

var galaxy_view : bool = true
var focus : int = 0

# automatically called by Godot on start :)
func _ready() -> void:
	# create game components
	startup_game()
	
	print(str(galaxy.systems.size()) + " systems generated")
	
	var w := 0
	var h := 0
	for i in galaxy.systems:
		for j in i.worlds:
			w += 1
			if j.world_type.planet_zone == WorldType.SpawnZone.HABITABLE:
				h += 1
	
	print(str(w) + " worlds generated")
	print(str(h) + " habitable worlds generated")
	

func startup_game() -> void:
	# create input manger
	input = InputManager.new()
	input.pressed_pause.connect(on_pause_pressed)
	input.pressed_left.connect(on_left_pressed)
	input.pressed_right.connect(on_right_pressed)
	input.pressed_enter.connect(on_enter_pressed)
	add_child(input)
	
	# create time controller
	game_timer = GameTimer.new(time_txt)
	add_child(game_timer)
	
	# generate galaxy
	if !galaxy_generation_settings:
		galaxy_generation_settings = GalaxyGenerationSettings.new()
	galaxy = Galaxy.new(galaxy_generation_settings)
	add_child(galaxy)

# draw all of the graphics
# called by queue_redraw()
func _draw() -> void:
	if galaxy_view:
		for c in galaxy.connections:
			draw_line(c[0].position,c[1].position,galaxy_generation_settings.link_color,galaxy_generation_settings.link_width)
		for s in galaxy.systems:
			if s.id == focus:
				draw_circle(s.position,galaxy_generation_settings.star_radius + 5,Color.AQUA,true)
			else:
				draw_circle(s.position,galaxy_generation_settings.star_radius,galaxy_generation_settings.star_color,true)
	else:
		var screen_size = Vector2(DisplayServer.screen_get_size())
		for world in galaxy.systems[focus].worlds:
			draw_circle(screen_size / 2.0, world.distance_from_center, Color.WHITE, false)
			
			var pos = world.position + (screen_size / 2.0)
			draw_circle(pos,world.size,world.color,true)
			
			for moon in world.worlds:
				var mpos = moon.position + world.position + (screen_size / 2.0)
				draw_circle(mpos,moon.size,moon.color,true)

func _process(_delta: float) -> void:
	queue_redraw()

func on_pause_pressed() -> void:
	is_paused = !is_paused
	
	game_timer.handle_pause(is_paused)

func on_left_pressed() -> void:
	if focus == 0:
		focus = galaxy.systems.size() - 1
	else:
		focus -= 1
	
	system_txt.text = "Selected System: " + str(focus)

func on_right_pressed() -> void:
	if focus == galaxy.systems.size() - 1:
		focus = 0
	else:
		focus += 1
	
	system_txt.text = "Selected System: " + str(focus)

func on_enter_pressed() -> void:
	galaxy_view = !galaxy_view
