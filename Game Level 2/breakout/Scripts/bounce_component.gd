class_name Bounce_Component;
extends Node;

#Tomamos el Actor y el Margen
@export var balon: Ball;
@export var margin : int = 10;

#Límites de movimiento del jugador
var left_boundary = 0;
var right_boundary = ProjectSettings.get_setting("display/window/size/viewport_width");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ((balon.global_position.x <= left_boundary + margin) || (balon.global_position.x >= right_boundary - margin)):
		balon._wall_bounce();
