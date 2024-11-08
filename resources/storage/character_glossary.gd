class_name CharacterGlossary
extends Resource

@export var histories = {}

func update_character(updated_character) -> void:
	var history = CharacterHistory.new()
	history.previous_recommendations = updated_character.previous_recommendations
	history.books_found = updated_character.books_found
	
	if histories.has(updated_character):
		history.days_visited = histories[updated_character].days_visited
	
	history.days_visited.append(GameManager.data.current_day)
	histories[updated_character] = history
	
func end_character_arc(updated_character) -> void:
	histories[updated_character].finished = true
