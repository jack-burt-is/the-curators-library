extends Control

@onready var genre_list: ItemList = %GenreList
@onready var book_list: GridContainer = %BookList
@onready var cart_items: VBoxContainer = %CartItems
@onready var subtotal_value: Label = %SubtotalValue

@onready var genres: Array = Helpers.load_all_resources("res://resources/genres/")
@onready var books: Array = Helpers.load_all_resources("res://resources/books/")

var shop_item = preload("res://scenes/shop_item.tscn")
var cart_item = preload("res://scenes/cart_item.tscn")

var current_genre_filter: Genre

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_genres()
	reload_books()

func populate_genres() -> void:
	for genre in genres:
		genre_list.add_item(genre.name)

func _on_genre_list_item_selected(index: int) -> void:
	current_genre_filter = genres[index]
	reload_books(current_genre_filter)

func _on_filter_clear_pressed() -> void:
	current_genre_filter = null
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
	# Ensure no duplicates
	if cart_items.get_child_count() > 0:
		for item in cart_items.get_children():
			if item.book_item == book:
				return
			
	var cart_item_instance = cart_item.instantiate()
	cart_items.add_child(cart_item_instance)
	cart_item_instance.init_cart_item(book)
	refresh_subtotal()


func _on_purchase_pressed() -> void:
	var total_cost = int(subtotal_value.text)
	
	if total_cost > GameManager.data.coins:
		# Reject purchase, insufficient funds
		print ("Too poor")
		return
	
	GameManager.data.coins -= total_cost
	
	# Clear cart
	var children = cart_items.get_children()
	for child in children:
		GameManager.data.library_inventory.add_item(child.book_item)
		child.free()
		
	reload_books(current_genre_filter)
	refresh_subtotal()

func refresh_subtotal(node: Node = null):
	var total_value = 0
	
	# Clear cart
	var children = cart_items.get_children()
	for child in children:
		if not node or not child == node:
			total_value += child.book_item.cost
		
	subtotal_value.text = str(total_value)


func _on_cart_items_child_exiting_tree(node: Node) -> void:
	refresh_subtotal(node)
