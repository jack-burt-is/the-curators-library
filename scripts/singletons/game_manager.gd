extends Node2D

# When set to 1, one minute = one in-game hour
# So if we want 10 hours to pass in 5 minutes, 2.0
var TIME_MULTIPLIER: float = 8.0

# Working days starts at 9am
var DAY_START_HOUR: float = 9.0

# Working day ends at 6pm
var DAY_END_HOUR: float = 18.0

var data: SaveGame
@onready var menu: Control = get_tree().get_first_node_in_group("pause_menu")
@onready var unlockables: Node2D = get_tree().current_scene.get_node("%Unlockables")

func _process(delta: float) -> void:
	update_time(delta)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):
		menu.show()
		get_tree().paused = true

func _ready() -> void:
	create_or_load_save()
	
	# Pre-load
	var style: DialogicStyle = load("res://dialogue/styles/bubble.tres")
	style.prepare()
	
func create_or_load_save() -> void:
	if SaveGame.save_exists():
		data = SaveGame.load_save()
	else:
		data = load("res://prefab/initial_save.tres")
		data.write_save()
		
func save_game() -> void:
	data.write_save()

func update_time(delta: float) -> void:
	data.current_minute += delta * TIME_MULTIPLIER
	
	if data.current_minute > 60.0:
		data.current_minute -= 60.0
		data.current_hour += 1.0
	
	if data.current_hour >= 24.0:
		data.current_hour -= 24.0
	
func start_new_day() -> void:
	SceneTransition.change_scene("res://scenes/calendar.tscn")
	CharacterSpawner.reset_spawner()
	
	# Wait 5 seconds
	await get_tree().create_timer(5).timeout
	
	for unlockable in unlockables.get_children():
		unlockable.check_unlocked()
	
	# Set date data
	data.current_day += 1
	data.current_hour = DAY_START_HOUR - 1
	data.current_minute = 30.0
	
	
