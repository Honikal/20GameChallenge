extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		#Vamos a la página de inicio
		SceneTransition._change_scene("game");
	elif Input.is_action_just_pressed("ui_exit"):
		#Cerramos el juego
		get_tree().quit();
