extends Control

const COUNTING_TIME: float = 1.0
var elapsed_time: float = 0.0
var current_coins: int = 0
var target_coins: int = 0

@onready var book: TextureRect = $Hotbar/PanelContainer/MarginContainer/TextureRect
@onready var coin_amount: Label = $UpperLeft/PanelContainer/HBoxContainer/MarginContainer2/CoinAmount

func _ready() -> void:
	current_coins = GameManager.data.coins
	target_coins = current_coins
	coin_amount.text = str(current_coins)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.data.selected_book != null:
		book.show()
	else:
		book.hide()
	
	sync_coins(delta)
		
	
		
func sync_coins(delta: float):
	if target_coins != GameManager.data.coins:
		# Set the target amount and reset the timer
		target_coins = GameManager.data.coins
		elapsed_time = 0.0

	if current_coins != target_coins:
		elapsed_time += delta
		var progress = elapsed_time / COUNTING_TIME

		# Clamp progress between 0 and 1
		progress = clamp(progress, 0.0, 1.0)

		# Interpolate between current_coins and target_coins
		current_coins = lerp(current_coins, target_coins, progress)
				
		# Ensure integer values for display
		coin_amount.text = str(round(current_coins))

		# Stop animation once target is reached
		if current_coins == target_coins:
			elapsed_time = COUNTING_TIME
		
