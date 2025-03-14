extends Control



func _on_exit_left_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/main.tscn")


func _on_exit_right_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/main.tscn")


func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/Scenes/page15.tscn")
