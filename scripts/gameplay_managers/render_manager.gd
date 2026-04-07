extends Node2D
class_name RenderManager

var game : GameManager

func _init(_game : GameManager) -> void:
	game = _game

func _draw() -> void:
	if game.galaxy_view:
		for c in game.galaxy.connections:
			draw_line(c[0].position,c[1].position,game.galaxy_generation_settings.link_color,game.galaxy_generation_settings.link_width)
		for s in game.galaxy.systems:
			if s.id == game.focus:
				draw_circle(s.position,game.galaxy_generation_settings.star_radius + 8,Color.YELLOW,false,5)
			if game.use_star_color:
				draw_circle(s.position,game.galaxy_generation_settings.star_radius,s.star.color,true)
			else:
				draw_circle(s.position,game.galaxy_generation_settings.star_radius,game.galaxy_generation_settings.star_color,true)
	else:
		var screen_size = Vector2(DisplayServer.screen_get_size())
		for world in game.galaxy.systems[game.focus].worlds:
			draw_circle(screen_size / 2.0, world.distance_from_center, Color.WHITE, false)
			
			var pos = world.position + (screen_size / 2.0)
			draw_circle(pos,world.size,world.color,true)
			
			for moon in world.worlds:
				var mpos = moon.position + world.position + (screen_size / 2.0)
				draw_circle(mpos,moon.size,moon.color,true)

func _process(_delta: float) -> void:
	queue_redraw()
