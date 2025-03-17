class_name Player;
extends CharacterBody2D;

#Variables a exportar
@export var moveStats : MoveStats;

#Variables del objeto jugador
var isFloating : bool = false;
var isDead : bool = false;
var isDeadAnimationFinished : bool = false;
var acceleration : float = 0.0;
var velocity_y : float = 0.0;

#Tenemos acceso a los componentes del nodo
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles_gen: CPUParticles2D = $CPUParticles2D
@onready var timer_to_fall: Timer = $Timer

#Controlamos el límite de la pantalla por el cual el jugador puede chocar
var margin = 20;
var bounds_y = ProjectSettings.get_setting("display/window/size/viewport_height");

func _ready() -> void:
	#Conectamos las señales
	timer_to_fall.timeout.connect(_fallAfterTimer);
	
func _process(delta: float) -> void:
	if (isDead):
		return; #Por ahora ignoramos movimiento si está muerto
		
	#Aplicamos gravedad si no está flotando (No se presiona el botón
	if (!isFloating):
		sprite_2d.set_animation("idle");
		velocity_y += moveStats.gravity * delta;
	else:
		sprite_2d.set_animation("float");
		particles_gen.set_emitting(true);
		
	#Checamos por input del jugador
	_handleInputs(delta);

	#Aplicamos la velocidad en el eje Y del jugador, y move and slide, en lugar de move and collide
	velocity.y = velocity_y;
	move_and_slide();
	
	#Checamos los límites de la pantalla
	if ((global_position.y >= bounds_y - margin) and !isFloating):
		velocity_y = 0;
		global_position.y = bounds_y - margin;
	elif ((global_position.y <= 0 + margin) and !isFloating):
		velocity_y = 0;
		global_position.y = margin;
		

func _handleInputs(delta):
	#Función donde controlamos todos los inputs del jugador y pruebas
	if (Input.is_action_pressed("ui_float")):
		#Se presiona el botón de vuelo y se mantiene presionado
		isFloating = true;
		acceleration += moveStats.floatAcceleration * delta;
		velocity_y = clamp(velocity_y - acceleration, -moveStats.floatSpeed, 0);
		print("Player position: ", position);
		print("Player rotation: ", rotation);
	if (Input.is_action_just_released("ui_float")):
		#Se deja de presionar el botón, el jugador empieza a caer
		acceleration = 0;
		if (isFloating):
			timer_to_fall.start();
	if (Input.is_action_just_pressed("ui_test")):
		#Checamos que se presione éste botón, en éste caso reproducimos la animación de muerte
		sprite_2d.set_animation("dead");

func _fallAfterTimer():
	isFloating = false;
	particles_gen.set_emitting(false);
	

	
