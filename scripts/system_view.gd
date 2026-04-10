extends Node2D

@onready var cam : Camera2D = $Camera2D
@onready var objects = $Objects

func render(system : SolarSystem) -> void:
	for i in objects.get_children():
		i.queue_free()
	
	var worlds = system.worlds
	
	for world in worlds:
		var w = RenderObject.new(world, self)
		objects.add_child(w)
		
		for moon in world.worlds:
			var m = RenderObject.new(moon, w)
			w.add_child(m)

	cam.make_current()

func move_camera(input : Vector2) -> void:
	cam.position += input

func on_click(_mouse_pos : Vector2):
	pass
