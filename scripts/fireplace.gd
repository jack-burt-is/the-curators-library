extends PurchasableNode

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var fire: AnimatedSprite2D = $Fire
@onready var particles: CPUParticles2D = $Embers/CPUParticles2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var point_light_2d: PointLight2D = $Embers/PointLight2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var active = true
var light_target
var light_current
var light_max

func _ready() -> void:
	init_purchasable(load("res://resources/purchasables/fireplace.tres"))
	handle_purchasable()
	
func handle_purchasable():
	if purchased:
		interaction_area.interact = Callable(self, "_on_interact")
		interaction_area.enabled = true
		collision_shape_2d.disabled = false
		audio_stream_player_2d.autoplay = true
		audio_stream_player_2d.playing = true
		
		light_max = point_light_2d.energy
		light_current = light_max
		light_target = light_max
	else:
		interaction_area.enabled = false
		collision_shape_2d.disabled = true
		audio_stream_player_2d.autoplay = false
		audio_stream_player_2d.playing = false
	
func _process(delta: float) -> void:
	if purchased:
		if point_light_2d.energy != light_target:
			point_light_2d.energy = move_toward(point_light_2d.energy, light_target, delta)

func _on_interact() -> void:
	if active:
		turn_off()
	else:
		turn_on()
		
	
func turn_off() -> void:
	light_target = 0
	particles.emitting = false
	fire.play("end")
	audio_stream_player_2d.stop()
	active = false
	
	
func turn_on() -> void:
	light_target = light_max
	audio_stream_player_2d.play()
	particles.emitting = true
	fire.play("start")
	await fire.animation_finished
	fire.play("default")
	active = true
