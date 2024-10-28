class_name Character
extends Resource

## Character's name (type String)
@export var name: String

## Player's relationship with character on a scale of 0 -> 100, where the default is 50 (type int)
@export var relationship: int

## The character's preferences in terms of genre
@export var taste_profile: Array[Taste]
