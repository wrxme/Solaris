# time_controller.gd
extends Node
class_name GameTimer

@export var start_time : int = 0
var speed_factor : float = 1.0

var is_timer_running : bool = false
var time : int = 0
var year : int = 0
var month : int = 0
var day : int = 0

var ui : Label

func initialize(time_txt : Label = null):
	time = start_time
	
	@warning_ignore("integer_division")
	year = (time / 360) + 2500
	var days_left_in_year : int = time % 360
	
	@warning_ignore("integer_division")
	month = (days_left_in_year / 30) + 1
	day = (days_left_in_year % 30) + 1
	
	if time_txt:
		ui = time_txt
		update_ui()

var timer : float = 0.0
func _process(delta: float):
	if !is_timer_running:
		return
	
	timer += delta
	
	var interval : float = 1.0 / max(speed_factor, 0.001)

	if timer >= interval:
		time += 1
		timer -= interval
		tick()

func tick():
	@warning_ignore("integer_division")
	year = (time / 360) + 2500
	var days_left_in_year : int = time % 360
	
	@warning_ignore("integer_division")
	month = (days_left_in_year / 30) + 1
	day = (days_left_in_year % 30) + 1
	
	if ui:
		update_ui()

func update_ui():
	var output = str(year) + "." + "%02d" % month + "." + "%02d" % day
	ui.text = output

func handle_pause(is_paused : bool) -> void:
	is_timer_running = !is_paused
