extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func enter():
	animation_player.play("enter")

func exit():
	animation_player.play_backwards("enter")
