extends Node

@onready var title: Label = $Title
@onready var cost: Label = $Actions/Cost

var item: Resource

func init_cart_item(resource: Resource):
	cost.text = str(resource.cost)
	title.text = resource.to_string()
	item = resource

func _on_remove_pressed() -> void:
	queue_free()
