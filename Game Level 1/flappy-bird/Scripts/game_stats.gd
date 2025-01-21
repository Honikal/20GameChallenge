class_name GameStats;
extends Resource;

#Manejamos setter de score y el de highscore como tal
@export var score: int = 0:
	set(value):
		score = value;
		print("Puntaje actualizado: ", score);
		score_changed.emit(score);
	
#Puntaje máximo obtenido en la partida
@export var highscore: int = 0;

#Acá ponemos la estructura de medallas obtenidas
@export var bronze_medal : bool = false;
@export var plate_medal : bool = false;
@export var gold_medal : bool = false;
@export var platinum_medal: bool = false;

#Aquí pondríamos los parámetros o velocidades por los cuales ir incrementando la velocidad

		
#Manejamos la emisión de señales para indicar cambios en puntuación
signal score_changed(new_score); #Puntos cambiados
