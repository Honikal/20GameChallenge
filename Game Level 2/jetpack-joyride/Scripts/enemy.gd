class_name Enemy;
extends CharacterBody2D;

#Manejamos el tipo de movimiento
enum FORMATION_TYPE { NONE, H_LINE, V_LINE, CIRCLE }
@export var formation : FORMATION_TYPE = FORMATION_TYPE.NONE; #Forma de asignar tipo y valor

#Manejamos el movimiento de los obstáculos
@export var move_stats: MoveStats;

#Manejamos variables para determinar la destrucción del obstáculo
@export var marginObstacle = 10;
var boundsLeft = 0;

var base_movement : float;
var formation_offset : Vector2 = Vector2.ZERO;

func _movement(delta):
	if (formation == FORMATION_TYPE.NONE):
		#El movimiento es normal, no hay formaciones
		velocity.x = -move_stats.enemyMovement;
	else:
		#Existe movimiento basado en formación
		_formationMovement(delta);
		
func _formationMovement(delta):
	match formation:
		FORMATION_TYPE.H_LINE:
			velocity.x = -move_stats.enemyMovement * move_stats.enemyFormationSpeedMult;
			velocity.y = sin(Time.get_ticks_msec() * 0.01) * 50; #Creamos una especie de línea sine
		FORMATION_TYPE.V_LINE:
			velocity.x = -move_stats.enemyMovement;
			velocity.y = cos(Time.get_ticks_msec() * 0.01) * 75; #Oscilación vertical
		FORMATION_TYPE.CIRCLE:
			velocity.x = -move_stats.enemyMovement * (move_stats.enemyFormationSpeedMult - 0.2);
			#Agregamos un movimiento por rotación
			var angle = Time.get_ticks_msec() * 0.001;
			formation_offset = Vector2(cos(angle), sin(angle)) * 50;
			position += formation_offset * delta;

func _process(delta: float) -> void:
	#Aplicamos la función encargada del movimiento
	_movement(delta);
	
	#Aplicamos movimiento por move and slide
	move_and_slide();
	
	#Checamos que no se salga fuera de los límites
	_freeFromMemory();


func _freeFromMemory():
	if (global_position.x <= boundsLeft - marginObstacle):
		queue_free();
		
func _stopMovement():
	velocity = Vector2(0, 0);
