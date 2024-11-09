extends Unlockable

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var canvas: Control = %Canvas


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	check_unlocked()

func _on_interact() -> void:
	canvas.show()
