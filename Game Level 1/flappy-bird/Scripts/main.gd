extends Node2D

const PIPE_DELAY: int = 200;
const PIPE_RANGE: int = 80;
var spaceGround: int; 

#Manejamos un array de Pipes y de ScoreArea
var PIPES_ARRAY: Array[Obstacle]  = [];
var SCORE_ARRAY: Array[ScoreArea] = [];

#Exportamos las escenas de tutoría para poder instanciarla
@export var obstacle_scene : PackedScene;
@export var score_scene: PackedScene;
@export var move_stats: MoveStats;
@export var game_stats: GameStats;

var SCREEN_WIDTH  = ProjectSettings.get_setting("display/window/size/viewport_width"); 
var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height");

#Acceso con el jugador y la tubería como tal como tal
@onready var pipe_timer: Timer = $PipeTimer
@onready var player = $Player as Player;
@onready var background: Background = $Background
@onready var score_label: Label = $Control/Score
@onready var ground: Area2D = $Ground

@onready var gameover_screen: GameoverScreen = $GameoverScreen

#Define el juego terminado como tal
var game_over : bool = false;

func _ready() -> void:
	randomize();
	game_stats.score = 0
	gameover_screen.visible = false;
	
	#Otra forma de agarrar el tamaño de la pantalla
	SCREEN_HEIGHT = get_window().size.y;
	
	spaceGround  = ground.get_node("Sprite2D").texture.get_height();
	
	#Actualizamos visualmente como se ve el sistema de la puntuación
	_update_score(game_stats.score)
	
	#Conectamos con el timer de generador de obstáculos
	pipe_timer.timeout.connect(_generate_obstacles);
	
	#Detectamos con el caso posible de la señal para actualizar la puntuación
	game_stats.score_changed.connect(_update_score);
	
	#Conectamos o checamos para checar si el jugador aparece o muere
	player.player_is_dead.connect(_game_over)
	player.player_on_ground.connect(_show_gameover_screen);
	
	#Detectamos llamada para reiniciar
	gameover_screen.restart.connect(get_tree().reload_current_scene);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _generate_obstacles():
	#Acá nos encargamos de generar los obstáculos como tal
	var obstacle   : Obstacle = obstacle_scene.instantiate();
	var score_area : ScoreArea = score_scene.instantiate();
	
	var spawn_x = SCREEN_WIDTH + PIPE_DELAY; #Agregamos o hacemos que el valor aparezca como tal
	var spawn_y = (SCREEN_HEIGHT - int(spaceGround)) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE);
	
	#Reubicamos los datos como tal
	obstacle.position = Vector2(spawn_x, spawn_y);
	score_area.position = Vector2(spawn_x, spawn_y);
	
	#Conectamos la tubería para emitir la señal de tubería
	obstacle.hit.connect(_on_player_hit);
	
	#Agregamos la instancia al juego
	self.add_child(obstacle);
	self.add_child(score_area);
	
	#Modificamos el array de objetos como tal
	PIPES_ARRAY.append(obstacle);
	SCORE_ARRAY.append(score_area);
	
	#Checamos con la función para limpieza como tal, para generar sonidos
	obstacle.tree_exited.connect(_on_obstacle_freed.bind(obstacle));
	score_area.tree_exited.connect(_on_area_freed.bind(score_area));

func _on_player_hit():
	#Hacemos que el jugador reciba la señal del golpe como tal
	player._player_die();

func _game_over():
	#Detenemos la invocación de tuberías
	pipe_timer.stop();
	pipe_timer.queue_free();
	
	#Detenemos la animación
	background._stop_animation();
	
	#Detenemos el movimiento
	_stop_all_movement();
	
	#Seteamos los posibles valores
	gameover_screen._set_gameover(game_stats);
 
func _stop_all_movement():
	for obstacle in PIPES_ARRAY:
		obstacle._stop_movement();
	for area in SCORE_ARRAY:
		area._stop_movement();

func _update_score(new_score: int):
	print("Puntaje modificado");
	score_label.text = str(new_score);


func _show_gameover_screen():
	#Activamos la visualización de la pantalla como tal
	gameover_screen.visible = true;

func _on_obstacle_freed(obstacle: Obstacle):
	PIPES_ARRAY.erase(obstacle);

func _on_area_freed(area: ScoreArea):
	SCORE_ARRAY.erase(area);
	print("Generamos un efecto de sonido")
