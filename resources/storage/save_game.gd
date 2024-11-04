class_name SaveGame
extends Resource

const SAVE_GAME_BASE_PATH := "user://save"

@export var library_inventory: Resource = LibraryInventory.new()

func write_save() -> void:
	ResourceSaver.save(self, get_save_path())

static func save_exists() -> bool:
	return ResourceLoader.exists(get_save_path())
	
static func load_save() -> Resource:
	return ResourceLoader.load(get_save_path())
	
static func get_save_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_GAME_BASE_PATH + extension
