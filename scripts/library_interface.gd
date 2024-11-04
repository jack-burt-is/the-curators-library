extends Control

@onready var item_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/ItemList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload_books()
	
func reload_books() -> void:
	item_list.clear()
	for book in GameManager.data.library_inventory.books:
		item_list.add_item(book.title)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_random_book() -> void:
	var resource_files = DirAccess.get_files_at("res://resources/books/")

	var random_resource = resource_files[randi() % resource_files.size()]
	var book = load("res://resources/books/" + random_resource)
	print ("Adding " + book.resource_name)
	
	GameManager.data.library_inventory.add_item(book)
	
	reload_books()
	
	


func _on_button_pressed() -> void:
	add_random_book()
