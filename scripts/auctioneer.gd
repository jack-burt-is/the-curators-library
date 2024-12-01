extends CharacterBody2D

@export var speed: float = 80.0

var leaving = false
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialog_marker: Marker2D = $DialogMarker
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var character = preload("res://dialogue/characters/auctioneer.dch")
var target_reached = false

var footstep_frames: Array = [1, 5]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	
	if Dialogic.current_timeline != null:
		animated_sprite.play("idle")
		return
	
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	if target_reached:
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
	
func trigger_dialogue():
	var layout = Dialogic.start('intro')		
	layout.register_character(character, dialog_marker)

func move_to(position) -> void:
	target_reached = false
	navigation_agent.target_position = position
	await navigation_agent.navigation_finished

func _on_navigation_agent_2d_target_reached() -> void:
	if leaving:
		self.queue_free()
	
	target_reached = true
	
func face_right() -> void:
	animated_sprite.flip_h = false
	
func face_left() -> void:
	animated_sprite.flip_h = true


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "idle": return
		
	if animated_sprite.frame in footstep_frames:
		audio_stream_player.play()
