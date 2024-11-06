extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var library_interface: Control = %LibraryInterface

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	library_interface.show()
	get_tree().paused = true
