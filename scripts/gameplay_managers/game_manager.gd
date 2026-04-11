#game_manager.gd
extends Node
class_name GameManager

signal game_set

@export var galaxy_generation_settings : GalaxyGenerationSettings
@onready var input : InputManager = $"../InputManager"

var galaxy : Galaxy
var game_timer : GameTimer

var is_paused : bool = true

@export var num_of_empires : int = 5
var empires : Array[Empire]

func startup() -> void:
	# create input manger
	input.pressed_pause.connect(on_pause_pressed)
	
	# create time controller
	game_timer = GameTimer.new()
	input.pressed_speed_up.connect(game_timer.increase_tick_speed)
	input.pressed_slow_down.connect(game_timer.decrease_tick_speed)
	add_child(game_timer)
	
	# generate galaxy
	if !galaxy_generation_settings:
		galaxy_generation_settings = GalaxyGenerationSettings.new()
	galaxy = Galaxy.new(galaxy_generation_settings)
	add_child(galaxy)
	
	# create empires
	if num_of_empires > galaxy.systems.size():
		print("cannot have more empires than stars")
		num_of_empires = galaxy.systems.size()
	
	var starting_systems : Array[SolarSystem]
	for i in range(0,num_of_empires):
		var starting_system = galaxy.systems[randi_range(0, galaxy.systems.size() - 1)]
		var guessing = true
		while guessing:	
			if starting_system in starting_systems:
				starting_system = galaxy.systems[randi_range(0, galaxy.systems.size() - 1)]
			else:
				guessing = false
		
		starting_systems.append(starting_system)
		var empire = Empire.new(i,starting_system)
		add_child(empire)
		empires.append(empire)
	
	game_set.emit()

func on_pause_pressed() -> void:
	is_paused = !is_paused
	
	game_timer.handle_pause(is_paused)
