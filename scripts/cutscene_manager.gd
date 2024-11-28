extends Node2D

var cutscene_playing = false
@onready var hud: Control = %HUD

func _on_child_entered_tree(node: Node) -> void:
	cutscene_playing = true
	hud.hide()
	


func _on_child_exiting_tree(node: Node) -> void:
	cutscene_playing = false
	hud.show()
