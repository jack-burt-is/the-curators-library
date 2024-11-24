extends StaticBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var fire: AnimatedSprite2D = $Fire
@onready var particles: CPUParticles2D = $Embers/CPUParticles2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var active = true

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	if active:
		turn_off()
	else:
		turn_on()
		
	
func turn_off() -> void:
	particles.emitting = false
	fire.play("end")
	audio_stream_player_2d.stop()
	active = false
	
	
func turn_on() -> void:
	audio_stream_player_2d.play()
	particles.emitting = true
	fire.play("start")
	await fire.animation_finished
	fire.play("default")
	active = true
