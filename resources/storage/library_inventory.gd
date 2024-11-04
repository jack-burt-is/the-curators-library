class_name LibraryInventory
extends Resource

@export var books: Array[Book]

func add_item(book) -> void:
	books.append(book)
	
func get_books() -> Array[Book]:
	return books
