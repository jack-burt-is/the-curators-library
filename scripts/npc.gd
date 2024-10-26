extends CharacterBody2D

@export var speed: float = 80.0
@export var timer_length: float = 10
@export var timer_variation: float = 0.5

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var sprite_frames: SpriteFrames
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var dialogue_tree: Array[String]
@export var target_positions: Node2D

var target_reached = false
var interacting = false

func _process(delta: float) -> void:
	var direction = to_local(navigation_agent.get_next_path_position()).normalized()
	if target_reached or interacting:
		velocity = direction * 0
	else:
		velocity = direction * speed * delta * 40
		
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
	animated_sprite.sprite_frames = sprite_frames
	interaction_area.interact = Callable(self, "_on_interact")
	make_path()

func _on_interact() -> void:
	interacting = true
	DialogManager.start_dialog(global_position, dialogue_tree)
	await DialogManager.dialog_finished
	interacting = false
	
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
