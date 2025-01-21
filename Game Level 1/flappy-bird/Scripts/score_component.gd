class_name ScoreComponent
extends Node

#Exportamos los stats del juego para poder manipular los puntajes
@export var game_stats: GameStats;

func _update_score():
	game_stats.score += 1;
