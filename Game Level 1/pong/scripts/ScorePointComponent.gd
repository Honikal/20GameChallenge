class_name ScorePointComponent;
extends Node

@export var actor: Node2D;
@export var margin: int = 12;

#Creamos una señal para invocar una posible emisión de puntos
signal on_point_scored(player_num: int);

#Tomamos los bordes o límites
var borderLeft = 0;
var borderRight = ProjectSettings.get_setting("display/window/size/viewport_width");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (actor.global_position.x <= borderLeft + margin):
		on_point_scored.emit(2); #Jugador 2 consiguió un punto
	
	if (actor.global_position.x >= borderRight - margin):
		on_point_scored.emit(1); #Jugador 1 consiguió un punto
