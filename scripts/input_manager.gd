extends Node
class_name InputManager

signal pressed_pause

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pressed_pause.emit()
		return
