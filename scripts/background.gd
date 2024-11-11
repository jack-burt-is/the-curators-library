extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasLayer/CanvasModulate
@export var day_gradient: Gradient
@export var night_gradient: Gradient

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Determine which gradient to use based on the time of day
	if is_daytime(GameManager.data.current_hour, GameManager.data.current_minute):
		canvas_modulate.color = sample_gradient(day_gradient, GameManager.data.current_hour, GameManager.data.current_minute, 6, 18)	
	else:
		canvas_modulate.color = sample_gradient(night_gradient, GameManager.data.current_hour, GameManager.data.current_minute, 18, 6)

# Checks if the time is within the daytime range (6:00 to 18:00)
func is_daytime(hour: int, minute: int) -> bool:
	return hour >= 6 and hour < 18

# Samples a color from the given gradient based on the time of day
func sample_gradient(gradient: Gradient, hour: int, minute: int, start_hour: int, end_hour: int) -> Color:	# Calculate start and end times in minutes
	# Calculate the time in minutes from start_hour to the current time
	var start_minutes = start_hour * 60
	var current_minutes = hour * 60 + minute

	# Calculate end time in minutes, wrapping around midnight if necessary
	var end_minutes = end_hour * 60 if end_hour > start_hour else (end_hour + 24) * 60
	var total_minutes = end_minutes - start_minutes
	
	# Adjust current_minutes if it crosses midnight
	if current_minutes < start_minutes:
		current_minutes += 24 * 60

	# Normalize the current time within this range (0 to 1)
	var factor = float(current_minutes - start_minutes) / float(total_minutes)
	var color = gradient.sample(factor)
	return color
