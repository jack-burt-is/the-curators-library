extends Control

@onready var item_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/ItemList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	reload_books()
	
func reload_books() -> void:
	item_list.clear()
	for book in GameManager.data.library_inventory.books:
		item_list.add_item(book.title + " by " + book.author)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_random_book() -> void:
	var resource_files = DirAccess.get_files_at("res://resources/books/")

	var random_resource = resource_files[randi() % resource_files.size()]
	var book = load("res://resources/books/" + random_resource)
	
	GameManager.data.library_inventory.add_item(book)
	
	reload_books()

func _on_button_pressed() -> void:
	add_random_book()

func _on_item_list_item_selected(index: int) -> void:
	GameManager.data.selected_book = GameManager.data.library_inventory.books[index]
	unpause()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		unpause()

func unpause() -> void:
	hide()
	get_tree().paused = false
