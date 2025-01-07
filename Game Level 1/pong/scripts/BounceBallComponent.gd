class_name BounceBallComponent;
extends Node;

@export var actor: Node2D;
@export var margin: int = 12;

#Tomamos los bordes o límites
var borderUp   = 0;
var borderDown = ProjectSettings.get_setting("display/window/size/viewport_height");

#Creamos una señal para avisar la posibilidad de un rebote
signal on_bounce(node: Node);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (actor.global_position.y <= borderUp + margin or 
		actor.global_position.y >= borderDown - margin):
			on_bounce.emit(actor);
