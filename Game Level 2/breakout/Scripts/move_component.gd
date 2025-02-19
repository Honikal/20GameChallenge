class_name Move_Component
extends Node

@export var actor: Node2D;
@export var velocity: Vector2;

func _process(delta: float) -> void:
	#Acá manejamos el movimiento en general del objeto como tal
	actor.translate(velocity * delta);
