class_name GameoverScreen;
extends CanvasLayer;

#Tenemos acceso a como tal el objeto de los datos del juego
var gameover = false;
var game_stats: GameStats;

#Ahora preparamos el sistema de guardado de puntaje (usamos 2 sistema, el normal, y el de testeo)
const SAVE_PATH = "user://save.cfg";
const SAVE_TEST_PATH = "res://save.cfg";

var save_path = SAVE_TEST_PATH;

#Tomamos como tal los labels donde asignamos los puntajes como tal
@onready var score_value: Label = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/scoreValue
@onready var highscore_value: Label = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer2/highscoreValue

#Tomamos acceso a los botones
@onready var restart_button: Button = $CenterContainer/VBoxContainer/HBoxContainer2/restartButton
@onready var exit_button: Button = $CenterContainer/VBoxContainer/HBoxContainer2/exitButton
@onready var score_button: Button = $CenterContainer/VBoxContainer/HBoxContainer2/scoreButton

#Acá manejaríamos como se ven u observan los highscores

#Posibles sonidos para los botones como tal
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var medal_sprite: Sprite2D = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/medalSprite

signal restart;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Conectamos los botones para cambiar de lugar como tal
	restart_button.pressed.connect(_reset_game);
	exit_button.pressed.connect(_go_to_main_menu);
	
	#Manejamos los sonidos como tal
	#audio_stream_player.finished.connect()

func _set_gameover(gamestats: GameStats):
	gameover = true;
	self.game_stats = gamestats;
	
	#Código para pruebas
	#game_stats.score = 10
	#game_stats.score = 25
	#game_stats.score = 50
	#game_stats.score = 100
	
	_load_highscore();
	
	#Cambiamos medallas como tal
	_change_medals(game_stats.score);
	
	#Checamos la posibilidad de un nuevo highscore, en dicho caso nosotros lo mostraremos como tal
	if (game_stats.score > game_stats.highscore):
		#Actualizamos el nuevo highscore
		print("Modificamos el highscore");
		game_stats.highscore = game_stats.score;
		_save_highscore();
		
	#Modificamos el sistema de puntuación
	score_value.text = str(game_stats.score);
	highscore_value.text = str(game_stats.highscore);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _reset_game():
	restart.emit();
func _go_to_main_menu():
	SceneTransition._change_scene("menu");
func _go_to_score():
	pass;
	
func _change_medals(score: int):
	if (score >= 75):
		game_stats.platinum_medal = true;
		medal_sprite.frame = 4;
	if (score >= 50):
		game_stats.gold_medal = true;
		medal_sprite.frame = 3;
	if (score >= 25):
		game_stats.plate_medal = true;
		medal_sprite.frame = 2;
	if (score >= 10):
		game_stats.bronze_medal = true;
		medal_sprite.frame = 1;
	else:
		pass;
		
func _load_highscore():
	#Función encargada de el cargar el puntaje mayor guardado en la última partida
	var config = ConfigFile.new(); #Se crea un sistema para cargar archivos
	var error = config.load(save_path);
	
	#Checamos o validamos si existe un error
	if error != OK:
		#Si encontramos un error, retornamos
		print("Error encontrado");
		return;
		
	#Intentamos tomar el sistema de guardado, tomando el valor de puntaje o highscore
	game_stats.highscore = config.get_value("game", "highscore");
	game_stats.bronze_medal = config.get_value("medals", "bronze");
	game_stats.plate_medal = config.get_value("medals", "plate");
	game_stats.gold_medal = config.get_value("medals", "gold");
	game_stats.platinum_medal = config.get_value("medals", "platinum");
	
func _save_highscore():
	#Función encargada de setear o guardar el sistema o puntuación en el archivo
	var config = ConfigFile.new(); #Se crea un file sistem encargado de trabajar con el archivo de puntos
	
	#Seteamos o guardamos el puntaje, dentro de la sección game, en el value highscore
	#Ésto funciona similar a un struct o diccionario
	config.set_value("game", "highscore", game_stats.highscore);
	config.set_value("medals", "bronze", game_stats.bronze_medal);
	config.set_value("medals", "plate", game_stats.plate_medal);
	config.set_value("medals", "gold", game_stats.gold_medal);
	config.set_value("medals", "platinum", game_stats.platinum_medal);
	 
	#Y ahora guardamos en el ConfigFile en nuestro save_path
	config.save(save_path);
	
	print("Si guardamos los datos?");
