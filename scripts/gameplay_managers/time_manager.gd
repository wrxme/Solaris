# time_manager.gd
extends Node
class_name GameTimer

signal new_year

@export var start_time : int = 0
var speed_factor : float = 1.0

var is_timer_running : bool = false
var time : int = 0
var year : int = 0
var month : int = 0
var day : int = 0

var ui : Label

func _init() -> void:
	
	@warning_ignore("integer_division")
	year = (time / 360) + 2500
	var days_left_in_year : int = time % 360
	
	@warning_ignore("integer_division")
	month = (days_left_in_year / 30) + 1
	day = (days_left_in_year % 30) + 1

var timer : float = 0.0
func _process(delta: float):
	if !is_timer_running:
		return
	
	timer += delta
	
	var interval : float = 1.0 / max(speed_factor, 0.001)

	if timer >= interval:
		time += 1
		timer -= interval
		_tick()

func _tick():
	var prev_month := month
	var prev_year := year
	
	@warning_ignore("integer_division")
	year = (time / 360) + 2500
	var days_left_in_year : int = time % 360
	
	@warning_ignore("integer_division")
	month = (days_left_in_year / 30) + 1
	day = (days_left_in_year % 30) + 1
	
	if prev_month != month:
		GameEvents.new_month.emit()
	if prev_year	 != year:
		new_year.emit()
	
	GameEvents.tick.emit()

func handle_pause(is_paused : bool) -> void:
	is_timer_running = !is_paused

func increase_tick_speed():
	speed_factor += 1

func decrease_tick_speed():
	if speed_factor <= 1.0:
		return
	
	speed_factor -= 1
