class_name Bound_Ctrl_Component;
extends Node;

#Tomamos el Actor y el Margen
@export var actor: Node2D;
@export var margin : int = 30;

#Límites de movimiento del jugador
var left_boundary = 0;
var right_boundary = ProjectSettings.get_setting("display/window/size/viewport_width");

func _process(delta: float) -> void:
	#Controlamos el movimiento en eje x del actor, ahora, tomando el valor inicial siendo la ubicación del
	#jugador en posición x, tomamos un límite de movimiento siendo posición de margen, y siendo el máximo
	#en posición x el tamaño de la pantalla menos el margen de movimiento
	actor.global_position.x = clamp(actor.global_position.x, left_boundary + margin, right_boundary - margin);
