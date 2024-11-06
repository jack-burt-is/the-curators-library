class_name SaveGame
extends Resource

const SAVE_GAME_BASE_PATH := "user://save"

# Date
@export var current_day: int = 1
@export var current_hour: float = 8.0
@export var current_minute: float = 0.0

# Complex data
@export var library_inventory: LibraryInventory = LibraryInventory.new()
@export var selected_book: Book
@export var character_glossary: CharacterGlossary = CharacterGlossary.new()

func write_save() -> void:
	ResourceSaver.save(self, get_save_path(), ResourceSaver.FLAG_CHANGE_PATH)

static func save_exists() -> bool:
	return ResourceLoader.exists(get_save_path())
	
static func load_save() -> Resource:
	return ResourceLoader.load(get_save_path())
	
static func get_save_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_GAME_BASE_PATH + extension
