extends Control

var selected_book: Book = null

var book_template_text = "[table={1}]
[cell][u]Title:[/u][/cell]
[cell][i]{title}[/i][/cell]
[cell][u]Author:[/u][/cell]
[cell][i]{author}[/i][/cell]
[cell][u]Genres:[/u][/cell]
[cell][i]{genres}[/i][/cell]
[cell][u]Released:[/u][/cell]
[cell][i]{released}[/i][/cell]
[cell][u]Synopsis:[/u][/cell]
[cell][i]{synopsis}[/i][/cell]
[/table]"

var character_bio_template_text = "[table={2}]
[cell][u]Name:[/u][/cell]
[cell][i]{name}[/i][/cell]
[cell][u]Age:[/u][/cell]
[cell][i]{age}[/i][/cell]
[/table]"

@onready var book_list: ItemList = $TabContainer/Library/MarginContainer/VBoxContainer/HBoxContainer/BookList
@onready var genre_list: ItemList = $TabContainer/Library/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/GenreList
@onready var book_detail: RichTextLabel = $TabContainer/Library/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/BookDetail

@onready var character_list: ItemList = $TabContainer/Characters/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/CharacterList
@onready var bio_text: RichTextLabel = $TabContainer/Characters/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/CharacterInfoContainer/Bio/BioText
@onready var favourites_list: ItemList = $TabContainer/Characters/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/CharacterInfoContainer/Goals/Favourites/FavouritesList
@onready var previous_guesses_list: ItemList = $TabContainer/Characters/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/CharacterInfoContainer/CurrentFind/PreviousGuesses/PreviousGuessesList
@onready var hints_list: ItemList = $TabContainer/Characters/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/CharacterInfoContainer/CurrentFind/PreviousHints/HintsList
@onready var character_info_container: HBoxContainer = $TabContainer/Characters/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PanelContainer/MarginContainer/CharacterInfoContainer

@onready var characters: Array = Helpers.load_all_resources("res://resources/characters/")
@onready var genres: Array = Helpers.load_all_resources("res://resources/genres/")

var selected_character = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_info_container.hide()
	reload_books()
	populate_genres()
	populate_characters()
	GameManager.new_day_started.connect(on_new_day_started)

func on_new_day_started() -> void:
	reload_books()
	populate_characters()
	
func reload_books(genre: Genre = null) -> void:
	book_list.clear()
	for book in GameManager.data.library_inventory.books:
		if not genre or book.genres.has(genre):
			book_list.add_item(book.to_string())
	
func populate_genres() -> void:
	for genre in genres:
		genre_list.add_item(genre.name)
		
func populate_characters() -> void:
	character_list.clear()
	for character in characters:
		if GameManager.data.character_glossary.histories.has(character):
			character_list.add_item(character.name)
		else:
			character_list.add_item("???", null, false)

func _on_item_list_item_selected(index: int) -> void:
	var book_name = book_list.get_item_text(index)
	selected_book = GameManager.data.library_inventory.books.filter(func(book): return book.to_string() == book_name).front()
	book_detail.text = book_template_text.format({
		"title": selected_book.title,
		"author": selected_book.author,
		"genres": Helpers.array_to_string(selected_book.genres),
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

func _on_character_list_item_selected(index: int) -> void:
	selected_character = characters[index]
	update_character_info()
	character_info_container.show()
	
func update_character_info():
	# Bio
	var history = GameManager.data.character_glossary.histories[selected_character]
	bio_text.text = character_bio_template_text.format({
		"name": selected_character.name,
		"age": 69
	})
	
	# Favourite Books
	favourites_list.clear()
	for i in selected_character.favourite_books.size():
		if history.books_found > i:
			favourites_list.add_item(selected_character.favourite_books[i].to_string())
		else:
			favourites_list.add_item("???")
	
	# Previous Recommendations
	previous_guesses_list.clear()
	for book in history.previous_recommendations:
		previous_guesses_list.add_item(book.title)
		
	# Hints
	hints_list.clear()
	if not history.books_found == selected_character.favourite_books.size():
		var relevant_hint = selected_character.hints[history.books_found]
		var revealed = history.previous_recommendations.size()
		
		#TODO: The below works but makes it so you can see the next hint once you've given a book. Come back to this
		#if history.days_visited[-1] == GameManager.data.current_day:
			#revealed += 1
			
		for i in relevant_hint.hints.size():
			if revealed > i:
				hints_list.add_item(relevant_hint.hints[i])
			else:
				hints_list.add_item("???")

func _on_draw() -> void:
	if selected_character:
		update_character_info()
