extends Node2D

const VARIATION_RANGE: int = 3
const BOOKSHELF_WIDTH: int = 128
const BOOKSHELF_HEIGHT: int = 64

enum BookAmount { NONE, LOW, MEDIUM, HIGH }

@onready var books: Sprite2D = $Books

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_books(BookAmount.LOW)
		
func load_books(book_amount: BookAmount) -> void:
	var sprite_offset_y = 0
	match book_amount:
		BookAmount.LOW:
			sprite_offset_y = 1 * BOOKSHELF_HEIGHT
		BookAmount.MEDIUM:
			sprite_offset_y = 2 * BOOKSHELF_HEIGHT
		BookAmount.HIGH:
			sprite_offset_y = 3 * BOOKSHELF_HEIGHT

	books.texture.region.position = Vector2(randi_range(0, VARIATION_RANGE-1) * BOOKSHELF_WIDTH, sprite_offset_y)
