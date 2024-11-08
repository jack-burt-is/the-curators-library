class_name NPC
extends CharacterBody2D

@export var speed: float = 80.0
@export var timer_length: float = 10
@export var timer_variation: float = 0.5

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var target_positions: Node2D = get_tree().current_scene.get_node("%NavigationPoints")
@onready var navigation_leave: Node2D = get_tree().current_scene.get_node("%NavigationLeave")

@onready var dialog_marker: Marker2D = $DialogMarker

@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var camera: Camera2D = get_tree().current_scene.get_node("%Camera")
var default_zoom: Vector2 = GameManager.data.zoom
var dialog_zoom: Vector2 = default_zoom + Vector2(2, 2)
var target_zoom: Vector2 = default_zoom
var zoom_speed: float = 10

var target_reached = false
var interacting = false
var leaving = false

@export var character: Character
var footstep_frames: Array = [1, 5]

func _process(delta: float) -> void:
	
	camera.zoom = camera.zoom.move_toward(target_zoom, zoom_speed * delta)
	
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
		
	interaction_area.interact = Callable(self, "_on_interact")
	make_path()

func _on_interact() -> void:
	if Dialogic.current_timeline != null:
		return
			
	var layout = Dialogic.start(character.generate_dialogic_timeline())
	
	var char_resource = "res://dialogue/characters/{name}.dch".format({"name": character.name.to_lower()})		
	var character_loaded = load(char_resource)
		
	layout.register_character(character_loaded, dialog_marker)
	
func make_path() -> void:
	navigation_agent.target_position = target_positions.get_children(false).pick_random().global_position
	
func _on_timer_timeout() -> void:
	target_reached = false
	make_path()

func _on_navigation_agent_2d_target_reached() -> void:
	target_reached = true
	var lower_bound = timer_length - (timer_length * timer_variation)
	var upper_bound = timer_length + (timer_length * timer_variation)
	var delay = randf_range(lower_bound, upper_bound)
	timer.start(delay)
	
func _on_dialogic_signal(argument:String):
	if argument == "character_finished_" + character.name:
		GameManager.data.character_glossary.end_character_arc(character)
	
	if argument == "book_given_" + character.name:
		character.previous_recommendations.append(GameManager.data.selected_book)
		GameManager.data.character_glossary.update_character(character)
		
	if argument == "leave_" + character.name:
		trigger_character_exit()
		
		
func _on_timeline_started() -> void:
	target_zoom = dialog_zoom

func _on_timeline_ended() -> void:
	target_zoom = default_zoom

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "idle": return
		
	if animated_sprite.frame in footstep_frames:
		audio_stream_player.play()
		
func set_character(char) -> void:
	character = char
	animated_sprite.sprite_frames = character.sprite_frames
	character.have_spoken = false
	
func trigger_character_exit() -> void:
	timer.stop()
	leaving = true
	target_reached = false
	navigation_agent.target_position = navigation_leave.global_position
