class_name GameStats;
extends Resource;

#Manejamos acá para actualizar el score y highscore
@export var score : int = 0:
	set (value):
		score = value;
		score_changed.emit(score);

#Puntaje o recorrido máximo obtenido en la partida
@export var highscore : int = 0;

@export var difficultyCurve: float = 1500.0;

#Creamos una señal para indicar el cambio en la puntuación
signal score_changed(new_score: int);
