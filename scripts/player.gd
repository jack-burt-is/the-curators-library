extends CharacterBody2D

# Movement speed for the player
@export var speed: float = 80.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var being_moved = false
var footstep_frames: Array = [0, 4]

func _process(delta: float) -> void:
	if Dialogic.current_timeline != null or GameManager.freeze_player:
		animated_sprite.play("idle")
		return
	
	if being_moved:
		var direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = direction * speed * delta * 40
	else:
		# Initialize the movement vector
		var movement_vector: Vector2 = Vector2.ZERO

		# Handle input from keyboard and joystick
		if Input.is_action_pressed("move_left"):
			movement_vector.x -= 1
		if Input.is_action_pressed("move_right"):
			movement_vector.x += 1
		if Input.is_action_pressed("move_up"):
			movement_vector.y -= 1
		if Input.is_action_pressed("move_down"):
			movement_vector.y += 1
			

		# Normalize to prevent faster diagonal movement
		if movement_vector != Vector2.ZERO:
			movement_vector = movement_vector.normalized()

		# Move the character based on the movement vector and speed
		velocity = movement_vector * speed * delta * 65

	# Flip sprite
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true
		
	# Play animation
	if velocity.x != 0 or velocity.y != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
		
	print(global_position)

	# Apply movement
	move_and_slide()


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "idle": return
		
	if animated_sprite.frame in footstep_frames:
		audio_stream_player.play()
		
func move_to(position) -> void:
	being_moved = true
	navigation_agent_2d.target_position = position

func _on_navigation_agent_2d_target_reached() -> void:
	being_moved = false
