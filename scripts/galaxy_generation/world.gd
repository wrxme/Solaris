# world.gd
extends Node
class_name World

var position : Vector2
var type : String = "unknown"
var world_type : WorldType
var size : float
var distance_from_center : float
var color : Color = Color.DEEP_SKY_BLUE
var sprite : Texture2D
var speed := 50.0
var angle : float = 0.0
var radius : float = 0.0

var owned_by : Empire
var system : SolarSystem

var worlds : Array
var target_position: Vector2 = Vector2.ZERO
var previous_position: Vector2 = Vector2.ZERO

var last_tick_time: float = 0.0
var estimated_tick_duration: float = 0.1
var time_since_last_tick: float = 0.0

var monthly_food_production : float
var monthly_food_consumption : float
var monthly_mineral_production : float
var monthly_mineral_consumption : float
var monthly_energy_production : float
var monthly_energy_consumption : float

func _init(_world_type : WorldType, _system : SolarSystem, _distance:float = 0.0) -> void:
	world_type = _world_type
	type = world_type.name
	size = world_type.size
	sprite = world_type.sprite
	system = _system
	
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
		
		setup_resources()

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

func spawn_moon(moon_type : WorldType, _system : SolarSystem, dist : float) -> void:
	var moon = World.new(moon_type, _system, dist)
	add_child(moon)
	worlds.append(moon)

func setup_resources():
	var x = randi_range(0,2)
	if x == 0:
		monthly_energy_production = randi_range(1,5)
	if x == 1:
		monthly_food_production = randi_range(1,5)
	if x == 2:
		monthly_mineral_production = randi_range(1,5)
