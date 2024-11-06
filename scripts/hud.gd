extends Control

@onready var texture_rect: TextureRect = $MarginContainer/PanelContainer/MarginContainer/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.data.selected_book != null:
		texture_rect.show()
	else:
		texture_rect.hide()
