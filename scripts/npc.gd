class_name NPC
extends CharacterBody2D

@export var speed: float = 80.0
@export var timer_length: float = 10
@export var timer_variation: float = 0.5

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var help: Sprite2D = $Help

@onready var target_positions: Array[Node] = get_tree().get_nodes_in_group("nav_point")
@onready var navigation_leave: Node2D = get_tree().current_scene.get_node("%NavigationLeave")

@onready var dialog_marker: Marker2D = $DialogMarker

@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var camera: Camera2D = get_tree().current_scene.get_node("%Camera")

var target_reached = false
var interacting = false
var leaving = false
var interactable = true

@export var character: Character
var footstep_frames: Array = [1, 5]

var made_purchase = false

func _process(delta: float) -> void:
	
	if Dialogic.current_timeline != null:
		animated_sprite.play("idle")
		return
	
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	if target_reached or interacting:
		velocity = direction * 0
	else:
		velocity = direction * speed * delta * 40
		
	if leaving and target_reached:
		self.queue_free()
		
	# Flip sprite
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
		
	# Play animation
	if velocity.x != 0 or velocity.y != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
	move_and_slide() 
	

func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.timeline_started.connect(_on_timeline_started)
		
	make_path()

func _on_interact() -> void:
	help.hide()
	
	if Dialogic.current_timeline != null or not interactable:
		return
			
	if character:
		var layout = Dialogic.start(character.generate_dialogic_timeline())
		
		var char_resource = "res://dialogue/characters/{name}.dch".format({"name": character.name.to_lower()})		
		var character_loaded = load(char_resource)
			
		layout.register_character(character_loaded, dialog_marker)
		
func make_path() -> void:
	navigation_agent.target_position = target_positions.pick_random().global_position
	
func _on_timer_timeout() -> void:
	target_reached = false
	
	if made_purchase:
		make_purchase()
		return
		
	make_path()

func _on_navigation_agent_2d_target_reached() -> void:
	target_reached = true
	var lower_bound = timer_length - (timer_length * timer_variation)
	var upper_bound = timer_length + (timer_length * timer_variation)
	var delay = randf_range(lower_bound, upper_bound)
	timer.start(delay)
	
	if not character:
		var chance_of_purchase = 0.2
		if randf() < chance_of_purchase:
			made_purchase = true
			
	else:
		if not character.have_spoken:
			help.show()
	
func _on_dialogic_signal(argument:String):
	if character:	
		if argument == "character_finished_" + character.name:
			GameManager.data.character_glossary.end_character_arc(character)
		
		if argument == "book_given_" + character.name:
			character.previous_recommendations.append(GameManager.data.selected_book)
			GameManager.data.character_glossary.update_character(character)
			GameManager.purchase_made()
			
		if argument == "leave_" + character.name:
			trigger_character_exit()
		
		
func _on_timeline_started() -> void:
	camera.zoom_in()
	timer.paused = true

func _on_timeline_ended() -> void:
	camera.reset_zoom()
	timer.paused = false

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "idle": return
		
	if animated_sprite.frame in footstep_frames:
		audio_stream_player.play()
		
func set_character(character_input) -> void:
	character = character_input
	animated_sprite.sprite_frames = character.sprite_frames
	character.have_spoken = false
	interaction_area.interact = Callable(self, "_on_interact")
	
func trigger_character_exit() -> void:
	interactable = false
	timer.stop()
	leaving = true
	target_reached = false
	navigation_agent.target_position = navigation_leave.global_position
	
func make_purchase() -> void:
	GameManager.purchase_made()
	trigger_character_exit()
