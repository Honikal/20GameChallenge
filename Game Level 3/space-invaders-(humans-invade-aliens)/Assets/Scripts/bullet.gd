class_name Bullet;
extends CharacterBody2D

@export var move_stats: MoveStats;

var explosion_scene = preload("res://Assets/Scenes/ParticleGenerated.tscn");

#Variable a la cual hemos de modificar respecto a la posición de dónde se disparará
var direction : Vector2;

#Variable para checar el límite de acuerdo a la pantalla
var margin_y = 16;
var boundarie_y = ProjectSettings.get_setting("display/window/size/viewport_height");

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
		
		#Liberamos ambos objetos
		collider.shipDestroyed.emit(); #Llamamos a la señal de destrucción
		queue_free();
	
	if ((position.y > boundarie_y + margin_y) or (position.y < -margin_y)):
		#Liberamos el objeto de la memoria del juego
		queue_free(); 
