class_name Enemy;
extends CharacterBody2D;

@export var move_stats: MoveStats;

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var nuzzle: Marker2D = $Nuzzle

var direction_x : int = 1;
var bullet_scene = preload("res://Assets/Scenes/EnemyBullet.tscn");
var explosion_scene = preload("res://Assets/Scenes/ParticleGenerated.tscn");
var canItShoot = false;  #Acá definimos si puede disparar o no
var dropDistance = 16; 

signal shipDestroyed;

func _ready() -> void:
	randomize();
	#Empezamos el posible timer de disparo
	
	#Iniciamos el timer de disparo en base a un valor random
	var time = randf_range(3.0, 5.75);
	shoot_timer.start(time);
	
	#Llamamos a la función encargada de generar el disparo
	shoot_timer.timeout.connect(_shoot_bullet);
	shipDestroyed.connect(_destroyShip);

func _process(delta: float):
	velocity.x = direction_x * move_stats.enemy_speed;
	#Aplicamos movimiento
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
	var time = randf_range(3.0, 5.75);
	shoot_timer.start(time);

func _destroyShip():
	var exp_inst : GPUParticles2D = explosion_scene.instantiate();
	get_parent().add_child(exp_inst);
	
	#Emitimos la explosión
	exp_inst.global_position = global_position;
	exp_inst.emitting = true;
	
	#Destruimos el objeto
	queue_free();
