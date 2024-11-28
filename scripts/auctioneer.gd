extends CharacterBody2D

@export var speed: float = 80.0

var leaving = false
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialog_marker: Marker2D = $DialogMarker

var character = preload("res://dialogue/characters/auctioneer.dch")
var target_reached = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	
	if Dialogic.current_timeline != null:
		animated_sprite_2d.play("idle")
		return
	
	var direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	if target_reached:
		velocity = direction * 0
	else:
		velocity = direction * speed * delta * 40
		
	if leaving and target_reached:
		self.queue_free()
		
	# Flip sprite
	if direction.x > 0:
		animated_sprite_2d.flip_h = false
	elif direction.x < 0:
		animated_sprite_2d.flip_h = true
		
	# Play animation
	if velocity.x != 0 or velocity.y != 0:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	move_and_slide() 
	
func trigger_dialogue():
	var layout = Dialogic.start('intro')		
	layout.register_character(character, dialog_marker)

func move_to(position) -> void:
	target_reached = false
	navigation_agent_2d.target_position = position
	await navigation_agent_2d.navigation_finished

func _on_navigation_agent_2d_target_reached() -> void:
	if leaving:
		self.queue_free()
	
	target_reached = true
