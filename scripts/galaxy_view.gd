extends Node2D

@onready var parent = $".."
@onready var connection_mesh = $Connections
@onready var cam = $Camera2D

func render(_system):
	cam.make_current()

func instantiate_galaxy_map(galaxy : Galaxy) -> void:
	var connections = galaxy.connections
	
	# stars
	var groups := {}
	for system in galaxy.systems:
		var type = system.worlds[0].type
		
		if type not in groups:
			groups[type] = []
		
		groups[type].append(system)
	
	for type in groups:
		var stars = groups[type]
		
		var mesh = MultiMeshInstance2D.new()
		mesh.texture = stars[0].worlds[0].world_type.sprite
		
		var multimesh = MultiMesh.new()
		mesh.multimesh = multimesh
		multimesh.use_colors = true
		multimesh.mesh = QuadMesh.new()
		multimesh.mesh.size.x = 30.0
		multimesh.mesh.size.y = 30.0
		
		multimesh.instance_count = stars.size()
		
		for i in range(stars.size()):
			var star = stars[i]

			var t = Transform2D(0, star.position)
			multimesh.set_instance_transform_2d(i, t)
			
			#var color = star.worlds[0].color
			multimesh.set_instance_color(i, Color.WHITE)
		
		add_child(mesh)
	
	# Connections
	var line_multimesh = connection_mesh.multimesh
	line_multimesh.instance_count = connections.size()
	
	var thickness = 2.5

	for i in range(connections.size()):
		var pair = connections[i]
		var pos_a = pair[0].position
		var pos_b = pair[1].position
		
		var dir = (pos_b - pos_a)
		var dist = dir.length()
		
		if dist < 0.1:
			line_multimesh.set_instance_transform_2d(i, Transform2D(0, Vector2(-10000, -10000)))
			continue
		
		var x_axis = dir.normalized()
		var y_axis = x_axis.orthogonal()
		var t = Transform2D(
			x_axis * dist,
			y_axis * thickness,
			pos_a + (dir / 2.0)
		)
		
		line_multimesh.set_instance_transform_2d(i, t)
		connection_mesh.multimesh.set_instance_color(i, Color.WHITE)

func move_camera(input : Vector2) -> void:
	cam.position += input

func on_click(mouse_pos : Vector2):
	var clicked_star = find_star_at(mouse_pos)
			
	if clicked_star:
		parent.selected_system = clicked_star
		parent.switch_view()

func find_star_at(world_pos: Vector2):
	var closest_star = null
	var min_dist = parent.SELECT_RADIUS
	
	for star in parent.game.galaxy.systems:
		var dist = world_pos.distance_to(star.position)
		if dist < min_dist:
			min_dist = dist
			closest_star = star
			
	return closest_star
