extends Control

func _on_timer_timeout() -> void:
	$Label.text = "- Lembro de um velho amigo que conhece mais segredos dessa cidade do que qualquer confessor. \nSe alguém souber o que está por trás da morte de Ada Logic, é ele.\n Claro, falar com ele não é simples — cada minuto custa caro, e ele odeia desperdício. \nMas acho que ainda tenho o número dele anotado no meu caderno...\n Isso, se o tempo e o descuido não tiverem levado essa página junto.";

func _on_next_scene_timeout() -> void:
	get_tree().change_scene_to_file("res://Nodes/main.tscn")
