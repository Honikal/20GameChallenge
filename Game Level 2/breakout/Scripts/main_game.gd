extends CanvasLayer;

#Exportamos la escena del ladrillo para instanciarla
@export var brick_scene: PackedScene;
@export var ball_scene: PackedScene;

#Exportamos el recurso de puntaje del juego
@export var game_stats: Game_Stats;

#Ahora preparamos el sistema de guardado de puntaje (usamos 2 sistema, el normal, y el de testeo)
const SAVE_PATH = "user://save.cfg";
const SAVE_TEST_PATH = "res://save.cfg";
var save_path = SAVE_TEST_PATH;

#Exportamos el contenedor de vidas y los Labels
@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var highscore_label: Label = $MarginContainer/HBoxContainer/HighscoreLabel
@onready var game_info_label: Label = $CenterContainer/GameInfoLabel

@onready var game_over_container: VBoxContainer = $CenterContainer/GameOverContainer
@onready var score_value: Label = $CenterContainer/GameOverContainer/HBoxContainer/VBoxContainer/ScoreValue
@onready var h_score_value: Label = $CenterContainer/GameOverContainer/HBoxContainer/VBoxContainer2/HScoreValue
@export var lives_container: HBoxContainer;

@onready var timer: Timer = $Timer #Timer para mostrar la info

#Tomamos el sonido por cada vida perdida
@onready var audio_stream: VariablePitchAudioStream = $AudioStream
const LOSE_LIFE = preload("res://Resources/Sounds/lose_life_sound.wav");

#Flags a usar como tal
var ball_spawned = true;
var game_over = false;

#Variables a tomar en consideración
var current_lives : int;

#Variables de importancia
var boundary_right = ProjectSettings.get_setting("display/window/size/viewport_width");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize(); #Randomizamos la posible semilla
	
	#Cargamos la información del juego
	_load_highscore();
	game_stats.score = 0;
	
	#Inicializamos las vidas del juego
	current_lives = game_stats.lifes;
	_update_score_display();
	_update_lives_display();
	
	#Primero que todo vamos a generar todos los ladrillos posibles, para ésto llamamos a la función como tal
	_generate_bricks();
	
	#Éste timer se encarga de ejecutarse para enviar el mensaje al jugador de presionar el botón espacio para lanzar el balón
	timer.timeout.connect(_begin_game_info);
	
	#Tomamos el sonido como tal a usar
	audio_stream._change_sound(LOSE_LIFE);
	

func _generate_bricks():
	#Considerando que un ladrillo mide 32x16, tenemos que generar 10 por fila, por ahora generaremos 4 filas (por que solo
	#tenemos 4 colores), y tenemos que instanciar cada uno de los ladrillos a una distancia específica
	
	#Dimensiones del ladrillo
	var brick_width  = 32;
	var brick_height = 16;
	#Espacio en márgenes como tal
	var margin_x: int = 16;
	var margin_y: int = 32;
	var spacing_x: int = 0;
	var spacing_y: int = 2;
	#Número de ladrillos por fila y número de filas
	var bricks_x_row = 10;
	var rows = 4;
	
	#Iteramos como tal por filas
	for row in range(rows):
		#Iteramos por columnas
		for col in range(bricks_x_row):
			#Calculamos la posición del ladrillo
			var x: int = margin_x + (brick_width) * col;
			var y: int = margin_y + (brick_height + spacing_y) * row;
			
			#Instanciamos el ladrillo y asignamos la posición
			var brick : Brick = brick_scene.instantiate();
			brick.global_position = Vector2(x, y);
			brick.frame_color = row; #También usamos el número de fila para determinar el color
			add_child(brick);
			
			#El ladrillo es liberado del sistema, actualizamos el sistema de puntuación
			brick.tree_exited.connect(_update_score);
			
func _generate_ball():
	#Asignamos las variables de aparición del objeto
	var x: int = boundary_right / 2;
	var y: int = 256;
	
	var ball : Ball = ball_scene.instantiate();
	ball.global_position = Vector2(x, y);
	add_child(ball);
	ball_spawned = true; #Activamos el hecho que el balón se activó
	game_info_label.visible = false; #Desactivamos el mensaje visual
	
	#Checamos la posibilidad del balón sea liberado del sistema, en dicho caso, llamamos ésto
	ball.tree_exited.connect(_update_life_stats);

func _update_score():
	#Actualizamos el puntaje de la partida
	game_stats.score += 5;
	
	#Actualizamos el highscore de la partida
	if (game_stats.score > game_stats.highscore):
		game_stats.highscore = game_stats.score;
		
	_update_score_display();

func _update_life_stats():
	#El balón desaparece, perdemos una vida, y damos posibilidad de al presionar espacio vuelva a aparecer
	current_lives -= 1;	
	_update_lives_display();
	
	#Reproducimos efecto de sonido de perder vida
	audio_stream._play_normal();
	
	if (current_lives == 0):
		_save_highscore();
		_game_over();
	else:
		timer.start(); #Llamamos de nuevo el timer para que se detecte el juego
		
func _game_over():
	game_over = true;
	game_over_container.visible = true;
	score_value.text = str(game_stats.score);
	h_score_value.text = str(game_stats.highscore);

#Funciones de UI
func _update_lives_display():
	#Función encargada de administrar visualmente la vida de la partida
	#Limpiamos los posibles sprites previos que representan la vida
	for child in lives_container.get_children():
		child.queue_free();
		
	#Agregamos nueva cantidad de balones dependiendo de la cantidad de vidas actuales que se tienen
	for i in range(current_lives):
		var ball_sprite = TextureRect.new();
		ball_sprite.texture = preload("res://Resources/Sprites/Ball.png");
		ball_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED;
		lives_container.add_child(ball_sprite);

func _update_score_display():
	score_label.text = str(game_stats.score);
	highscore_label.text = str(game_stats.highscore);
		
func _begin_game_info():
	ball_spawned = false;
	game_info_label.visible = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Checamos que el jugador presione el botón de lanzamiento del balón, en ese caso, generamos el balón
	if (game_over):
		if (Input.is_action_just_pressed("ui_accept")):
			pass
		elif (Input.is_action_just_pressed("ui_exit")):
			SceneTransition._change_scene("menu");
	else:
		if (Input.is_action_just_pressed("ui_accept") && !ball_spawned):
			_generate_ball();

func _save_highscore(): 
	#Función encargada de setear o guardar el sistema o puntuación en el archivo
	var config = ConfigFile.new(); #Se crea un file sistem encargado de trabajar con el archivo de puntos
	
	#Seteamos o guardamos el puntaje, dentro de la sección game, en el value highscore
	#Ésto funciona similar a un struct o diccionario
	config.set_value("game", "highscore", game_stats.highscore);
	 
	#Y ahora guardamos en el ConfigFile en nuestro save_path
	config.save(save_path);

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
