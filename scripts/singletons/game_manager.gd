extends Node2D

# When set to 1, one minute = one in-game hour
# So if we want 10 hours to pass in 5 minutes, 2.0
var TIME_MULTIPLIER: float = 2.0

# Working days starts at 9am
var DAY_START_HOUR: float = 9.0

# Working day ends at 6pm
var DAY_END_HOUR: float = 18.0

# Save data
var data: SaveGame

# Nodes
@onready var menu: Control = get_tree().get_first_node_in_group("pause_menu")
@onready var unlockables: Array[Node] = get_tree().get_nodes_in_group("unlockable")
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sfx_player = create_sfx_player()
@onready var cutscene_manager = get_tree().current_scene.get_node("%CutsceneManager")
@onready var fader = get_tree().current_scene.get_node("%Fader")

# Sounds
var purchase_sound = preload("res://sounds/purchase.wav")

# Variables
var initialised = false
var freeze_player = false

# Signals
signal new_day_started

var new_game = false

func _process(delta: float) -> void:
	if initialised:
		update_time(delta)
		
	# Everyone should leave at the end of the day
	if data.current_hour > DAY_END_HOUR:
		for npc in get_tree().get_nodes_in_group("npc"):
			npc.trigger_character_exit()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):
		menu.show()
		get_tree().paused = true
		
	if event.is_action_pressed("debug"):
		debug()

func _ready() -> void:
	create_or_load_save()

	# Pre-load
	var style: DialogicStyle = load("res://dialogue/styles/bubble.tres")
	style.prepare()
	
	await wait(2)
	
	fader.fade_in()
	
	# Load the intro cutscene if new game
	if new_game:
		cutscene_manager.add_child(load("res://scenes/cutscenes/intro.tscn").instantiate())
	
func create_sfx_player() -> AudioStreamPlayer:
	var sfx = AudioStreamPlayer.new()
	sfx.bus = "SFX"
	add_child(sfx)
	return sfx	
	
func create_or_load_save() -> void:
	if SaveGame.save_exists():
		data = SaveGame.load_save()
	else:
		data = load("res://prefab/initial_save.tres")
		data.write_save()
		new_game = true
		
	initialised = true
		
func save_game() -> void:
	data.write_save()

func update_time(delta: float) -> void:
	var augmentation = 1
	
	if cutscene_manager.cutscene_playing:
		augmentation = 0.01
		
	data.current_minute += delta * TIME_MULTIPLIER * augmentation
	
	if data.current_minute > 60.0:
		data.current_minute -= 60.0
		data.current_hour += 1.0
	
	if data.current_hour >= 24.0:
		data.current_hour -= 24.0
	
func start_new_day() -> void:
	freeze_player = true
	SceneTransition.change_scene("res://scenes/calendar.tscn")
	CharacterSpawner.reset_spawner()
	
	# Wait 5 seconds
	await get_tree().create_timer(5).timeout
	
	reset_player_position()
	
	for unlockable in unlockables:
		unlockable.check_unlocked()
	
	new_day_started.emit()
	
	# Set date data
	data.current_day += 1
	data.current_hour = DAY_START_HOUR - 1
	data.current_minute = 30.0
	
func reset_player_position() -> void:
	player.position = Vector2(-60,60)
	freeze_player = false
	
func play_sound(sound, volume = 0):
	sfx_player.volume_db = volume
	sfx_player.set_stream(sound)
	sfx_player.play()
	
func purchase_made():
	# Play sound
	play_sound(purchase_sound, -15)
		
	# Increment coinage
	data.coins += 100
	
func wait(duration):  
	await get_tree().create_timer(duration, false, false, true).timeout
	
func debug():
	cutscene_manager.add_child(load("res://scenes/cutscenes/intro.tscn").instantiate())
