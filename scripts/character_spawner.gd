extends Node2D

var npc = preload("res://scenes/npc.tscn")
var char_count = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("spawn"):
		if char_count == 0:
			spawn_character("josephine")
		elif char_count == 1:
			spawn_character("oliver")

func spawn_character(character_name) -> void:
	var instance = npc.instantiate()
	add_child(instance)
	
	var character_resource = load("res://resources/characters/{name}.tres".format({"name": character_name}))

	if GameManager.data.character_glossary.histories.has(character_resource):
		character_resource.previous_recommendations = GameManager.data.character_glossary.histories[character_resource].previous_recommendations

	instance.set_character(character_resource)
		
	char_count += 1
