class_name Move_Component
extends Node

@export var actor: CharacterBody2D;
@export var velocity: Vector2;

func _move(delta: float) -> KinematicCollision2D:
	#Acá manejamos el movimiento en general del objeto como tal y retornamos dicho elemento
	return actor.move_and_collide(velocity * delta);
