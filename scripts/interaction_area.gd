extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

var enabled = true

var interact: Callable = func():
	pass


func _on_body_entered(_body: Node2D) -> void:
	if enabled:
		InteractionManager.register_area(self)

func _on_body_exited(_body: Node2D) -> void:
	if enabled:
		InteractionManager.unregister_area(self)
