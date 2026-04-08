#game_manager.gd
extends Node2D
class_name GameManager

@export var galaxy_generation_settings : GalaxyGenerationSettings

@onready var time_txt = $UI/Time
@onready var system_txt = $UI/sys

var galaxy : Galaxy
var game_timer : GameTimer
var input : InputManager
var render : RenderManager

var use_star_color : bool = true
var is_paused : bool = true

var galaxy_view : bool = true
var focus : int = 0

# automatically called by Godot on start :)
func _ready() -> void:
	var start_time = Time.get_ticks_usec()
	# create game components
	startup_game()
	
	var end_time = Time.get_ticks_usec()
	var total_time : float = (end_time - start_time)
	var total_time_ms : float = total_time/1000
	var total_time_s : float = total_time_ms / 1000
	
	if total_time_ms > 10000:
		print(str(galaxy.systems.size()) + " systems generated in " + str(total_time_s) + " s")
	else:
		print(str(galaxy.systems.size()) + " systems generated in " + str(total_time_ms) + " ms")
	
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
	input.pressed_speed_up.connect(game_timer.increase_tick_speed)
	input.pressed_slow_down.connect(game_timer.decrease_tick_speed)
	add_child(game_timer)
	
	# generate galaxy
	if !galaxy_generation_settings:
		galaxy_generation_settings = GalaxyGenerationSettings.new()
	galaxy = Galaxy.new(galaxy_generation_settings)
	add_child(galaxy)
	
	render = RenderManager.new(self)
	add_child(render)

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
