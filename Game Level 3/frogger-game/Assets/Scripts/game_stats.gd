class_name GameStats;
extends Resource;

#Manejamos acá setters para score y highscore
@export var score: int = 0:
	set(value):
		score = value;
		score_changed.emit(score);

#Puntaje máximo obtenido en la partida
@export var highscore: int = 0;
		
#Manejamos la emisión de señal para indicar los cambios en la puntuación
signal score_changed(new_score: int); 
