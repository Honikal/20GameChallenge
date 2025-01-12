class_name Ball;
extends Node2D;

#Exportamos la variable para tomar el movimiento del balón como tal
@export var move_stats: MovementStats;

#Manejamos el movimiento inicial como tal
var inicia_posicion : Vector2;

#Tomamos como tal los objetos del sistema
@onready var sprite = $Sprite2D as Sprite2D;
@onready var ball_collision = $BallCollision as Area2D;
@onready var move_component = $MoveComponent as MoveComponent;
@onready var bounce_component = $BounceBallComponent as BounceBallComponent;

#Parece  que ya funciona la identificación de componentes
@onready var score_point_component: ScorePointComponent = $ScorePointComponent; 
@onready var score_component: ScoreComponent = $ScoreComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Llamado la primera vez que el nodo entra a la escena inicial por primera vez
	#Primero, guardaremos la posición inicial
	inicia_posicion = global_position;
	
	#Conectamos todas las posibles señales a tomar en consideración, las conectamos a una posible función como tal
	bounce_component.on_bounce.connect(_rebotar)
	ball_collision.area_entered.connect(_cambiar_direccion)
	
	#Detectamos el caso en el que algún jugador haya conseguido un punto
	score_point_component.on_point_scored.connect(_point_scored)


func _rebotar(node: Node):
	move_component.velocity.y *= -1;

func _cambiar_direccion(node: Node):
	if (node != bounce_component):
		#Checamos por el posible choque (no de rebote), y en dicho caso, aplicaremos entonces el rebote
		#eligiendo de forma aleatoria eso sí el rebote del lado de la paleta (arriba o abajo)
		
		#Agregamos acá la aceleración como tal en el valor de x
		move_stats.ball_speed += (move_stats.ball_speed * move_stats.acceleration);
		
		move_component.velocity.x *= -1;
		move_component.velocity.y = [move_stats.ball_speed, -move_stats.ball_speed].pick_random();

func _iniciar_movimiento():
	#Seteamos la velocidad de vuelta a su valor original
	move_stats.ball_speed = move_stats.max_ball_speed;
	move_component.velocity.x = [move_stats.ball_speed, -move_stats.ball_speed].pick_random();

func _point_scored(num_player: int):
	#Acá aplicamos cambios de puntuación y también nos encargamos de efectuar reinicio de posición
	score_component.ajustarPuntuacion(num_player);
	_reiniciar_posicion();

func _reiniciar_posicion():
	#Acá reiniciamos posición del balón,
	global_position = inicia_posicion;
	move_component.velocity = Vector2(0, 0);
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
