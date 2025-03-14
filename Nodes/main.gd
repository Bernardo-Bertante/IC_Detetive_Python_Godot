extends Control



func _on_button_pressed():
	get_tree().change_scene_to_file("res://Nodes/Scenes/PC.tscn")

func _on_button_notes_pressed() -> void:
	if(Globals.firstScene):
		get_tree().change_scene_to_file("res://Nodes/Scenes/page12.tscn")
		Globals.firstScene = false
	else:
		get_tree().change_scene_to_file("res://Nodes/Scenes/page13.tscn")
