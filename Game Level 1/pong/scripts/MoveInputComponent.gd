class_name MoveInputComponent
extends Node

@export var move_stats: MovementStats;
@export var move_component: MoveComponent;

#Valor encargado para verificar si el jugador es jugador 1 o jugador 2 (en caso futuro online, default jugador 1)
var player_1_o_2 = 1;
var validar_movimiento = true;

#Detectamos movimiento o input axis, pero solo aplicamos movimiento solo cuando se acepta
func _input(event: InputEvent) -> void:
	var input_axis;
	if (player_1_o_2 == 1 and validar_movimiento):
		input_axis = Input.get_axis("player_1_up", "player_1_down");
		move_component.velocity = Vector2(0, input_axis * move_stats.paddle_speed);
	elif (player_1_o_2 == 2 and validar_movimiento):
		input_axis = Input.get_axis("player_2_up", "player_2_down");
		move_component.velocity = Vector2(0, input_axis * move_stats.paddle_speed);
