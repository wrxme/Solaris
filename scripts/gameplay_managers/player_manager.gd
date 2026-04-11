extends Node

var player_id : int = 4
var player_empire : Empire
@onready var game : GameManager = $"../GameManager"
@onready var render = $"../RenderManager"
@onready var ui = $"../UIManager"

func _ready() -> void:
	game.game_set.connect(setup)
	render.clicked_world.connect(on_world_clicked)

func setup() -> void:
	player_empire = game.empires[player_id]

func on_world_clicked(world : World):
	if world.owner:
		return
	else:
		player_empire.claim_world(world)
