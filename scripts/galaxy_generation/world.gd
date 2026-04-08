# world.gd
extends Node2D
class_name World

var type : String = "unknown"
var world_type : WorldType
var size : float
var distance_from_center : float
var color : Color = Color.DEEP_SKY_BLUE
var speed := 50.0
var angle : float = 0.0
var radius : float = 0.0

var worlds : Array
var target_position: Vector2 = Vector2.ZERO
var previous_position: Vector2 = Vector2.ZERO

var last_tick_time: float = 0.0
var estimated_tick_duration: float = 0.1
var time_since_last_tick: float = 0.0

func _init(_world_type : WorldType, _distance:float = 0.0) -> void:
	world_type = _world_type
	type = world_type.name
	size = world_type.size
	
	distance_from_center = _distance
	position = Vector2(distance_from_center, 0)
	
	color = world_type.color
	
	GameEvents.tick.connect(_on_tick)
	
	if not _world_type is StarType:
		
		radius = distance_from_center
		speed = randf_range(0.5,4)
		angle = randf_range(0,200)
		
		var starting_pos = Vector2(cos(angle), sin(angle)) * radius
		position = starting_pos
		target_position = starting_pos
		previous_position = starting_pos
		
		last_tick_time = float(Time.get_ticks_msec()) / 1000.0
		
		_on_tick()

func _on_tick() -> void:
	var current_time = float(Time.get_ticks_msec()) / 1000
	estimated_tick_duration = current_time - last_tick_time
	last_tick_time = current_time
	time_since_last_tick = 0.0
	
	previous_position = target_position
	
	if distance_from_center > 0.0:
		# PHYS 211 BABYYYY
		var angular_velocity = speed / radius
		angle += angular_velocity
		
		target_position = Vector2(
			cos(angle),
			sin(angle)
			) * radius

func _process(delta: float) -> void:
	if estimated_tick_duration <= 0: return
	
	time_since_last_tick += delta
	
	var weight = time_since_last_tick / estimated_tick_duration
	weight = min(weight,1.0)
	
	position = previous_position.lerp(target_position, weight)

func spawn_moon(moon_type : WorldType, dist : float) -> void:
	var moon = World.new(moon_type, dist)
	add_child(moon)
	worlds.append(moon)
