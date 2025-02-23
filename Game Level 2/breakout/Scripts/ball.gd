class_name Ball;
extends CharacterBody2D;

#Exportamos el variable para el movimiento
@export var move_stats: Move_Stats;
@onready var move_component: Move_Component = $Move_Component
@onready var sprite_2d: Sprite2D = $Sprite2D

#Manejamos el sonido como tal
@onready var audio_stream: VariablePitchAudioStream = $VariablePitchAudioStream
const BOUNCE_SOUND = preload("res://Resources/Sounds/bounce_sound.wav");

#Límite como tal para determinar que el balón desaparece una vez llega acá
#se quitarían puntos una vez llega a éste punto
var margin : int = 10;
var score_area = ProjectSettings.get_setting("display/window/size/viewport_height");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Seteamos el movimiento inicial del balón, su movimiento ha de ser aleatorio en moverse izquierda o derecha
	move_stats.actual_ball_speed = move_stats.initial_ball_speed;
	var direction = randi() % 2 * 2 - 1; #Éste valor puede que de 1 o -1
	move_component.velocity = Vector2(direction * move_stats.actual_ball_speed, move_stats.actual_ball_speed);
	
	#Modificamos al inicio el sonido a usar
	audio_stream._change_sound(BOUNCE_SOUND);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Movemos el balón y controlamos colisiones
	var collision = move_component._move(delta);
	
	#Si surge alguna colisión posible
	if collision:
		#Tomamos la normal de la colisión
		var normal = collision.get_normal();
		
		#Movemos el balón un poco lejos de su campo de colisión para que no haya problemas
		position += normal * 0.1;
		
		#Controlamos el rebote
		_bounce(normal);
		
		#Si con quien colisionamos es un ladrillo, lo destruimos e incrementamos la velocidad del balón
		if collision.get_collider() is Brick:
			#Liberamos el ladrillo de la memoria
			collision.get_collider().queue_free();
			#Incrementamos la velocidad del balón
			_increase_speed();
		
		
	
	#Rotamos el balón basado en la velocidad
	_rotate_ball(delta);
	
	#Si el balón entra al área donde le quitan puntos al jugador, entonces...
	if (global_position.y >= score_area + margin):
		queue_free();

func _bounce(normal: Vector2):
	#Normalizamos el vector para asegurarnos de un largo de 1 (no era el error)
	normal.normalized();
	#Reflejamos la velocidad a través de la normal
	move_component.velocity = move_component.velocity.bounce(normal);
	#Reproducimos el efecto de sonido
	audio_stream._play_with_variance();
	
func _wall_bounce():
	#Aplicamos un bounce horizontal, revertimos de forma horizontal la velocidad
	move_component.velocity.x *= -1;
	audio_stream._play_normal();
func _ceil_bounce():
	#Aplicamos un bounce vertical, dado cuando el balón choca el techo
	move_component.velocity.y *= -1;
	audio_stream._play_normal();

func _increase_speed():
	#print("Velocidad del balón antes del incremento: ", move_stats.actual_ball_speed);
	#Incrementa la velocidad del balón por un porcentaje
	var speed_increase = move_stats.increase_speed;
	move_stats.actual_ball_speed *= (1 + speed_increase);
	
	#Actualizamos la velocidad del balón y su vector para reflejar la velocidad
	var direction = move_component.velocity.normalized();
	move_component.velocity = direction * move_stats.actual_ball_speed;
	#print("Velocidad del balón después del incremento: ", move_stats.actual_ball_speed)

func _rotate_ball(delta):
	#Para ésta función pedí ayuda a Deepseek, simplemente es para darle un toque más realista al movimiento del balón
	var rotation_speed = move_component.velocity.length() * delta * 0.01; #Ajustamos el multiplicante para la rotación deseada
	
	#Aplicamos la rotación, antes checabamos dependiendo si iba izquierda o derecha, ahora no
	sprite_2d.rotation += rotation_speed; 
