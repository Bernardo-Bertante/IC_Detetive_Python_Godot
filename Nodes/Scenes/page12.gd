extends Control



func _on_timer_timeout() -> void:
	$Label.text = "- Claro... uma maldita mancha de café bem onde estava o número. \nEu resmungo, mas não é o fim do mundo —\n talvez eu tenha o contato salvo no computador. \nSe bem que Willow While não faz nada do jeito fácil.\n Quando se trata de mensagens, só responde em códigos.\n Sigilo, segurança, e, francamente, um toque de paranoia."


func _on_change_text_timeout() -> void:
	$Label.text = "- Felizmente, anotei os detalhes desse teatrinho cifrado no mesmo caderno...\n só espero que o café não tenha levado isso também.\n Além disso, acho melhor eu me livrar dessa página.."


func _on_finish_scene_timeout() -> void:
	get_tree().change_scene_to_file("res://Nodes/Scenes/page13.tscn")
