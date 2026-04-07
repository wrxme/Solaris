extends Resource
class_name GalaxyGenerationSettings

@export_group("Space")
@export var galaxy_size : Vector4

@export_group("Generation")
@export var number_of_stars : int = 120
@export var min_dist_between_stars : float = 75.0
@export var max_system_connections : int = 4
@export var bonus_link_percentage : float = 0.015
@export var max_bonus_link_length : float = 500.0

@export_group("Worlds")
@export var star_types : Array[StarType]
@export var world_types : Array[WorldType]

@export_group("Visuals")
@export var star_color : Color = Color.YELLOW
@export var star_radius : float = 5.0
@export var link_color : Color = Color.ALICE_BLUE
@export var link_width : float = 2.0
