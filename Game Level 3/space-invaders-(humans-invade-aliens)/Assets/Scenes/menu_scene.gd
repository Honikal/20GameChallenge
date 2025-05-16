extends Node

@onready var buttons = [
	$MenuUI/Panel/ButtonsSection/PlayBtn,
	$MenuUI/Panel/ButtonsSection/HighscoreBtn,
	$MenuUI/Panel/ButtonsSection/OptionsBtn
]
	
func _ready() -> void:
	#La navegación entre vecinos está manejada por el editor, aunque se podría utilizar esta función
	_setup_focus();
	
	#Agarramos el focus del botón, primero empezamos con el de play, y luego intentamos implementar
	#el manejo de keyboard desde el mismo botón
	buttons[0].grab_focus();
	
	#Conectamos las señales de los botones
	buttons[0].pressed.connect(_playGame);
	buttons[1].pressed.connect(_optionsPressed);
	buttons[2].pressed.connect(_scorePressed);

func _setup_focus():
	#Hacemos una navegación circular (de arriba a abajo)
	for i in buttons.size():
		buttons[i].focus_neighbor_top = buttons[(i-1) % buttons.size()].get_path();
		buttons[i].focus_neighbor_bottom = buttons[(i+1) % buttons.size()].get_path();

func _playGame():
	#SceneTransition._change_scene("game");
	print("Play game");
	
func _optionsPressed():
	print("Press Options");

func _scorePressed():
	print("Highscore Pressed");
