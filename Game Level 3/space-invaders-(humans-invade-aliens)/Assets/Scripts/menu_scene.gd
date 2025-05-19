extends Node

@onready var buttons = [
	$MenuUI/ButtonsSection/PlayBtn,
	$MenuUI/ButtonsSection/OptionsBtn
]	
		
func _ready() -> void:
	#La navegación entre vecinos está manejada por el editor, aunque se podría utilizar esta función
	_setup_focus();
	
	#Agarramos el focus del botón, primero empezamos con el de play, y luego intentamos implementar
	#el manejo de keyboard desde el mismo botón
	buttons[0].grab_focus();
	
	#Conectamos las señales de cada uno de los botones
	_connect_signals();
	
func _connect_signals():
	#Conectamos las señales de los botones usando un método lambda
	for btn in buttons:
		btn.pressed.connect(_on_button_pressed.bind(btn));

func _setup_focus():
	#Hacemos una navegación circular (de arriba a abajo)
	for i in buttons.size():
		buttons[i].focus_neighbor_top = buttons[(i-1) % buttons.size()].get_path();
		buttons[i].focus_neighbor_bottom = buttons[(i+1) % buttons.size()].get_path();

func _on_button_pressed(btn: TextureButton):
	#Función encargada de recibir un botón y en base al botón seleccionado, llama una función
	match btn.name:
		"PlayBtn":
			_playGame();
		"HighscoreBtn":
			_scorePressed();
		"OptionsBtn":
			_optionsPressed();

func _input(event: InputEvent) -> void:
	#Manejamos el sistema o confirmación de input
	if (event.is_action_pressed("ui_accept")):
		#Checamos que se presione espacio, tomamos el botón focuseado, y emitimos su señal
		var focused_btn = get_viewport().gui_get_focus_owner();
		if (focused_btn in buttons):
			print("Se llama o toca el botón")
			focused_btn.emit_signal("pressed");

func _playGame():
	SceneTransition._change_scene("game");
func _scorePressed():
	print("Highscore Pressed");
func _optionsPressed():
	print("Press Options");
