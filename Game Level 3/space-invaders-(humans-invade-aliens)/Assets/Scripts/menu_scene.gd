extends Node

@onready var buttons = [
	$MenuUI/ButtonsSection/PlayBtn,
	$MenuUI/ButtonsSection/OptionsBtn
]	
@onready var optButtons = [
	$MenuUI/OptionsSection/ResolutionSection,
	$MenuUI/OptionsSection/FullscreenCheck,
	$MenuUI/OptionsSection/VSyncCheck,
	$MenuUI/OptionsSection/BackBtn
]
@onready var buttons_section: VBoxContainer = $MenuUI/ButtonsSection
@onready var options_section: VBoxContainer = $MenuUI/OptionsSection

var resolutions = [
	Vector2i(1920, 1080),
	Vector2i(1600, 900),
	Vector2i(1366, 768),
	Vector2i(1280, 720),
	Vector2i(1024, 576),
	Vector2i(640, 360)
];
var currentIndex = resolutions[0];

func _ready() -> void:
	#La navegación entre vecinos está manejada por el editor, aunque se podría utilizar esta función
	_setup_focus();
	_setup_options();
	
	#Apagamos visualmente la sección de opciones y seteamos los valores iniciales
	options_section.visible = false;
	
	
	#Agarramos el focus del botón, primero empezamos con el de play, y luego intentamos implementar
	#el manejo de keyboard desde el mismo botón
	buttons[0].grab_focus();
	
	#Conectamos las señales de cada uno de los botones
	_connect_signals();
	
func _connect_signals():
	#Conectamos las señales de los botones usando un método lambda
	for btn in buttons:
		btn.pressed.connect(_on_button_pressed.bind(btn));
		
	#Conectamos el botón de salida de opciones
	optButtons[-1].pressed.connect(_on_button_pressed.bind(optButtons[-1]));

func _setup_focus():
	#Hacemos una navegación circular (de arriba a abajo)
	for i in buttons.size():
		buttons[i].focus_neighbor_top = buttons[(i-1) % buttons.size()].get_path();
		buttons[i].focus_neighbor_bottom = buttons[(i+1) % buttons.size()].get_path();
		
	#Hacemos también la navegación circular con los de las opciones
	for i in optButtons.size():
		optButtons[i].focus_neighbor_top = optButtons[(i-1) % optButtons.size()].get_path();
		optButtons[i].focus_neighbor_bottom = optButtons[(i+1) % optButtons.size()].get_path();

func _setup_options():
	#Seteamos las resoluciones con la posible lista
	var resolution = DisplayServer.screen_get_size();
	optButtons[0].text = "RESOLUTION : %d x %d" % [resolution.x, resolution.y]; 
	optButtons[1].text = "FULLSCREEN : " + _boolToString(false);
	optButtons[2].text = "VSYNC : " + _boolToString(false);

func _on_button_pressed(btn: TextureButton):
	#Función encargada de recibir un botón y en base al botón seleccionado, llama una función
	match btn.name:
		"PlayBtn":
			_playGame();
		"OptionsBtn":
			_optionsPressed();
		"BackBtn":
			_backBtn();			

func _input(event: InputEvent) -> void:
	#Manejamos el sistema o confirmación de input
	if (event.is_action_pressed("ui_accept")):
		#Checamos que se presione espacio, tomamos el botón focuseado, y emitimos su señal
		var focused_btn = get_viewport().gui_get_focus_owner();
		if (focused_btn in buttons):
			print("Se llama o toca el botón")
			focused_btn.emit_signal("pressed");
	
	if (event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right")):
		#Checamos que se presione espacio, tomamos el botón focuseado, y emitimos su señal
		var focused_btn = get_viewport().gui_get_focus_owner();
		
		match focused_btn.name:
			"ResolutionSection":
				_changeResolution(event.is_action_pressed("ui_right"));
			"FullscreenCheck":
				pass
			"VSyncCheck":
				pass

func _playGame():
	SceneTransition._change_scene("game");
func _optionsPressed():
	buttons_section.visible = false;
	options_section.visible = true;
	
	#Agarramos focus del botón de opciones
	optButtons[0].grab_focus();
func _backBtn():
	#Guardamos las modificaciones visuales
	
	
	#Desactivamos las UI necesarias
	buttons_section.visible = true;
	options_section.visible = false;
	
	#Agarramos focus del botón normal
	buttons[0].grab_focus();

#Funciones de la sección de opciones

func _changeResolution(is_right: bool):
	var count = resolutions.size();
	var newIndex = (currentIndex + (1 if is_right else -1)) % count;
	currentIndex = newIndex;
	
	#Vamos a modificar la resolución del juego
	_onResolutionSelected(currentIndex);
	var resolution = resolutions[currentIndex];
	optButtons[currentIndex].text = "RESOLUTION : %d x %d" % [resolution.x, resolution.y];


func _onResolutionSelected(index: int):
	#Extraemos el texto de la resolución seleccionada
	#Finalmente, con el array parts, conseguimos la variable de la resolución
	var resolution = Vector2i(resolutions[index], resolutions[index]);
	#Luego de ésto, asignamos el tamaño a la pantalla
	get_window().size = resolution;

func _onFullscreenToggled(toggle: bool):
	if (toggle):
		#Checamos que si está como verdadero, entonces asignamos el efecto de fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	else:
		#Quitamos el fullscreen y reactivamos las resoluciones
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		#Reaplicamos la resolución de pasar de fullscreen
		#_onResolutionSelected(selectedIndex);
	
func _onVSyncToggled(toggle: bool):
	#Activamos y desactivamos el toggle
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if (toggle)
		else DisplayServer.VSYNC_DISABLED
	);

func _boolToString(bool):
	return "ON" if bool else "OFF";
