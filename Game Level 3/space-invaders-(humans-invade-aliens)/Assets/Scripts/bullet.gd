class_name Bullet;
extends CharacterBody2D

@export var move_stats: MoveStats;

var baseResolution = Vector2(640, 360);
var explosion_scene = preload("res://Assets/Scenes/ParticleGenerated.tscn");

const EXPLOSIONSOUND = preload("res://Assets/Sounds/explosion_sound.wav");

#Variable a la cual hemos de modificar respecto a la posición de dónde se disparará
var direction : Vector2;

#Variable para checar el límite de acuerdo a la pantalla
var margin_y = 16;
var boundarie_y;  #Sacamos el tamaño en base a la pantalla y

func _ready() -> void:
	#Seteamos valores para cambiar
	var SCREEN_SIZE = get_viewport().get_visible_rect().size;
	boundarie_y = SCREEN_SIZE.y;
	var scale_factor = SCREEN_SIZE / baseResolution;
	scale = scale * scale_factor;

func _process(delta: float) -> void:
	velocity = direction;
	velocity.y *= move_stats.bullet_speed;
	
	#Pasamos de move_and_slide a move_and_collide
	#move_and_slide()
	var collision = move_and_collide(velocity * delta);
	
	#Ahora, agarramos la posible colisión y checamos si existe
	if (collision):
		#Primero que todo, ocupamos tomar el collider
		var collider = collision.get_collider();
		
		#Acá existen 3 posibles casos, el collider sea bala, jugador, o nave enemiga, en cualquier de los casos
		#El objeto bala es destruido y con el que se colisiona también
		
		if (collider is not Bullet):
			#Aplicamos el sonido de explosión
			SoundsManager._change_sound(EXPLOSIONSOUND);
			SoundsManager._play_normal();
			
			#Liberamos ambos objetos
			collider.shipDestroyed.emit(); #Llamamos a la señal de destrucción
		queue_free();
	
	if ((position.y > boundarie_y + margin_y) or (position.y < -margin_y)):
		#Liberamos el objeto de la memoria del juego
		queue_free(); 
