extends Label

@onready var game = $"../../../GameManager"
var time : GameTimer

func _ready() -> void:
	GameEvents.tick.connect(_on_tick)
	
	call_deferred("get_that_timer_lol")

# This is not a good way to do this lmao
func get_that_timer_lol():
	if time == null:
		set_deferred("time", game.game_timer)
		call_deferred("get_that_timer_lol")
	else:
		_on_tick()

func _on_tick():
	var output = str(time.year) + "." + "%02d" % time.month + "." + "%02d" % time.day
	text = output
