extends Control

@onready var booooks: MarginContainer = %Booooks
@onready var lunka: MarginContainer = %Lunka

func _on_close_pressed() -> void:
	hide()

func _on_booooks_pressed() -> void:
	booooks.show()


func _on_lunka_pressed() -> void:
	lunka.show()
