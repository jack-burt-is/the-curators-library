extends Control

@onready var book_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BookList
@onready var genre_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/GenreList

@onready var genres: Array = Helpers.load_all_resources("res://resources/genres/")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload_books()
	populate_genres()
	
func reload_books(genre: Genre = null) -> void:
	book_list.clear()
	for book in GameManager.data.library_inventory.books:
		if not genre or book.genres.has(genre):
			book_list.add_item(book.title + " by " + book.author)
	
func populate_genres() -> void:
	for genre in genres:
		genre_list.add_item(genre.name)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_item_list_item_selected(index: int) -> void:
	GameManager.data.selected_book = GameManager.data.library_inventory.books[index]
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		hide()

func _on_genre_list_item_selected(index: int) -> void:
	reload_books(genres[index])

func _on_filter_clear_pressed() -> void:
	reload_books()


func _on_close_pressed() -> void:
	hide()
