extends Node

@export var game_stats: GameStats;

#Generamos la posición del segundo jugador
const SECOND_PLAYER_POS_X = 600;
const SECOND_PLAYER_POS_Y = 160;

#Tomamos los objetos dentro de la escena
@onready var ball: Ball = $Ball
@onready var player: Paddle = $Player
@onready var opponent: Paddle = $Opponent

@onready var press_space: Label = $UI/MarginContainer/VBoxContainer/TellPlayerInfo
@onready var score_counter: Label = $UI/MarginContainer/VBoxContainer/Score
@onready var show_winner: Label = $"UI/MarginContainer/VBoxContainer/Player win"

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize(); #Randomizamos la seed con la que se inicia la partida
	show_winner.visible = false; #Muestra el jugador ganador
	score_counter.visible = false;
	
	#Seteamos la selección de la jugabilidad como tal
	_game_mode_paddle(game_stats.modoJuego);
	
	#Llamamos al método de actualizar la puntuación inicialmente (setea los datos 0 0)
	_update_score_label(game_stats.scoreP1, game_stats.scoreP2);
	
	#Conectamos para detectar en caso que el juego tenga modificaciones de puntuación (y activamos el timer)
	game_stats.score_changed.connect(_reset_increase_score)
	
	#Conectamos con el timer para detectar de nuevo un movimiento de nuevo del balón como tal
	timer.timeout.connect(_reset_player_ball_pos);
	
	#Conectamos con la señal de game over para mostrar el jugador ganador 
	game_stats.player_wins.connect(_game_over);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Checamos para iniciar la partida
	if Input.is_action_just_pressed("ui_accept"):
		ball._iniciar_movimiento();
		press_space.visible = false;
		score_counter.visible = true;

func _game_mode_paddle(paddle_type: int):
	print("Elegimos el modo de juego: ", paddle_type);
	opponent.game_mode = paddle_type;
	opponent._ready(); #Repetimos la llamada del jugador para setear sus datos como tal
	
func _update_score_label(scoreP1: int, scoreP2: int):
	print("Actualizamos el puntaje         SP1: ", scoreP1, "    SP2: ", scoreP2);
	score_counter.text = str(scoreP1) + "         " + str(scoreP2);

func _reset_increase_score(scoreP1: int, scoreP2: int):
	_update_score_label(scoreP1, scoreP2);
	timer.start();
	
func _reset_player_ball_pos():
	#Acá, una vez el timer se apague, reiniciamos la posición del jugador contrincante y del balón como tal
	ball._iniciar_movimiento();

func _game_over(winner: String):
	show_winner.set_text(winner);
	show_winner.visible = true; #Si existe un setVisible()
	
	#Limpiamos balón y timer del sistema
	ball.queue_free();
	timer.queue_free();
