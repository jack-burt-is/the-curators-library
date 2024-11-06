class_name CharacterGlossary
extends Resource

@export var histories = {}

func update_character(updated_character) -> void:
	var history = CharacterHistory.new()
	history.previous_recommendations = updated_character.previous_recommendations
	histories[updated_character] = history
	
