extends AudioStreamPlayer;

#Canción a reproducir
const BACKGROUND_MUSIC = preload("res://Assets/Sounds/background_music.mp3");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Seleccionamos el bus por el cual se va a reproducir
	set_bus("Music");
	
	#Cargamos y seleccionamos la canción de background
	set_stream(BACKGROUND_MUSIC);
	
	#Activamos autoplay y looping
	set_autoplay(true);
	
	#Reproducimos el sonido como tal, y ya que está así, tiene como default loop
	play();
