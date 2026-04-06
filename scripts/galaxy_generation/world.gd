# world.gd
extends Node2D
class_name World

var type : String = "unknown"
var size : float
var distance_from_center : float
var color : Color
var speed := 50.0
var angle : float = 0.0
var radius : float = 0.0

var worlds : Array

func _init(_type:String, _size:float, _distance:float = 0.0) -> void:
	type = _type
	size = _size
	distance_from_center = _distance
	radius = distance_from_center
	
	position = Vector2(distance_from_center, 0)
	
	determine_color()
	
	if type == "moon":
		radius = 35
	
	if type != "star" and size > 15:
		var moon = World.new("moon", 5, distance_from_center + 35)
		add_child(moon)
		worlds.append(moon)

func _physics_process(delta: float) -> void:
	if distance_from_center > 0.0:
		# PHYS 211 BABYYYY
		var angular_velocity = speed / radius
		angle += angular_velocity * delta
		
		var new_pos = Vector2(
			cos(angle),
			sin(angle)
			) * radius
		
		position = new_pos

func determine_color():
	if type == "star":
		color = Color.YELLOW
	elif type == "moon":
		color = Color.YELLOW_GREEN
