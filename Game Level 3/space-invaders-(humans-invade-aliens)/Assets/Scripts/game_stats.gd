class_name GameStats;
extends Resource;

#Manejamos acá setters para score y highscore
@export var score: int = 0:
	set(value):
		score = value;
		score_changed.emit(score);

#Puntaje maximo obtenido en la partida
@export var highscore: int = 0;

#Bonus de puntaje conseguido por 
@export var bunkerBonus: int = 150;

#Puntaje requerido para conseguir una vida (2500 puntos por cada vida)
@export var pointsToLevel: int = 2500;
@export var highestLevelAwarded: int = 0;

#Manejamos acá sistema de manejo de vidas actuales
@export var lifes: int = 3;
@export var bunkersHealth: int = 5; # 5 golpes hasta que un bunker desaparezca

#Manejamos la emisión de señal para indicar los cambios en la puntuación
signal score_changed(new_score: int); 
