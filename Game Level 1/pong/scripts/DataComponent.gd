class_name Data_Component;
extends Node;

@export var game_stats: GameStats;

#Creamos funciones encargadas de pasar el tipo de juego y la puntuación máxima
func asign_game_mode(game_mode: int):
	game_stats.modoJuego = game_mode;
	
func asign_max_score(score: int):
	game_stats.max_score = score;
	
