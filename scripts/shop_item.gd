extends Node

@onready var cost: Label = $VBoxContainer/Actions/Cost
@onready var description: Label = $VBoxContainer/Description
@onready var add_to_cart: Button = $VBoxContainer/Actions/AddToCart
@onready var texture_rect: TextureRect = $VBoxContainer/MarginContainer/TextureRect

var item: Resource

signal add_item_to_cart(book)

func init_item(resource: Resource):
	cost.text = str(resource.cost)
	description.text = resource.to_string()
	item = resource
	
	if "texture" in item:
		texture_rect.texture = item.texture

func _on_add_to_cart_pressed() -> void:
	add_item_to_cart.emit(item)
