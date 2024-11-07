extends CanvasLayer

@onready var new_label: Label = $NewDay/Label
@onready var falling_label: Label = $FallingDay/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	falling_label.text = str(GameManager.data.current_day - 1)
	new_label.text = str(GameManager.data.current_day)
	animation_player.play("new_day")
	


func _on_timer_timeout() -> void:
	SceneTransition.free_scene(self)
