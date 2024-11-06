extends Control
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		unpause()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_continue_pressed() -> void:
	unpause()

func _on_save_pressed() -> void:
	GameManager.save_game()
	print("Saved")

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func unpause() -> void:
	hide()
	get_tree().paused = false
