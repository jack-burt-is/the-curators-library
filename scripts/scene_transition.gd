extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().root.add_child(load(target).instantiate())
	$AnimationPlayer.play_backwards('dissolve')
	
func free_scene(scene) -> void:
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	scene.free()
	$AnimationPlayer.play_backwards('dissolve')
