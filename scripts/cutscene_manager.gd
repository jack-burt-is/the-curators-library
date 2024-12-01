extends Node2D

var cutscene_playing = false
@onready var hud: Control = %HUD
@onready var letterbox: Control = %Letterbox

func _on_child_entered_tree(node: Node) -> void:
	cutscene_playing = true
	letterbox.enter()
	hud.hide()
	


func _on_child_exiting_tree(node: Node) -> void:
	cutscene_playing = false
	letterbox.exit()
	hud.show()
