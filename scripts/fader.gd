extends ColorRect

var target = -1
var speed = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target >= 0:
		modulate.a = move_toward(modulate.a, target, speed * delta)

func fade_out():
	target = 255
	
func fade_in():
	target = 0
