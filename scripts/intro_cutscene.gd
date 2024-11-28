extends Node

@onready var player = get_tree().get_first_node_in_group("player")

@onready var navigation_leave: Node2D = get_tree().current_scene.get_node("%NavigationLeave")
@onready var spawn_parent: Node2D = get_tree().current_scene.get_node("%SpawnedNpcs")
@onready var reception: Node2D = get_tree().current_scene.get_node("%Reception")
@onready var auctioneer_scene  = preload("res://scenes/characters/auctioneer.tscn")

var auctioneer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_characters()
	position_characters()
	await walk_characters()
	trigger_dialogue()
	await auctioneer_exit()
	self.queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_characters():
	auctioneer = auctioneer_scene.instantiate()
	spawn_parent.add_child(auctioneer)

func position_characters():
	player.global_position = navigation_leave.global_position + Vector2(0, -20)
	auctioneer.global_position = navigation_leave.global_position
	
func walk_characters():
	var target = reception.global_position + Vector2(0,50)
	player.move_to(target + Vector2(-10, 0))
	await auctioneer.move_to(target + Vector2(10, 0))
	
func auctioneer_exit():
	await auctioneer.move_to(navigation_leave.global_position)

func trigger_dialogue():
	await auctioneer.trigger_dialogue()
