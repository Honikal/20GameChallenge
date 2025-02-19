class_name Player
extends Node2D

#Variables de exportación
@export var move_stats: Move_Stats; #Tenemos acceso a los stats de movimiento global del juego

@onready var area_2d: Area2D = $Area2D
@onready var move_component: Move_Component = $Move_Component

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Controlamos el movimiento del jugador mediante un axis, y controlamos el movimiento del jugador
	var input_axis;
	input_axis = Input.get_axis("ui_left", "ui_right");
	
	#También en ésto consideramos datos como el clamp a tomar en considerar para el movimiento, usando un clamp
	#para limitar el movimiento del jugador en un rango
	move_component.velocity = Vector2(input_axis * move_stats.paddle_speed, 0);
	
