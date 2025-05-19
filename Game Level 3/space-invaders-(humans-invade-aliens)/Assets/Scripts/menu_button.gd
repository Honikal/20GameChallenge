extends TextureButton

@export var text : String = "Text Button":
	set(value):
		text = value;
		if is_inside_tree():
			_setupText();
		
@export var waveSpeed: float = 5.0;
@export var waveAmplitude: float = 30.0;

@export var rainbowSpeed:  float = 2;
@onready var label: RichTextLabel = $RichTextLabel

#Este script se encarga de establecer botones con los que se puede interactuar por teclado
func _ready() -> void:
	#Configurar el control del botón
	focus_mode = Control.FOCUS_ALL;				#Keyboard-only 
	mouse_filter = Control.MOUSE_FILTER_IGNORE; #Ignoramos el botón
		
	#Seteamos el botón para que funcione de forma interactiva
	_setupText();
	
	#Manejamos las señales de los botones, cuando haya focus, activamos el caso que las flechas se activan
	focus_entered.connect(_setupText);
	focus_exited.connect(_setupText);
	#mouse_entered.connect(grab_focus);
	
func _setupText():
	label.bbcode_enabled = true;
	if (has_focus()):
		#Si está seleccionado, aplicamos los efectos
		label.text = _get_animated_text();
	else:
		#Aplicamos el efecto normal
		label.text = "[center]%s[/center]" % text;
	
func _get_animated_text() -> String:
	#Acá aplicaríamos diseño con rainbow, pero no aplicaremos wave
	"""
	return "[center][wave amp=%s freq=%s][rainbow freq=%s]%s[/rainbow][/wave][/center]" % [
		waveAmplitude,
		waveSpeed,
		rainbowSpeed,
		text
	];
	"""
	return "[center][rainbow freq=%s]%s[/rainbow][/center]" % [
		rainbowSpeed,
		text
	];
