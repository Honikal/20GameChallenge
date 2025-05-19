extends TextureButton

@export var text : String = "Text Button":
	set(value):
		text = value;
		if is_inside_tree():
			_setupText();
		
@export var arrowMargin: int = 70;
@export var waveSpeed: float = 5.0;
@export var waveAmplitude: float = 30.0;
@export var rainbowSpeed:  float = 2;

@onready var label: RichTextLabel = $RichTextLabel
@onready var left: Sprite2D = $Left
@onready var right: Sprite2D = $Right

#Este script se encarga de establecer botones con los que se puede interactuar por teclado
func _ready() -> void:
	#Configurar el control del botón
	focus_mode = Control.FOCUS_ALL;				#Keyboard-only 
	mouse_filter = Control.MOUSE_FILTER_IGNORE; #Ignoramos el botón
		
	#Seteamos el botón para que funcione de forma interactiva
	_setupText();
	_hideArrows();
	
	#Manejamos las señales de los botones, cuando haya focus, activamos el caso que las flechas se activan
	focus_entered.connect(_showArrows);
	focus_exited.connect(_hideArrows);
	#mouse_entered.connect(grab_focus);
	
func _setupText():
	label.bbcode_enabled = true;
	if (has_focus()):
		#Si está seleccionado, aplicamos los efectos
		label.text = _get_animated_text();
	else:
		#Aplicamos el efecto normal
		label.text = "[center]%s[/center]" % text;
	
func _showArrows():
	#Hacemos que las flechas sean visibles y actualizamos la posición de la flecha
	left.visible = true;
	right.visible = true;
	_updateArrowPosition();
	_setupText(); #Aplicamos efecto por si acaso

func _hideArrows():
	left.visible = false;
	right.visible = false;	
	_setupText(); #Aplicamos efecto para quitar por si acaso
	
func _updateArrowPosition():
	#Calculamos las posiciones (x,y) del botón
	var y_pos = global_position.y + (size.y / 3);
	var x_pos = global_position.x + (size.x / 2);
		
	#Reubicamos las flechas
	left.global_position  = Vector2(x_pos - arrowMargin, y_pos);
	right.global_position = Vector2(x_pos + arrowMargin, y_pos);

func _get_animated_text() -> String:
	return "[center][wave amp=%s freq=%s][rainbow freq=%s]%s[/rainbow][/wave][/center]" % [
		waveAmplitude,
		waveSpeed,
		rainbowSpeed,
		text
	];
