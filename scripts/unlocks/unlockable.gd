class_name Unlockable
extends Node2D

@export var character: Character

func check_unlocked() -> void:
	if GameManager.data.character_glossary.histories.has(character) and GameManager.data.character_glossary.histories[character].finished:
		show()