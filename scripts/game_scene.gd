extends Node

@onready var game : GameManager = $GameManager
@onready var renderer : RenderManager = $RenderManager
@onready var input : InputManager = $InputManager

# automatically called by Godot on start :)
func _ready() -> void:
	var start_time = Time.get_ticks_usec()
	# create game components
	game.startup()
	renderer.startup(game, input)
	
	var end_time = Time.get_ticks_usec()
	var total_time : float = (end_time - start_time)
	var total_time_ms : float = total_time/1000
	var total_time_s : float = total_time_ms / 1000
	
	if total_time_ms > 10000:
		print(str(game.galaxy.systems.size()) + " systems generated in " + str(total_time_s) + " s")
	else:
		print(str(game.galaxy.systems.size()) + " systems generated in " + str(total_time_ms) + " ms")
	
	var w := -game.galaxy.systems.size()
	var h := 0
	for i in game.galaxy.systems:
		for j in i.worlds:
			w += 1
			if j.world_type.planet_zone == WorldType.SpawnZone.HABITABLE:
				h += 1
			for m in j.worlds:
				w += 1
				if m.type == "Habitable Moon":
					h += 1
	
	print(str(w) + " worlds generated")
	print(str(h) + " habitable worlds generated")
	print()
	
	for i in game.empires:
		print("empire " + str(i.id) + " spawned in system " + str(i.systems[0].id))
		
