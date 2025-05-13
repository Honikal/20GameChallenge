class_name Player;
extends CharacterBody2D

#Primero, exportaremos el move_stats
@export var move_stats: MoveStats;

#Llamamos a los componentes del Player
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D	
@onready var nuzzle: Marker2D = $Nuzzle
@onready var shoot_timer: Timer = $ShootTimer

#Escena de bullet
var bullet_scene = preload("res://Assets/Scenes/PlayerBullet.tscn");
var explosion_scene = preload("res://Assets/Scenes/ParticleGenerated.tscn");

#Hacemos el disparo solo si se cumple
var isShooting = false; 
var margin_x = 20;
var boundary_window_x = ProjectSettings.get_setting("display/window/size/viewport_width");

signal shipDestroyed;


func _ready() -> void:
	shoot_timer.timeout.connect(_reloadShot);
	
func _process(delta: float) -> void:
	#Primero, acá checaremos la velocidad del jugador y el movimiento como tal
	_movement();
	
	#No podemos olvidar de aplicar el efecto de movimiento "move and slide" y
	#que aplica automáticamente delta
	move_and_slide();
	
	#Checamos posibilidad que dispare
	_shootBullet();
	
	#Checamos por movimiento y si velocidad x es igual a 0, cambiamos también animación
	_change_animation();
	
func _movement(): 
	#Mejor que hacer varios if y else, checamos desde acá
	var input_axis = Input.get_axis("ui_left", "ui_right");
	
	velocity.x = input_axis * move_stats.player_speed;
	
	#Acá sin embargo limitamos el movimiento y la posición a poder moverse
	global_position.x = clamp(global_position.x, 0 + margin_x, boundary_window_x - margin_x);
	

func _shootBullet():
	if (Input.is_action_just_pressed("ui_accept") and !isShooting):
		
		#Instanciamos la bala y la colocamos en el punto de posición de disparo
		var bullet_inst : Bullet = bullet_scene.instantiate();
		#Agregamos entonces la bala al padre
		get_parent().add_child(bullet_inst);
		
		bullet_inst.position = nuzzle.global_position;
		bullet_inst.direction = Vector2(0, -1); #Dirección, va hacia arriba la bala
		
		#Cambiamos el estado a que está disparando a verdadero (Iniciamos el disparo también)
		isShooting = true;
		shoot_timer.start();
		
func _reloadShot():
	isShooting = false;

func _change_animation():
	#Nos encargamos de cambiar la animación con base al movimiento
	if (velocity.x < 0):
		animated_sprite.play("Fly_left"); 
	elif (velocity.x > 0):
		animated_sprite.play("Fly_right");
	else:
		animated_sprite.play("Idle");

func _destroyShip():
	var exp_inst : GPUParticles2D = explosion_scene.instantiate();
	get_parent().add_child(exp_inst);
	
	#Emitimos la explosión
	exp_inst.global_position = global_position;
	exp_inst.emitting = true;
	
	#Destruimos el objeto
	queue_free();
