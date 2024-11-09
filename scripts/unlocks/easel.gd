extends Unlockable

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	check_unlocked()

func _on_interact() -> void:
	pass
