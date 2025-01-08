class_name ScoreComponent
extends Node

@export var game_stats: GameStats;

func ajustarPuntuacion(num_player: int) -> void:
	#Llamamos a la señal de cambio de puntos o set del jugador respectivo
	if (num_player == 1):
		game_stats.scoreP1 += 1; 
	else:
		game_stats.scoreP2 += 1;
