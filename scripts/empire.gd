extends Node
class_name Empire

var id : int
var empire_name : String

var systems : Array[SolarSystem]
var worlds : Array[World]

var population : int

# Resources
var minerals : int
var monthly_minerals : float
var food : int
var monthly_food : float
var energy : int
var monthly_energy : float

func _init(_id : int, starting_system : SolarSystem) -> void:
	id = _id
	
	GameEvents.tick.connect(_on_tick)
	GameEvents.new_month.connect(_on_month)
	
	systems.append(starting_system)

func _on_tick() -> void:
	pass

func _on_month() -> void:
	update_monthly_resources()
	collect_monthly_resources()

func claim_system(system : SolarSystem):
	system.owned_by = id
	systems.append(system)
	
	# Claim the star
	system.worlds[0].owned_by = self
	worlds.append(system.worlds[0])

func claim_world(world : World):
	var system = world.system
	
	# check if system is already owned
	if system in systems:
		if world in worlds:
			print("world already owned")
		else:
			print("adding world to empire!")
			worlds.append(world)
	
	# if system is not owned
	else:
		if world == system.worlds[0]:
			if world.owned_by == null:
				print("claiming system")
				claim_system(system)
			else:
				print("cannot claim another empire's world")
		else:
			print("cannot claim world if system is not owned")

func update_monthly_resources():
	monthly_energy = 0
	monthly_food = 0
	monthly_minerals = 0
	
	for w in worlds:
		monthly_energy += w.monthly_energy_production
		monthly_food += w.monthly_food_production
		monthly_minerals += w.monthly_mineral_production

func collect_monthly_resources():
	energy += ceil(monthly_energy)
	food += ceil(monthly_food)
	minerals += ceil(monthly_minerals)
