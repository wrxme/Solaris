extends Node
class_name Empire

var id : int
var empire_name : String

var systems : Array[SolarSystem]
var planets : Array[World]

var population : int

func _init(_id : int, starting_system : SolarSystem) -> void:
	id = _id
	
	GameEvents.tick.connect(_on_tick)
	GameEvents.new_month.connect(_on_month)
	
	systems.append(starting_system)

func _on_tick() -> void:
	pass

func _on_month() -> void:
	pass

func claim_system(system : SolarSystem):
	system.owned_by = id
	systems.append(system)
