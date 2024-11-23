extends Node

@onready var cost: Label = $VBoxContainer/Actions/Cost
@onready var description: Label = $VBoxContainer/Description
@onready var add_to_cart: Button = $VBoxContainer/Actions/AddToCart

var book_item: Book

signal add_book_to_cart(book)

func init_book(book: Book):
	cost.text = str(book.cost)
	description.text = book.to_string()
	book_item = book

func _on_add_to_cart_pressed() -> void:
	add_book_to_cart.emit(book_item)
