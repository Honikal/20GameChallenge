class_name Player;
extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D;
@onready var animator: AnimationPlayer = $AnimationPlayer;

@onready var jump_timer: Timer = $JumpTimer
@onready var movement: Movement = $Movement
@onready var hitbox: Area2D = $Hitbox

#Acá manejamos los sonidos y los extraemos
@onready var stream_audio: AudioStreamPlayer = $FlapSound
const FLAP_SOUND = preload("res://Resources/Sounds/Flap sound.wav");
const HIT_SOUND = preload("res://Resources/Sounds/Hit sound.wav");
const DEAD_SOUND = preload("res://Resources/Sounds/Dead sound.wav");

@export var move_stats: MoveStats;

var CEIL  = 0;
var FLOOR = ProjectSettings.get_setting("display/window/size/viewport_height");

#Variable para determinar si el personaje está saltando o no
var is_jumping = false;

var is_dead = false;
var is_on_ground = false;

#Creamos una señal para determinar que el jugador chocó contra algo por lo tanto el juego ha terminado
signal player_is_dead;
signal player_on_ground;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.play("Fall");
	is_jumping = false;
	
	#Timer como tal
	jump_timer.timeout.connect(_reset_jump);
	
	#Conexión con la señal para indicar posible muerte o choque con obstáculo
	hitbox.area_entered.connect(_game_over_ground);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Si el jugador no está saltando, entonces reducimos la dirección del jugador para ir abajo
	if (!is_jumping and !is_on_ground):
		movement.velocity = Vector2(0, move_stats.birdFallSpeed);
		sprite.play("down");
		
	#Validamos para incrementar la velocidad
	if (is_dead):
		if (!is_on_ground):
			movement.velocity = Vector2(0, move_stats.deadBirdSpeed);
		return;
	
	if (Input.is_action_just_pressed("ui_jump") and !is_jumping and !is_dead):
		#If player presses jump and is not jumping, then we can do the jump
		is_jumping = true;
		movement.velocity = Vector2(0, move_stats.birdFlySpeed);
		sprite.play("idle");
		jump_timer.start();    #Activamos el jumper como tal
		animator.play("Fly");
		stream_audio.play();     #Activamos sonido
		

func _reset_jump():
	#Reseteamos el salto a false, para indicar que se puede saltar de nuevo
	is_jumping = false;
	animator.play("Fall");

func _game_over_ground(node: Node2D):
	if (not is_on_ground):
		#Primero activamos ésto para definir el sonido
		is_on_ground = true;
		_player_die();
		
		#Detenemos el movimiento
		movement.velocity = Vector2(0, 0);
		print("Chocamos con el suelo desde el player");
		player_on_ground.emit();
		
		#Reproducimos sonido
		stream_audio.stream = DEAD_SOUND;
		stream_audio.play();
	
func _player_die():
	if (not is_dead):
		print("Chocamos con obstáculo");
		sprite.play("dead");
		animator.play("Dead");
		is_dead = true;
		is_jumping = false;
		
		#Emitimos una señal para indicar que el jugador esté muerto
		player_is_dead.emit();
		
		#Emitimos un sonido
		if (!is_on_ground):
			stream_audio.stream = HIT_SOUND;
			stream_audio.play();
		else:
			print("Cayó, no es necesario ponerle sonido");
	
