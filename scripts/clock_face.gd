extends Node2D

enum {HOUR, MINUTE}
const HOUR_HAND_LENGTH = 60
const MINUTE_HAND_LENGTH = 100

@onready var minute_hand: Line2D = $MinuteHand
@onready var hour_hand: Line2D = $HourHand

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	hour_hand.points[1] = calculate_hand_tip_location(HOUR)
	minute_hand.points[1] = calculate_hand_tip_location(MINUTE)

# Calculate the coordintes of the tip of a clock hand
func calculate_hand_tip_location(hand) -> Vector2:
	var length
	var angle
	
	match hand:
		MINUTE:
			length = MINUTE_HAND_LENGTH
			angle = deg_to_rad(GameManager.data.current_minute * 6.0)
		HOUR:
			length = HOUR_HAND_LENGTH
			angle = deg_to_rad(GameManager.data.current_hour * 30.0 + GameManager.data.current_minute * 0.5)
	
	var x = length * sin(angle)
	var y = -length * cos(angle)
	
	return Vector2(x, y)
