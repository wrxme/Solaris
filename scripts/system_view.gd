extends Node2D

signal clicked_world(world : World)

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

func on_click(mouse_pos : Vector2):
	var world = find_obj_at(mouse_pos)
	if world:
		world = world.reference
		clicked_world.emit(world)

func find_obj_at(world_pos: Vector2):
	var closest_obj = null
	var min_dist = get_parent().SELECT_RADIUS
	
	var objs = []
	for world in objects.get_children():
		objs.append(world)
		for moon in world.get_children():
			objs.append(moon)
	
	for obj in objs:
		var dist = world_pos.distance_to(obj.global_position)
		if dist < min_dist:
			min_dist = dist
			closest_obj = obj
			
	return closest_obj
