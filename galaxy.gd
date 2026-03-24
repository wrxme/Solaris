extends Node
class_name Galaxy

var number_of_systems := 50

func _ready() -> void:
	for i in range(0,number_of_systems):
		var s = StarSystem.new()
		add_child(s)
		s.generate(i)
		s.identify()
	
	print("")
	print(str(num_of_worlds()) + " worlds")
	print(str(num_of_habitable_worlds()) + " habitable worlds")

func num_of_worlds() -> int:
	var c = 0
	for s in get_children():
		for p in s.get_children():
			c += 1
	return c

func num_of_habitable_worlds() -> int:
	var c = 0
	for s in get_children():
		for p in s.get_children():
			if p.world_type == "terrestrial" or p.world_type == "ocean":
				c += 1
	return c
