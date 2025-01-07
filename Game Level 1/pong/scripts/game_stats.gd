class_name GameStats;
extends Resource;

#Información a mostrar del jugador 1 y 2
const PLAYER_1_WINS = "Jugador 1 gana"
const PLAYER_2_WINS = "Jugador 2 gana"

@export var scoreP1: int = 0:
	set(value):
		scoreP1 = value;
		if scoreP1 == max_score:
			player_wins.emit(PLAYER_1_WINS)
		print("Puntaje actualizado: ", scoreP1, " ", scoreP2);
		
		
@export var scoreP2: int = 0:
	set(value):
		scoreP2 = value;
		if scoreP2 == max_score:
			player_wins.emit(PLAYER_2_WINS)
		print("Puntaje actualizado: ", scoreP1, " ", scoreP2);
		
#Elegimos el modo de jugabilidad (IA / 2 jugadores)
@export var modoJuego: int = 0:
	set(value):
		modoJuego = value;
		print("Elegimos el modo de juego");
		if modoJuego == 0:
			print("Modo de juego VS IA");
		else:
			print("Modo de juego 2 jugadores");
			
#Tomamos el valor máximo de la partida seleccionado
@export var max_score: int = 1:
	set(value):
		max_score = value;
		print("Máxima puntuación en la partida: ", value);

#Activamos las señales como tal para emitir cambios de puntuación
signal score_changed(new_score_P1, new_score_P2);
signal player_wins(player_info);
