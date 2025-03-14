extends Control

signal send

func _on_button_pressed() -> void:
	send.emit()
