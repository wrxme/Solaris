extends Node
class_name InputManager

signal pressed_pause
signal pressed_left
signal pressed_right
signal pressed_enter
signal pressed_refresh

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pressed_pause.emit()
		return
	if event.is_action_pressed("left"):
		pressed_left.emit()
		return
	if event.is_action_pressed("right"):
		pressed_right.emit()
		return
	if event.is_action_pressed("enter"):
		pressed_enter.emit()
		return
	if event.is_action_pressed("Refresh"):
		pressed_refresh.emit()
		return
