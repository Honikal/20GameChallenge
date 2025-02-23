class_name VariablePitchAudioStream;
extends AudioStreamPlayer;

#Exportamos un mínimo y un máximo del pitch pensado en usar
@export var pitch_min : float = 0.6;
@export var pitch_max : float = 1.2;
@export var pitch_med : float = 1;

#Permitimos que el nodo padre pueda escoger si tiene o no variación de pitch
@export var auto_play_with_variance : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Si el sistema de variación de pitch es true, entonces reproducimos el sonido con variación
	if (auto_play_with_variance):
		_play_with_variance(0.0);
	else:
		_play_normal(0.0);
	
func _play_with_variance(from_position: float = 0.0):
	#Seteamos la escala del pitch antes de reproducir el sonido (escogiendo un valor aleatorio del rango dado).
	pitch_scale = randf_range(pitch_min, pitch_max);
	play(from_position);

func _play_normal(from_position: float = 0.0):
	#Reproducimos el sonido de forma normal
	pitch_scale = pitch_med;
	play(from_position);
	
func _change_sound(name_sound) -> void:
	#Asignamos el sonido como tal y lo reproducimos
	stream = name_sound;
