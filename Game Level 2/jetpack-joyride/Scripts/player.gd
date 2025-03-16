class_name Player;
extends CharacterBody2D;

#Variables a exportar
@export var moveStats : MoveStats;

const DEATH_SOUND = preload("res://Resources/Sounds/death.wav");
const FLOAT_SOUND = preload("res://Resources/Sounds/float.wav");

#Variables del objeto
var isFloating : bool = false;
var isDead : bool = false;
var acceleration : float = 0.0;
var velocity_y : float = 0.0;

#Tenemos acceso a los componentes del nodo
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer_to_fall: Timer = $TimerToFall
@onready var particles_gen: CPUParticles2D = $CPUParticles2D
@onready var explosion_gen: GPUParticles2D = $GPUParticles2D


#Creamos una señal para determinar que el jugador ha muerto
signal player_died;

#Controlamos los límites de la pantalla
var marginBottom = 50;
var margin = 10;
var height = ProjectSettings.get_setting("display/window/size/viewport_height");

func _ready() -> void:
	#Activamos el timer como tal
	timer_to_fall.timeout.connect(_fallAfterTimer);
	explosion_gen.finished.connect(_emitDeathSignal);
	
func _process(delta: float) -> void:
	#Checamos que el jugador esté muerto
	if (isDead):
		return;
		
	#Aplicamos gravedad si no está flotando
	if (!isFloating):
		sprite_2d.set_animation("idle");
		velocity_y += moveStats.gravity * delta;
	else:
		sprite_2d.set_animation("flying");
		particles_gen.set_emitting(true);
	
	#Checamos input del jugador
	_handleInput(delta);
	
	#Aplicamos la velocidad en Y, aplicamos move and slide en vez de colidar
	velocity.y = velocity_y;
	#Movemos y checamos por colisiones
	var was_collision = false;
	move_and_slide(); 

	#Checamos por colisión
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if (collision.get_collider() is Enemy):
			_die();
			was_collision = true;
			break;
			
	if (was_collision):
		return;
	
	#Checamos los limites de la pantalla
	if ((global_position.y >= height - marginBottom) and !isFloating):
		velocity_y = 0;
		global_position.y = height - marginBottom;
	
	#Prevenimos que el jugador se salga sobre el techo
	if (global_position.y <= margin):
		velocity_y = 0;
		global_position.y = margin;

func _handleInput(delta):
	#Manejamos el input del jugador
	if (!isDead):
		if (Input.is_action_pressed("float")):
			#Trackeamos si el jugador estaba flotando antes de presionar el botón
			var was_floating_before = isFloating;
			isFloating = true;
			
			#Emitimos sonido
			SoundsHandler._assignVolume(0.2);
			SoundsHandler._change_sound(FLOAT_SOUND);
			SoundsHandler._play_normal(0.01);
			
			#Checamos si estaba flotando antes
			if (!was_floating_before):
				#Si antes no estaba flotando, desaceleramos la gravedad, aplicando un bumb inicial para prevenir caída y reducir gravedad
				acceleration = moveStats.initialBumpAcceleration;
			else:
				#Aplicamos gravedad de forma continua mientras se mantenga el botón
				acceleration += moveStats.floatAcceleration * delta;
			velocity_y = clamp(velocity_y - acceleration, -moveStats.floatSpeed, 0);
		if (Input.is_action_just_released("float")):
			acceleration = 0;
			if (isFloating):
				timer_to_fall.start();

func _die():
	if (isDead):
		return;
		
	isDead = true;
	
	#Efectos visuales apagamos
	sprite_2d.set_animation("dead");
	particles_gen.emitting = false;
	
	#Emitimos sonido
	SoundsHandler._assignVolume(1);
	SoundsHandler._change_sound(DEATH_SOUND);
	SoundsHandler._play_normal();
	
	#Espawneamos partículas de muerte
	sprite_2d.visible = false;
	explosion_gen.emitting = true;
	
	#Paramos el movimiento
	velocity = Vector2.ZERO;
	
func _emitDeathSignal():
	#Emitimos la señal de muerte
	player_died.emit();
	#Liberamos al jugador
	queue_free();

func _fallAfterTimer():
	isFloating = false;
	particles_gen.set_emitting(false);
	
