extends Node
class_name StarSystem

var sys_id : int
var worlds : Array

func identify():
	print("")
	print("System " + str(sys_id) + ":")
	for i in worlds:
		print(i.identify())

func generate(id:int) -> void:
	sys_id = id
	
	# create star
	var star = World.new()
	star.generate(0, 0.0, 0)
	add_child(star)
	worlds.append(star)
	
	if star.star_luminosity == 0.0:
		var num_asteroid_belt = randi_range(1, 2)
		@warning_ignore("confusable_local_declaration")
		var dist = 0.0
		for i in range(0, num_asteroid_belt):
			if i == 1:
				dist = randf_range(5,8)
			else:
				dist = randf_range(25,40)
			var b = World.new()
			b.generate(i,dist,star.star_luminosity,"asteroid belt")
			add_child(b)
			worlds.append(b)
		return
	
	# create 0-10 planets and append to planets
	var num_planets = randi_range(1, 10)
	var dist = 0.0
	for i in range(1, num_planets + 1):
		if i < 3:
			dist += randf_range(0.25,8)
		else:
			dist += randf_range(0.25,30)
		if dist > 41 * sqrt(star.star_luminosity):
			break
		
		var p = World.new()
		p.generate(i,dist,star.star_luminosity)
		add_child(p)
		worlds.append(p)
