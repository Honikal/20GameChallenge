extends Node

#Variables para determinar que el juego ha terminado
var gameover = false;

#Manejamos las variables exportadas del juego
@export var game_stats: GameStats;
@export var move_stats: MoveStats;

#Manejamos el archivo de guardado
const SAVE_PATH = "user://save.cfg";
const SAVE_TEST_PATH = "res://save.cfg";
var save_path = SAVE_TEST_PATH;

#Extraemos acceso a los objetos que vamos a usar
@onready var enemy_generator: Timer = $EnemyGenerator
@onready var score_timer: Timer = $ScoreTimer
@onready var spawner: Spawner = $Spawner
@onready var background: Background = $Background
@onready var player: Player = $Player
@onready var score_label: Label = $UI_Manager/VBoxContainer/ScoreLabel
@onready var gameover_manager: CanvasLayer = $Gameover_Manager

@onready var score_val: Label = $Gameover_Manager/Panel/Container/ScoreHandler/ScoreVal
@onready var highscore_val: Label = $Gameover_Manager/Panel/Container/HighscoreHandler/HighscoreVal

@onready var retry_button: Button = $Gameover_Manager/Panel/Container/ButtonsSection/RetryButton
@onready var quit_button: Button = $Gameover_Manager/Panel/Container/ButtonsSection/QuitButton
@onready var menu_button: Button = $Gameover_Manager/Panel/Container/ButtonsSection/MenuButton


func _ready() -> void:
	randomize();
	gameover_manager.visible = false;
	
	#Seteamos el timer de forma que no cause problemas
	enemy_generator.wait_time = 4.0;
	enemy_generator.start();
	
	#Cargamos información del juego importante
	_loadFile();
	game_stats.score = 0;
	
	#Conectamos las posibles señales
	game_stats.score_changed.connect(_updateUI);
	enemy_generator.timeout.connect(_spawnObstacle);
	score_timer.timeout.connect(_updateScore);
	player.player_died.connect(_gameOver);
	retry_button.pressed.connect(_retryGame);
	quit_button.pressed.connect(_quitGame);
	menu_button.pressed.connect(_goToMenu);
	
	#Actualizamos los datos de la UI
	_updateUI(game_stats.score);
	
func _spawnObstacle():
	print("Spawneamos algo");
	spawner._handleSpawn();

		
		
func _gameOver():
	print("Game over");
	
	#Primero seteamos la función del game over a true
	gameover = true;
	enemy_generator.stop();
	enemy_generator.queue_free();
	score_timer.stop();
	score_timer.queue_free();
	
	#Detenemos la animación (agarramos el background, y a éste buscamos hacer que cada uno de los nodos de Parallax se
	#aplique una función de stop)
	background._stopMovement();
	
	#Detenemos el movimiento
	_stopEnemyMovement();
	#Guardamos la puntuación del juego
	_saveFile();
	
	#Activamos el game_over manager
	gameover_manager.visible = true;
	#Pasamos la puntuación ganada y el caso de nueva puntuación
	score_val.text = str(game_stats.score) + "M";
	highscore_val.text = str(game_stats.highscore) + "M";

func _updateUI(score: int):
	score_label.text = str(score) + "M"

func _stopEnemyMovement():
	pass

func _updateScore():
	#Actualizamos la puntuación o metros recorridos
	game_stats.score += 1;
	
	#Calculamos progreso de dificultad
	var progress = min(game_stats.score / game_stats.difficultyCurve, 1.0);
	
	#Actualizamos el chance de spawn grupos
	var current_group_chance = lerp(
		move_stats.groupSpawnBase,
		move_stats.groupSpawnMax,
		progress
	);
	move_stats.groupSpawnCurrent = current_group_chance;
	
	#Actualizamos el chance de spawn con movimientos extra
	var current_formation_chance = lerp(
		move_stats.formationBase,
		move_stats.formationMax,
		progress
	);
	move_stats.formationCurrent = current_formation_chance;
	
	#Código para incrementar la velocidad del fondo
	if (game_stats.score % move_stats.speedIncrInterval == 0):
		#Incrementamos la velocidad del background
		print("Incrementamos velocidad del background");
		background._increaseSpeed(move_stats.speedIncrPercentage);
		
	#Manejamos el tiempo de velocidad del spawn
	if ((game_stats.score > 0) and (game_stats.score % move_stats.spdEnemyIncInterval == 0)):
		#Reducimos por el porcentaje el wait time del timer
		print("Reducimos el tiempo del timer");
		var currentInterval = enemy_generator.wait_time;
		var newInterval = currentInterval * (1.0 - move_stats.spdSpawnReducer);
		enemy_generator.wait_time = clamp(newInterval, move_stats.minSpawnInterval, 4.0);
		
	#Opcional, incrementar la velocidad de movimiento de flotar del jugador
	#player.moveStats.floatSpeed *= 1 + move_stats.speedIncrPercentage;
	
	#Actualizamos el highscore de la partida
	if (game_stats.score > game_stats.highscore):
		game_stats.highscore = game_stats.score;
	
	_updateUI(game_stats.score);
	
func _saveFile():
	#Función encargada de setear o guardar el sistema o puntuación en el archivo
	var config = ConfigFile.new(); #Se crea un file sistem encargado de trabajar con el archivo de puntos
	
	#Seteamos o guardamos el puntaje, dentro de la sección game, en el value highscore
	#Ésto funciona similar a un struct o diccionario
	config.set_value("game", "highscore", game_stats.highscore);
	 
	#Y ahora guardamos en el ConfigFile en nuestro save_path
	config.save(save_path);
	
func _loadFile():
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
	
func _goToMenu():
	#Pasamos a la escenea del menú
	SceneTransition._change_scene("menu");
func _retryGame():
	#Reiniciamos el juego de forma inicial de nuevo, reiniciando la escena
	get_tree().reload_current_scene();
func _quitGame():
	#Cerramos el juego
	get_tree().quit();
