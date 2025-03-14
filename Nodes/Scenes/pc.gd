extends Control

var servidor_url = "https://192.168.100.91:5001/execute"  
var inputCount = 0;

func _on_send_pressed() -> void:
	var temas = {
		"casual": [
		  "bom dia",
		  "como vão as coisas",
		  "tranquilo",
		  "tudo bem",
		  "como está",
		  "saudações",
		  "e aí",
		  "tudo certo",
		  "como vai",
		  "ola",
		],
		"assassinato": [
		  "assassinato",
		  "crime",
		  "homicídio",
		  "morte",
		  "incidente",
		  "tragédia",
		  "investigação",
		  "caso",
		  "ada logic",
		  "jovem",
		],
	}

	var raw_player_code = $Control/CodeEdit.text  
	var player_code = raw_player_code.strip_edges()  

	if player_code != "":
		if "for" in player_code:
			inputCount -= 1;
		else:
			inputCount += 1;

		enviar_codigo(player_code, raw_player_code, inputCount)

		$Control/CodeEdit.text = ""

func enviar_codigo(codigo_usuario: String, raw_code: String, input_count: int) -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(Callable(self, "_on_request_completed").bind(raw_code, input_count))

	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({ "code": codigo_usuario })
	var error = http_request.request(servidor_url, headers, HTTPClient.METHOD_POST, body)

	if error != OK:
		_adicionar_mensagem("Erro ao iniciar a requisição: " + str(error), 2)

func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray, raw_code: String, input_count: int):
	var response_body = body.get_string_from_utf8()
	var json = JSON.new()
	var parse_result = json.parse(response_body)

	if parse_result == OK:
		var response_data = json.get_data()
		if response_data["output"].begins_with("Erro"):
			var error_message = response_data["output"]
			_adicionar_mensagem(_mensagem_erro(error_message), 4)
		else:
			var output = response_data["output"]
			var npc_response = _responder_npc(output, input_count)
			_adicionar_mensagem(response_data["output"], 1)
			_adicionar_mensagem(raw_code, 3)
			_adicionar_mensagem(npc_response, 2)
	else:
		_adicionar_mensagem("Resposta inválida do servidor: " + response_body, 2)


func _mensagem_erro(erro: String) -> String:
	var reflexoes = [
		"Em meio à conversa, você pensa - 'Parece que minhas palavras não estão bem definidas.'",
		"Você sente que algo no que disse está errado, mas não sabe ao certo o que.",
		"Um silêncio constrangedor surge enquanto você tenta encontrar palavras melhores.",
		"Talvez seja melhor reformular o que está tentando dizer."
	]
	return reflexoes[randi() % reflexoes.size()]

func _responder_npc(output: String, input_count: int) -> String:
	var temas = {
		"casual": [
		  "bom dia",
		  "como vão as coisas",
		  "tranquilo",
		  "tudo bem",
		  "como está",
		  "saudações",
		  "e aí",
		  "tudo certo",
		  "como vai",
		  "ola",
		],
		"assassinato": [
		  "assassinato",
		  "crime",
		  "homicídio",
		  "morte",
		  "incidente",
		  "tragédia",
		  "investigação",
		  "caso",
		  "ada logic",
		  "jovem",
		],
	}

	var respostas = {
	  "casual": [
		"Ah, detetive... É raro ver alguém começar uma conversa com bons modos por aqui. Um bom dia para você também.",
		"Por enquanto, sim. Mas uma cidade como essa sempre guarda seus segredos.",
		"Tudo tranquilo por enquanto, mas nunca se sabe o que pode acontecer.",
		"Saudações, detetive. Espero que esteja pronto para desvendar mais mistérios.",
		"Bom dia. Espero que o clima de mistério não esteja pesando em seus ombros.",
	  ],
	  "investigacao": [
		"Assassinato? Hmmm... Essas coisas podem acontecer mesmo nos lugares mais refinados.",
		"Talvez... Ou talvez não. Mas uma coisa eu posso dizer: persistência sempre nos leva aonde queremos.",
		"Você está certo em investigar, mas lembre-se: nem todas as respostas estão à vista.",
		"Ouvi rumores, mas não sou do tipo que entrega informações sem motivo.",
		"Esses casos de assassinato são complicados. Mas com um detetive persistente, algo sempre vem à tona.",
	  ],
	  "irritado": [
		"Já disse, detetive... Eu sou um homem ocupado. Não gosto de insistência sem propósito. Pensei já ter deixado isso claro em nosso encontro na cafeteria!",
		"Ouça bem: insistência não é persistência. Se quiser respostas, talvez seja hora de aprender a agir de forma eficiente. Parece que não fui claro na cafeteria..",
		"Você acha que repetir perguntas vai magicamente abrir minha boca? Precisa ser mais criativo. Creio que nossa conversa na cafeteria não tenha valido muito..",
		"Detetive, estou começando a perder a paciência. Talvez você devesse aprender algo novo antes de voltar. Aquele café foi realmente um desperdício!",
		"Se você insistir sem propósito, não verá progresso. Use a cabeça, não só a boca. Creio ter se esquecido do que lhe disse na cafeteria..",
	  ],
	  "dicas": [
		"Ah, vejo que aprendeu algo importante... Persistência inteligente, hein?",
		"Bem, já que você provou ser capaz, vou lhe dizer algo: ouvi rumores sobre alguém que visitou o local do crime à noite. Pode não ser coincidência.",
		"Continue usando essa sua persistência inteligente e talvez chegue ao culpado.",
		"Uma pista? Bem, ouvi falar que há uma testemunha silenciosa na cena do crime... pode valer a pena investigar.",
		"Cuidado com os Constantino... dizem que são frios como o gelo, focados e imutáveis, mas têm um caráter que nunca pode ser comprado.",
		"Ouvi dizer que os Constantino têm uma filosofia clara: 'Nada muda, nada quebra.' Talvez isso explique seu comportamento implacável.",
	  ],
	  "default":
		"Não sei ao certo onde você quer chegar. Pode reformular sua pergunta?",
	};

	var texto_normalizado = output.to_lower()
	for tema in temas.keys():
		for palavra in temas[tema]:
			if texto_normalizado.findn(palavra) >= 0:
				if tema == "casual":
					return respostas.casual[randi_range(0, respostas.casual.size())]
				if tema == "assassinato":
					if input_count < 0:
						var random_index = randi_range(0, respostas.dicas.size())
						if random_index >= 4:
							Globals.lastScene = true
							$AnswerFind.start()
							$NextScene.start()
						return respostas.dicas[random_index]
					elif input_count > 2:
						return respostas.irritado[randi_range(0, respostas.irritado.size())]
					else:
						return respostas.investigacao[randi_range(0, respostas.investigacao.size())]
	return respostas["default"]


func _on_answer_find_timeout() -> void:
	$AnswerFind/Label.visible_ratio = 1

func _on_next_scene_timeout() -> void:
	$AnswerFind/Label.hide()
	get_tree().change_scene_to_file("res://Nodes/Scenes/page16.tscn")

func _adicionar_mensagem(mensagem: String, case: int) -> void:
	var mensagem_container = HBoxContainer.new()
	mensagem_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mensagem_container.alignment = BoxContainer.ALIGNMENT_END if case == 1 else BoxContainer.ALIGNMENT_BEGIN

	var caixa_mensagem = Panel.new()
	caixa_mensagem.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	caixa_mensagem.custom_minimum_size = Vector2(2600, 120)

	var estilo = StyleBoxFlat.new()
	estilo.bg_color = Color(0, 0, 0)
	estilo.corner_radius_top_left = 10
	estilo.corner_radius_top_right = 10
	estilo.corner_radius_bottom_left = 10
	estilo.corner_radius_bottom_right = 10
	caixa_mensagem.add_theme_stylebox_override("panel", estilo)

	var texto = RichTextLabel.new()
	if case == 1:
		texto.text = "Você: " + mensagem
	elif case == 2:
		texto.text = "Sr. Willow While: " + mensagem
	elif case == 3:
		texto.text = "Seu código: \n" + mensagem
	else:
		texto.text = "- " + mensagem

	texto.autowrap_mode = false
	texto.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texto.size_flags_vertical = Control.SIZE_FILL
	texto.custom_minimum_size = Vector2(2600, 120)
	texto.set_use_bbcode(true)
	if case == 1:
		texto.bbcode_text = "[color=white][font_size=25]Você: " + mensagem 
	elif case == 2:
		texto.bbcode_text = "[color=yellow][font_size=25]Sr. Willow While: " + mensagem
	elif case == 3:
		texto.bbcode_text = "[color=gray][font_size=25]Seu código: \n" + mensagem 
	else:
		texto.bbcode_text = "[color=red][font_size=25]- " + mensagem

	caixa_mensagem.add_child(texto)

	mensagem_container.add_child(caixa_mensagem)

	$Control/Chat_Panel/ScrollContainer/VBoxContainer.add_child(mensagem_container)


func _on_turn_off_pressed() -> void:
	get_tree().change_scene_to_file("res://Nodes/main.tscn")
