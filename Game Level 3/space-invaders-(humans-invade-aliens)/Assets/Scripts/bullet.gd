class_name Bullet;
extends CharacterBody2D

@export var move_stats: MoveStats;

#Variable a la cual hemos de modificar respecto a la posición de dónde se disparará
var direction : Vector2;

#Variable para checar el límite de acuerdo a la pantalla
var margin_y = 16;
var boundarie_y = ProjectSettings.get_setting("display/window/size/viewport_height");

func _process(delta: float) -> void:
	velocity = direction;
	velocity.y *= move_stats.bullet_speed;
	move_and_slide();
	
	if ((position.y > boundarie_y + margin_y) or (position.y < -margin_y)):
		#Liberamos el objeto de la memoria del juego
		print("Clean bullet");
		queue_free();
