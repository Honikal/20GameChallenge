class_name Paddle;
extends Node2D;

#Exportamos las variables (movimiento y demás).
@export var move_stats: MovementStats;
@export var game_mode: int       #Elige entre el modo de jugabilidad de 2 jugadores o IA
@export var player_1_2: int = 1; #Elige el jugador como tal

#Tenemos acceso al archivo como tal
@onready var move_component: MoveComponent = $MoveComponent;
@onready var move_input_component: MoveInputComponent = $MoveInputComponent;
@onready var pos_control_component: PosControlComponent = $PosControlComponent;

@onready var ai_check_mov: Area2D = $AICheckMovement;

#Tomamos las medidas de forma constante de las paletas, para definir una distancia de movimiento
const PADDLE_WIDTH = 12;
const PADDLE_HEIGHT = 48;

#Buscamos al nodo que se desea buscar a la hora de usar el IA
var nodo_targeteado: Node2D = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Modo de juego elegido: ", game_mode);
	if (game_mode != 0):
		if (player_1_2 == 2):
			move_input_component.player_1_o_2 = player_1_2;  #Cambiamos al jugador como tal
			_change_move_state(true);
	else:
		if (player_1_2 == 2):
			_change_move_state(false);
	
	#Si el jugador es segundo jugador, entonces cambiamos la visualización de la paleta al otro lado	
	if (player_1_2 == 2):
		print("Cambiamos de orden");
		scale.x = -1;
		
	#Ahora, luego de establecer el tipo de movimiento, lo que haremos es que activaremos las señales como tal
	ai_check_mov.area_entered.connect(_ball_enters_track);
	ai_check_mov.area_exited.connect(_ball_exits_track);

func _change_move_state(state: bool):
	move_input_component.validar_movimiento = state;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Acá hacemos llamado a la función de la IA
	if (nodo_targeteado != null and game_mode == 0 and player_1_2 == 2):
		#Acá checamos que el balón esté en el área, el modo de juego sea el de IA, y 
		#que el jugador sea el second player
		_chase_ball(nodo_targeteado);
	
func _ball_enters_track(area: Area2D):
	nodo_targeteado = area;
func _ball_exits_track(area: Area2D):
	nodo_targeteado = null;
	move_component.velocity.y = 0;
	
func _chase_ball(area: Area2D) -> void:
	#Error común, es agarrar el área del balón, lo que buscamos es agarrar al padre de dicho área.
	#En éste caso el balón
	var balon = area.get_parent() as Ball;
	
	#Tomamos la posición exacta del balón al cual buscamos perseguir
	var ball_y = balon.global_position.y;
	
	#Calculamos el rango del movimiento de la barra
	var paddle_y_begin = global_position.y;
	var paddle_y_end = global_position.y + PADDLE_HEIGHT;
	
	if (ball_y < paddle_y_begin):
		#Si el balón se encuentra arriba de la posible ubicación exacta del paddle
		move_component.velocity = Vector2(0, -1 * move_stats.paddle_speed);
	elif (ball_y > paddle_y_end):
		#Si el balón se encuentra abajo de la posición central de la paleta
		move_component.velocity = Vector2(0, 1 * move_stats.paddle_speed);
	else:
		#La paleta se encuentra al centro del balón
		move_component.velocity = Vector2.ZERO;
	
