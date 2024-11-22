extends Node

@onready var title: Label = $Title
@onready var cost: Label = $Actions/Cost

func init_cart_item(book: Book):
	cost.text = str(book.cost)
	title.text = book.to_string()

func _on_remove_pressed() -> void:
	queue_free()
