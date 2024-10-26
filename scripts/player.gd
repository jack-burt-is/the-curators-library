extends CharacterBody2D

# Movement speed for the player
@export var speed: float = 80.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
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
		
	# Flip sprite
	if movement_vector.x > 0:
		animated_sprite.flip_h = false
	elif movement_vector.x < 0:
		animated_sprite.flip_h = true
		
	# Play animation
	if movement_vector.x != 0 or movement_vector.y != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

	# Normalize to prevent faster diagonal movement
	if movement_vector != Vector2.ZERO:
		movement_vector = movement_vector.normalized()

	# Move the character based on the movement vector and speed
	velocity = movement_vector * speed * delta * 65

	# Apply movement
	move_and_slide()
