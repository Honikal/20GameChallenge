class_name Enemy;
extends CharacterBody2D;

@export var move_stats: MoveStats;

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var nuzzle: Marker2D = $Nuzzle

var direction_x : int = 1;
var bullet_scene = preload("res://Assets/Scenes/EnemyBullet.tscn");
var explosion_scene = preload("res://Assets/Scenes/ParticleGenerated.tscn");

var actualSpeed : int; 	#Manejamos la velocidad actual del enemigo
var min_t;
var max_t;  #Variables para determinar el disparo

var canItShoot = false;  #Acá definimos si puede disparar o no
var canMove = true;      #Definimos un valor para definir que se puedan mover los enemigos o no (timer respawn)

var dropDistance = 12; 

signal shipDestroyed;

func _ready() -> void:
	randomize();
	#Empezamos el posible timer de disparo
	actualSpeed = move_stats.enemy_speed;
	
	#Iniciamos el timer de disparo en base a un valor random
	min_t = move_stats.enemy_fire_min.x;
	max_t = move_stats.enemy_fire_min.y;
	var time = randf_range(min_t, max_t);
	shoot_timer.start(time);
	
	#Llamamos a la función encargada de generar el disparo
	shoot_timer.timeout.connect(_shoot_bullet);
	shipDestroyed.connect(_destroyShip);

func _process(delta: float):
	velocity.x = direction_x * actualSpeed;
	#Aplicamos movimiento
	if (canMove):
		move_and_slide();

#Ésta función pública se encarga de modificar por fuera la nave a a generar
func _manage_ship(index):
	sprite_2d.set_frame(index);

func _shoot_bullet():
	if (canItShoot):
		#Instanciamos la bala enemiga
		var bullet_inst : Bullet = bullet_scene.instantiate();
		get_parent().add_child(bullet_inst);
		
		#Decidimos la ubicación de la bala y la dirección
		bullet_inst.position = nuzzle.global_position;
		bullet_inst.direction = Vector2(0, 1);
		
	#Iniciamos el timer de disparo en base a un valor random
	var time = randf_range(min_t, max_t);
	shoot_timer.start(time);

func _destroyShip():
	var exp_inst : GPUParticles2D = explosion_scene.instantiate();
	get_parent().add_child(exp_inst);
	
	#Emitimos la explosión
	exp_inst.global_position = global_position;
	exp_inst.emitting = true;
	
	#Destruimos el objeto
	queue_free();
	
func _setMove(value: bool):
	#Función pública que permite al jugador poder moverse
	canMove = value;

func _setNewSpeed(fraction: float):
	actualSpeed = lerp(move_stats.enemy_speed, move_stats.max_enemy_speed, fraction);
	min_t = lerp(move_stats.enemy_fire_min.x, move_stats.enemy_fire_max.x, fraction);
	max_t = lerp(move_stats.enemy_fire_min.y, move_stats.enemy_fire_max.y, fraction);

func _setSpeedPerLevel(currentLevel: int):
	var levelMult = 1.0 + (currentLevel - 1) * 0.05;
	actualSpeed = clamp(actualSpeed * levelMult, move_stats.enemy_speed, move_stats.max_enemy_speed);
	min_t = clamp(min_t / levelMult, move_stats.enemy_fire_max.x, move_stats.enemy_fire_min.x);
	max_t = clamp(max_t / levelMult, move_stats.enemy_fire_max.y, move_stats.enemy_fire_min.y);
