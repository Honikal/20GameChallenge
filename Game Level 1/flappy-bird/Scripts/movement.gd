class_name Movement;
extends Node

#Manejamos el movimiento y multiplicación delta
@export var actor: Node2D;
@export var velocity: Vector2;

func _process(delta: float) -> void:
	actor.translate(velocity * delta);
