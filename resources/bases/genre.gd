class_name Genre
extends Resource

@export var name: String
@export var alternatives: Array[String]

func _to_string() -> String:
	return name
