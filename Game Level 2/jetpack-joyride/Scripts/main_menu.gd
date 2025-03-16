extends Node

@onready var play_btn: Button = $MenuUI/Panel/ButtonsSection/PlayBtn
@onready var options_btn: Button = $MenuUI/Panel/ButtonsSection/OptionsBtn
@onready var exit_btn: Button = $MenuUI/Panel/ButtonsSection/ExitBtn
@onready var back_btn: Button = $MenuUI/Panel/OptionsSection/BackBtn

@onready var buttons_section: VBoxContainer = $MenuUI/Panel/ButtonsSection
@onready var options_section: VBoxContainer = $MenuUI/Panel/OptionsSection

#Sección de botones de opciones
@onready var resolution_option: OptionButton = $MenuUI/Panel/OptionsSection/ResolutionContainer/ResolutionOption
@onready var full_screen_check: CheckBox = $MenuUI/Panel/OptionsSection/FullScreenCheck
@onready var vsync_check: CheckBox = $MenuUI/Panel/OptionsSection/VSyncCheck

#Manejamos el archivo de guardado
const CONFIG_PATH = "user://display_settings.cfg";
const CONFIG_TEST_PATH = "res://display_settings.cfg";
var save_path = CONFIG_PATH;

func _ready() -> void:
	play_btn.pressed.connect(_goToPlay);
	options_btn.pressed.connect(_turnOnOptions);
	exit_btn.pressed.connect(_exitGame);
	back_btn.pressed.connect(_turnOffOptions);
	
	resolution_option.item_selected.connect(_onResolutionSelected);
	full_screen_check.toggled.connect(_onFullScreenToggled);
	vsync_check.toggled.connect(_onVsyncToggled);
	
	#Cargamos los settings
	_populateResolutions();
	_load_display_setting();
	
func _goToPlay():
	SceneTransition._change_scene("game");
func _turnOnOptions():
	options_section.visible = true;
	buttons_section.visible = false;
func _turnOffOptions():
	buttons_section.visible = true;
	options_section.visible = false;
func _exitGame():
	#Cerramos el juego
	get_tree().quit();

func _populateResolutions():
	#Primero, agarramos una lista de resoluciones
	var resolutions = [
		#Vector2i(1920, 1080),
		#Vector2i(1600, 900),
		Vector2i(1366, 768),
		Vector2i(1280, 720),
		Vector2i(1024, 576),
		Vector2i(640, 360)
	]
	
	#Primero limpiamos la lista de opciones, y procedemos a repopular
	resolution_option.clear();
	for res in resolutions:
		resolution_option.add_item("%d x %d" % [res.x, res.y]);

func _onResolutionSelected(index : int):
	#Primero extraemos el texto de la resolución seleccionada
	var selectedText = resolution_option.get_item_text(index);
	#Luego separamos las resoluciones que están divididads por una x
	var parts = selectedText.split(" x ");
	#Con base al array de partes, conseguimos la variable de resolución
	var resolution = Vector2i(int(parts[0]), int(parts[1]));
	
	#Ahora, asignamos el tamaño de la pantalla
	get_window().size = resolution;
	
	#Centramos la pantalla si no está el fullscreen
	if (DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN):
		get_window().position = (DisplayServer.screen_get_size() - resolution) / 2;
	
	#Guardamos los cambios modificados dentro de info del juego
	_save_display_settings();
	
func _onFullScreenToggled(toggle : bool):
	if (toggle):
		#Checamos, si el caso es verdadero, entonces asignamos el efecto de fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
		resolution_option.disabled = true;
	else:
		#Acá quitamos el fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		#Reaplicamos la resolución de pasar de fullscreen
		var selectedIndex = resolution_option.selected;
		_onResolutionSelected(selectedIndex);
		resolution_option.disabled = false;
		
	#Guardamos los cambios modificados dentro de info del juego
	_save_display_settings();
	
func _onVsyncToggled(toggle: bool):
	#Activamos y desactivamos el vsync
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if (toggle)
		else DisplayServer.VSYNC_DISABLED
	);
	#Guardamos los cambios modificados dentro de info del juego
	_save_display_settings();
	
func _save_display_settings():
	#Primero, manejamos el sistema o el archivo donde guardar
	var config = ConfigFile.new();
	
	#Guardamos la resolución actual
	var size = get_window().size;
	config.set_value("display", "resolution", "%dx%d" % [size.x, size.y]);
	
	#Guardamos si está en fullscreen
	config.set_value("display", "fullscreen", 
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	);
	
	#VSync state
	config.set_value("display", "vsync",
		DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED
	);
	
	config.save(save_path);

func _load_display_setting():
	#Función encargada de el cargar el puntaje mayor guardado en la última partida
	var config = ConfigFile.new(); #Se crea un sistema para cargar archivos
	var error = config.load(save_path);
	
	#Checamos o validamos si existe un error
	if error != OK:
		#Si encontramos un error, guardamos los default settings y retornamos
		print("Error encontrado");
		var default_resolution = Vector2i(640, 360);
		get_window().size = default_resolution;
		_save_display_settings();
		return;
		
	#Si no existe un error, procedemos a extraer las configuraciones para el juego
	var res_str = config.get_value("display", "resolution", "640x360");
	var parts = res_str.split("x");
	var resolution = Vector2i(int(parts[0]), int(parts[1]));
	
	#Busca y selecciona la resolución en el botón del juego
	var selected_index = -1;
	for i in range(resolution_option.item_count):
		var itemText = resolution_option.get_item_text(i);
		var itemParts = itemText.split(" x ");
		var itemRes = Vector2i(int(itemParts[0]), int(itemParts[1]));
		
		if (itemRes == resolution):
			selected_index = i;
			break;
	#Si se encuentra la resolución, lo asignamos
	if selected_index != -1:
		resolution_option.select(selected_index);
	
	#Cargamos fullscreen
	var fullscreen = config.get_value("display", "fullscreen", false);
	full_screen_check.button_pressed = fullscreen;
	_onFullScreenToggled(fullscreen);
	
	#Cargamos vsync
	var vsync = config.get_value("display", "vsync", false);
	vsync_check.button_pressed = vsync;
	_onVsyncToggled(vsync);
	
