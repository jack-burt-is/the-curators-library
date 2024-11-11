extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

func get_prompt_for_action(action_name: String) -> String:
	var input = InputHelper.get_keyboard_inputs_for_action(action_name)
	var prompt = InputHelper.get_label_for_input(input[0])
	return prompt

var active_areas = []
var can_interact = true

func register_area(area: InteractionArea) -> void:
	active_areas.push_back(area)

func unregister_area(area: InteractionArea) -> void:
	var index = active_areas.find(area)
	# if index != 1:
	active_areas.remove_at(index)
		
func _process(_delta: float) -> void:
	if active_areas.size() > 0 && can_interact && Dialogic.current_timeline == null:
		
		# Find the closest interaction area
		active_areas.sort_custom(sort_by_distance_to_player)
		var priority_area = active_areas[0]

		label.text = get_prompt_for_action("interact") + " to " + priority_area.action_name
		label.global_position = priority_area.global_position

		label.global_position.y -= 42
		label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()
		
		
func sort_by_distance_to_player(area1, area2) -> bool:
	# Sometimes one of them is null for some reason?
	if area1 and not area2:
		return area1
	if area2 and not area1:
		return area2
		
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
