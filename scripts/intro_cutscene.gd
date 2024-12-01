extends Node

@onready var player = get_tree().get_first_node_in_group("player")

@onready var navigation_leave: Node2D = get_tree().current_scene.get_node("%NavigationLeave")
@onready var spawn_parent: Node2D = get_tree().current_scene.get_node("%SpawnedNpcs")
@onready var reception: Node2D = get_tree().current_scene.get_node("%Reception")
@onready var camera: Node2D = get_tree().current_scene.get_node("%Camera")
@onready var fader: ColorRect = get_tree().current_scene.get_node("%Fader")

# Sounds
var sweeping_sound = preload("res://sounds/sweeping.wav")

@onready var auctioneer_scene  = preload("res://scenes/characters/auctioneer.tscn")

var auctioneer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.zoom_in()
	camera.offset_up()
	spawn_characters()
	position_characters()
	await walk_characters()
	trigger_dialogue()
	await auctioneer_exit()
	camera.zoom_out(0.2)
	await GameManager.wait(5)
	fader.fade_out()
	GameManager.play_sound(sweeping_sound, 10)
	await GameManager.wait(3)
	camera.reset_zoom()
	camera.reset_offset()
	await GameManager.wait(2)
	fader.fade_in()
	self.queue_free()
	
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
	player.face_right()
	auctioneer.face_left()
	
func auctioneer_exit():
	await auctioneer.move_to(navigation_leave.global_position)

func trigger_dialogue():
	await auctioneer.trigger_dialogue()
