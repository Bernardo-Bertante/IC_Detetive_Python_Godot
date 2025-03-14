extends Control

var respostas = {
	'print("qual a arma do crime?")': 
		"Ah, jovem, você é muito apressado. Não sou desse tipo que responde de primeira. Insista mais!",
	'resposta = false\nwhile not resposta:\n    print("qual roupa ele usava?")\n    resposta = true': 
		"Você é insistente, hein? Tudo bem, vou dizer! Ele usava um terno cinza, mas tinha uma gravata vermelha chamativa. Agora pare de me atormentar!",
	'resposta = false\nwhile resposta == false:\n    print("onde você estava?")': 
		"Ei, jovem, seu código nunca vai parar assim! Eu sou insistente, mas até eu sei que preciso de uma condição para acabar com a conversa! Tente de novo, e talvez eu responda.",
	'resposta = false\ntentativas = 0\nwhile not resposta:\n    print("qual era o motivo do crime?")\n    tentativas += 1\n    if tentativas == 3:\n        resposta = true': 
		"Você me cansou, garoto! O motivo do crime foi inveja, pura e simples. Agora pare de me fazer repetir!"
};
func _on_send_pressed() -> void:
	var mensagem_usuario = $Control/CodeEdit.text.strip_edges()
	if (mensagem_usuario != ""):
		_adicionar_mensagem(mensagem_usuario, true)

		var resposta = validar_codigo(mensagem_usuario)

		_adicionar_mensagem(resposta, false)

		$Control/CodeEdit.text = ""

func validar_codigo(codigo_usuario: String) -> String:
	var codigo_normalizado = codigo_usuario.strip_edges().replace("\t", "").to_lower()
	
	if respostas.has(codigo_normalizado):
		return respostas[codigo_normalizado]
	else:
		return "Desculpe, não entendi sua mensagem."

func _adicionar_mensagem(mensagem: String, is_user: bool) -> void:
	var mensagem_container = HBoxContainer.new()
	mensagem_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	mensagem_container.alignment = BoxContainer.ALIGNMENT_END if is_user else BoxContainer.ALIGNMENT_BEGIN

	var caixa_mensagem = Panel.new()
	caixa_mensagem.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	caixa_mensagem.custom_minimum_size = Vector2(2600, 100)

	var estilo = StyleBoxFlat.new()
	estilo.bg_color = Color(0, 0, 0) 
	estilo.corner_radius_top_left = 10
	estilo.corner_radius_top_right = 10
	estilo.corner_radius_bottom_left = 10
	estilo.corner_radius_bottom_right = 10
	caixa_mensagem.add_theme_stylebox_override("panel", estilo)

	var texto = Label.new()
	if is_user:
		texto.text = "Você: " + mensagem
	else:
		texto.text = "Sr. Willow While: " + mensagem
	texto.autowrap_mode = false
	texto.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texto.size_flags_vertical = Control.SIZE_FILL
	texto.custom_minimum_size = Vector2(2600, 100)

	if is_user:
		texto.add_theme_color_override("font_color", Color(1, 1, 1))  # Branco
	else:
		texto.add_theme_color_override("font_color", Color(1, 1, 0))  # Amarelo

	texto.add_theme_font_size_override("font_size", 30)  

	caixa_mensagem.add_child(texto)

	mensagem_container.add_child(caixa_mensagem)

	$Control/Chat_Panel/ScrollContainer/VBoxContainer.add_child(mensagem_container)
