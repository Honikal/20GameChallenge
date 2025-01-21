class_name Obstacle;
extends Area2D;

#Nos encargamos del movimiento
@onready var move_component = $Movement as Movement;

#Manejamos el movimiento de los obstáculos
@export var move_stats: MoveStats;

#Manejamos las variables para determinar la aparición del obstáculo
@export var marginObstacle = 18;
var boundsLeft = 0;

#Flag para apagar movimiento
var game_over: bool = false;

#Señal para identificar que el jugador chocó contra obstáculo
signal hit;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.area_entered.connect(_player_collided)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (not game_over):
		move_component.velocity = Vector2(-move_stats.obstacleSpeed, 0);
	
	#Checamos por si la tubería se encuentra fuera de límites
	_clear_obstacle_memory();

func _stop_movement():
	game_over = true;
	move_component.velocity = Vector2(0, 0);

func _clear_obstacle_memory():
	if (global_position.x <= boundsLeft - marginObstacle):
		queue_free();

func _player_collided(player: Area2D):
	print("Player colisionó con obstáculo");
	hit.emit();
