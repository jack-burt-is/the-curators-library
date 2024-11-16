extends Control

@onready var texture_rect: TextureRect = $MarginContainer/PanelContainer/MarginContainer/TextureRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GameManager.data.selected_book != null:
		texture_rect.show()
	else:
		texture_rect.hide()
