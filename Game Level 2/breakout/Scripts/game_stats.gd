class_name Game_Stats;
extends Resource

#Manejamos acá setters para score y highscore
@export var score: int = 0:
	set(value):
		score = value;
		score_changed.emit(score);

#Puntaje maximo obtenido en la partida
@export var highscore: int = 0;

#Manejamos acá sistema de manejo de vidas actuales
@export var lifes: int = 3;

#Manejamos la emisión de señal para indicar los cambios en la puntuación
signal score_changed(new_score: int); 
