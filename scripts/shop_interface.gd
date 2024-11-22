extends Control

@onready var genre_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/Body/Filters/GenreList
@onready var book_list: GridContainer = $PanelContainer/MarginContainer/VBoxContainer/Body/MainContentContainer/MarginContainer/ScrollContainer/BooksList
@onready var cart_items: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/Body/CartContainer/VBoxContainer/MarginContainer/Cart/ScrollContainer/CartItems

@onready var genres: Array = Helpers.load_all_resources("res://resources/genres/")
@onready var books: Array = Helpers.load_all_resources("res://resources/books/")

var shop_item = preload("res://scenes/shop_item.tscn")
var cart_item = preload("res://scenes/cart_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_genres()
	reload_books()

func populate_genres() -> void:
	for genre in genres:
		genre_list.add_item(genre.name)

func _on_genre_list_item_selected(index: int) -> void:
	reload_books(genres[index])

func _on_filter_clear_pressed() -> void:
	reload_books()

func reload_books(genre: Genre = null) -> void:
	# Clear list first
	var children = book_list.get_children()
	for child in children:
		child.free()

	for book in books:
		if (not genre or book.genres.has(genre)) and not GameManager.data.library_inventory.books.has(book):
			var shop_item_instance = shop_item.instantiate()
			book_list.add_child(shop_item_instance)
			shop_item_instance.init_book(book)
			shop_item_instance.add_book_to_cart.connect(_add_book_to_cart)
			
func _add_book_to_cart(book: Book):
	var cart_item_instance = cart_item.instantiate()
	cart_items.add_child(cart_item_instance)
	cart_item_instance.init_cart_item(book)
