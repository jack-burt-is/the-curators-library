extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var shop_interface: Control = %ShopInterface

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	shop_interface.show()
