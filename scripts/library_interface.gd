extends Control

var selected_book: Book = null
var template_text = "[table={1}]
[cell][u]Title:[/u][/cell]
[cell][i]{title}[/i][/cell]
[cell][u]Author:[/u][/cell]
[cell][i]{author}[/i][/cell]
[cell][u]Released:[/u][/cell]
[cell][i]{released}[/i][/cell]
[cell][u]Synopsis:[/u][/cell]
[cell][i]{synopsis}[/i][/cell]
[/table]"

@onready var book_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BookList
@onready var genre_list: ItemList = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/GenreList
@onready var book_detail: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/BookDetail

@onready var genres: Array = Helpers.load_all_resources("res://resources/genres/")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload_books()
	populate_genres()
	
func reload_books(genre: Genre = null) -> void:
	book_list.clear()
	for book in GameManager.data.library_inventory.books:
		if not genre or book.genres.has(genre):
			book_list.add_item(book.to_string())
	
func populate_genres() -> void:
	for genre in genres:
		genre_list.add_item(genre.name)

func _on_item_list_item_selected(index: int) -> void:
	var book_name = book_list.get_item_text(index)
	selected_book = GameManager.data.library_inventory.books.filter(func(book): return book.to_string() == book_name).front()
	book_detail.text = template_text.format({
		"title": selected_book.title,
		"author": selected_book.author,
		"released": selected_book.released,
		"synopsis": selected_book.synopsis
	})
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		hide()

func _on_genre_list_item_selected(index: int) -> void:
	reload_books(genres[index])

func _on_filter_clear_pressed() -> void:
	reload_books()

func _on_close_pressed() -> void:
	hide()

func _on_select_book_pressed() -> void:
	GameManager.data.selected_book = selected_book
