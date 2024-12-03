extends Unlockable

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var canvas: Control = %Canvas


func _ready() -> void:
	if check_unlocked():
		interaction_area.interact = Callable(self, "_on_interact")
		interaction_area.enabled = true
	else:
		interaction_area.enabled = false

func _on_interact() -> void:
	canvas.show()
