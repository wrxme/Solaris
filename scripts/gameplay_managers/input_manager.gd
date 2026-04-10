extends Node
class_name InputManager

signal pressed_pause
signal pressed_enter
signal pressed_refresh
signal pressed_speed_up
signal pressed_slow_down

var input : Vector2

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pressed_pause.emit()
		return
	if event.is_action_pressed("enter"):
		pressed_enter.emit()
		return
	if event.is_action_pressed("Refresh"):
		pressed_refresh.emit()
		return
	if event.is_action_pressed("speed_up"):
		pressed_speed_up.emit()
		return
	if event.is_action_pressed("slow_down"):
		pressed_slow_down.emit()
		return

func _process(_delta: float) -> void:
	var x_input = Input.get_axis("left","right")
	var y_input = Input.get_axis("up","down")
	input = Vector2(x_input,y_input)
