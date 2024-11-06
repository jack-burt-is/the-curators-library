extends Node2D

var data: SaveGame
@onready var menu: Control = get_tree().get_first_node_in_group("pause_menu")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):
		menu.show()
		get_tree().paused = true

func _ready() -> void:
	create_or_load_save()
	
func create_or_load_save() -> void:
	if SaveGame.save_exists():
		data = SaveGame.load_save()
	else:
		data = SaveGame.new()
		data.write_save()
	print(data)
		
func save_game() -> void:
	data.write_save()
