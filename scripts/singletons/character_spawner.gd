extends Node2D

@onready var navigation_leave: Node2D = get_tree().current_scene.get_node("%NavigationLeave")
@onready var spawn_parent: Node2D = get_tree().current_scene.get_node("%SpawnedNpcs")

var npc = preload("res://scenes/npc.tscn")

var visiting_characters: Array[Character]
var spawn_times: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_spawner()
	
func reset_spawner() -> void:
	visiting_characters.clear()
	spawn_times.clear()
	
	calculate_eligible_characters()
	calculate_random_shoppers()
	calculate_spawn_times()
	
	var children = spawn_parent.get_children()
	for child in children:
		child.free()

func calculate_eligible_characters() -> void:
	var histories = GameManager.data.character_glossary.histories
	var characters = load_all_characters("res://resources/characters/")
	for character in characters:
		var chance_of_visiting = 0.0
		var base_chance = 1.0
		
		# Slightly lower the chance of a new character with each new one
		base_chance -= visiting_characters.size() / 10.0
		if base_chance > 0.8:
			base_chance = 0.8
		
		# If never been in the store before
		if not histories.has(character) or histories[character].days_visited.is_empty():
			chance_of_visiting = base_chance / character.visit_rarity
		
		# Finished and never to return
		elif histories[character].finished:
			break
			
		# Rare and been here before
		elif GameManager.data.current_day - histories[character].days_visited[-1] >= 1:
			if character.visit_rarity > 3:
				chance_of_visiting = base_chance / (character.visit_rarity / 3.0)
			else:
				chance_of_visiting = base_chance / character.visit_rarity
					
		var is_visiting = randf() < chance_of_visiting
		if is_visiting: 
			visiting_characters.append(character)
			print("Visit from ", character.name, "(" , chance_of_visiting, ")")
		else:
			print("No visit from ", character.name, "(" , chance_of_visiting, ")")
			
func calculate_random_shoppers():
	var shoppers_range = get_shopper_range()
	var num_shoppers = randi_range(shoppers_range[0], shoppers_range[1])
	
	# Spawn non-character shoppers
	for i in shoppers_range:
		visiting_characters.append(null)
			
func calculate_spawn_times():
	for i in range(visiting_characters.size()):
		# Generate a random number with a quadratic bias towards the start of the range
		var progress = pow(randf(), 2)  # Change 2 to a higher number for stronger bias
		var hour_offset = int(progress * ((GameManager.DAY_END_HOUR - 1) - GameManager.DAY_START_HOUR))
		var minute_offset = int(randf() * 60)
		
		# Calculate the exact time
		var call_hour = GameManager.DAY_START_HOUR + hour_offset
		var call_minute = minute_offset
		
		# No spawns before 9:15 please
		if call_hour == 9 and call_minute < 15:
			call_minute = 15

		# Add this time to the list of call times
		spawn_times.append(Vector2(call_hour, call_minute))
		
func _process(_delta: float):
	# Check if current time matches any of the call times
	for time in spawn_times:
		if int(time.x) == GameManager.data.current_hour and int(time.y) == int(GameManager.data.current_minute):
			var index = randi_range(0, visiting_characters.size() - 1)
			var character = visiting_characters.pop_at(index)
			spawn_character(character)
			spawn_times.erase(time)  # Remove time to ensure it's only called once
			break
			
func get_shopper_range() -> Vector2:
	# TODO: Popularity system
	return Vector2(4,6)

func spawn_character(character) -> void:
	var instance = npc.instantiate()
	instance.position = navigation_leave.global_position
	spawn_parent.add_child(instance)
	
	# If it's a character resource and not null
	if character:
		# Load save data into character resource
		if GameManager.data.character_glossary.histories.has(character):
			character.previous_recommendations = GameManager.data.character_glossary.histories[character].previous_recommendations
			character.books_found = GameManager.data.character_glossary.histories[character].books_found

		instance.set_character(character)

# Function to load all .tres files in the given directory
func load_all_characters(directory_path: String):
	var dir = DirAccess.open(directory_path)
	var characters = []
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# Check if the file has a .tres extension
			if file_name.ends_with(".tres"):
				var file_path = directory_path + file_name
				# Load the resource and add it to the array
				var resource = load(file_path)
				if resource:
					characters.append(resource)
			# Get the next file
			file_name = dir.get_next()
	
	dir.list_dir_end()
	return characters
