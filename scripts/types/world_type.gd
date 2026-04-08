extends Resource
class_name WorldType

enum SpawnZone {
	SCORCH,
	INNER,
	HABITABLE,
	FROZEN,
	MOON
}

@export var name : String
@export var size_range := Vector2(15,45)
var size : float
@export var color := Color.YELLOW
@export var planet_zone : SpawnZone = SpawnZone.HABITABLE
