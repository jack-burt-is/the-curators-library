extends Node2D

#@export var hour: float = 0.0
#@export var minute: float = 0.0

@onready var minute_hand: Line2D = $MinuteHand
@onready var hour_hand: Line2D = $HourHand

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hour_hand.points[1] = calculate_hour_hand_tip_location(GameManager.data.current_hour, GameManager.data.current_minute)
	minute_hand.points[1] = calculate_minute_hand_tip_location(GameManager.data.current_minute)

func calculate_minute_hand_tip_location(minute: float) -> Vector2:
	# Calculate the angle in degrees for the minute value
	# Each minute represents 6 degrees (360 degrees / 60 minutes)
	var angle_degrees = minute * 6.0
	# Convert degrees to radians as Godot's trigonometric functions use radians
	var angle_radians = deg_to_rad(angle_degrees)
	
	# Calculate the x and y coordinates based on the angle
	# The length is set to 100 pixels, as specified
	var x = 100 * sin(angle_radians)
	var y = -100 * cos(angle_radians)
	
	# Return the calculated position as a Vector2
	return Vector2(x, y)

func calculate_hour_hand_tip_location(hour: float, minute: float) -> Vector2:
	# If hour is above 12, subtract 12 to get 12 hour time from 24
	if hour > 12:
		hour = hour - 12
	
	# Calculate the base angle in degrees for the hour value
	var angle_degrees = (hour * 30.0) + (minute * 0.5)
	# Convert degrees to radians as Godot's trigonometric functions use radians
	var angle_radians = deg_to_rad(angle_degrees)
	
	# Calculate the x and y coordinates based on the angle
	# The length is set to 60 pixels for the hour hand
	var x = 60 * sin(angle_radians)
	var y = -60 * cos(angle_radians)
	
	# Return the calculated position as a Vector2
	return Vector2(x, y)
