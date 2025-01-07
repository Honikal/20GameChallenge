class_name PosControlComponent;
extends Node;

@export var actor: Node2D;     #Actor al que se le reduce el movimiento
@export var margin: int = 20;  #Margen de diferencia para chocar con el máximo

#Tomamos los bordes o límites
var borderUp   = 0;
var borderDown = ProjectSettings.get_setting("display/window/size/viewport_height");

# Checamos por cada frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	actor.global_position.y = clamp(actor.global_position.y, borderUp + margin, borderDown - margin);
