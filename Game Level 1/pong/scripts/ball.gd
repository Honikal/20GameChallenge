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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Llamado la primera vez que el nodo entra a la escena inicial por primera vez
	#Primero, guardaremos la posición inicial
	inicia_posicion = global_position;
	
	#Conectamos todas las posibles señales a tomar en consideración, las conectamos a una posible función como tal
	bounce_component.on_bounce.connect(_rebotar)
	ball_collision.area_entered.connect(_cambiar_direccion)


func _rebotar(node: Node):
	move_component.velocity.y *= -1;

func _cambiar_direccion(node: Node):
	if (node != bounce_component):
		#Checamos por el posible choque (no de rebote), y en dicho caso, aplicaremos entonces el rebote
		#eligiendo de forma aleatoria eso sí el rebote del lado de la paleta (arriba o abajo)
		move_component.velocity.x *= -1;
		move_component.velocity.y = [move_stats.ball_speed, -move_stats.ball_speed].pick_random();

func _iniciar_movimiento():
	move_component.velocity.x = [move_stats.ball_speed, -move_stats.ball_speed].pick_random();

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
