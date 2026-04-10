extends Sprite2D
class_name RenderObject

var reference : Node
var parent : Node2D

func _init(_reference : Node, _parent : Node2D) -> void:
	reference = _reference
	parent = _parent
	
	position = reference.position
	
	var sprite = Sprite2D.new()
	sprite.texture = reference.sprite
	add_child(sprite)
	var s_scale = reference.size * Vector2(0.005,0.005)
	if s_scale.x < 0.05:
		s_scale = Vector2(0.06,0.06)
	sprite.scale = s_scale

func _process(_delta: float) -> void:
	if position == reference.position:
		return
	position = reference.position
	queue_redraw()

func _draw() -> void:
	#var child_local_pos = Vector2.ZERO
	var parent_local_pos = -position
	var radius = position.length()
	#draw_circle(child_local_pos, 10, Color.WHITE)
	draw_circle(parent_local_pos, radius, Color.WHITE, false, 2, true)
