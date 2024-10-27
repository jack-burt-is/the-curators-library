extends PointLight2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact() -> void:
	timer.start()
	audio_stream_player_2d.play()

func _on_timer_timeout() -> void:
	self.enabled = not self.enabled
