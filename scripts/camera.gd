extends Camera2D

@onready var default_zoom: Vector2 = GameManager.data.zoom
@onready var reception: Node2D = get_tree().current_scene.get_node("%Reception")
@onready var close_zoom: Vector2 = default_zoom + Vector2(2, 2)
@onready var target_zoom: Vector2 = default_zoom
@onready var far_zoom: Vector2 = default_zoom + Vector2(-2, -2)

var base_zoom_speed: float = 10
var zoom_speed_modifier: float = 1

func _process(delta: float) -> void:
	zoom = zoom.move_toward(target_zoom, base_zoom_speed * delta * zoom_speed_modifier)

func zoom_in(modifier: float = 1):
	zoom_speed_modifier = modifier
	target_zoom = close_zoom

func reset_zoom(modifier: float = 1):
	zoom_speed_modifier = modifier
	target_zoom = default_zoom
	
func zoom_out(modifier: float = 1):
	zoom_speed_modifier = modifier
	target_zoom = far_zoom

func offset_up():
	drag_vertical_offset = -0.25
	
func reset_offset():
	drag_vertical_offset = 0
	drag_horizontal_offset = 0
