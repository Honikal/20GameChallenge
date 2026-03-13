extends Node;

#Manejamos acá setters para score, highscore, vidas y nivel
var score: int = 0:
	set(value):
		score = value;
		score_changed.emit(score);
		
		#Actualizamos también el highscore
		if score > highscore:
			highscore = score;

#Puntaje máximo obtenido en la partida
var highscore: int = 0;

#Manejamos el setter de vidas actuales (y colocamos un máximo)
var lives: int = 3:
	set(value):
		lives = max(0, value)   #Nunca va a ir debajo de 0
		lives_changed.emit(lives);
		if (lives <= 0):
			game_over.emit();

#Manejamos el setter de nivel actual en el que nos encontramos
var current_level: int = 1:
	set(value):
		current_level = value;
		level_changed.emit();

#Configuración del área de juego
var playableArea: Rect2;
var row_positions: Array = [];

#Constantes
const ROW_HEIGHT = 16;     #Cada fila es de 16 pixeles
const AMOUNT_OF_ROWS = 11; #Cantidad de filas en las que spawnean obstáculos
const MARGIN_X : int = 48;
const MARGIN_Y : int = 16;
const MARGIN_DIS : int = 8;   #Punto de desaparición del objeto obstáculo

#Manejamos la emisión de señal para indicar los cambios en la puntuación
signal score_changed(new_score: int); 

#Manejamos la emisión de señal para indicar cambios en el área
signal area_changed(new_area: Rect2);

#Manejamos la emisión de señal que indica un cambio en la cantidad de vidas
signal lives_changed(new_amount: int);

#Manejamos la emisión de señal que indica un cambio de nivel
signal level_changed();

#Emitimos la señal de GameOver
signal game_over();

func _ready() -> void:
	#Conectamos al viewport, de modo que el singleton, al ser el primero en cargarse, de una cargue
	#los datos de la pantalla necesarios
	get_tree().root.size_changed.connect(_update_playeable_area);
	_update_playeable_area();
	
func _update_playeable_area():
	#Calculamos el área de juego en base al viewport calculado
	var viewport = get_viewport();
	
	#Conseguimos el valor de escalado o básicamente, la constante o factor "a"
	var _content_scale = viewport.content_scale_factor;
	
	#Obtenemos el rectángulo visible en base a las coordenadas
	var visible_rect = viewport.get_visible_rect();
	
	playableArea = Rect2(
		MARGIN_X,
		MARGIN_Y,
		visible_rect.size.x - (MARGIN_X * 2),  #Restamos el margin de ambos lados
		visible_rect.size.y - (MARGIN_Y * 2)
	)
	#Recalculamos las posiciones de las filas (de importancia para el punto de spawn de los obstáculos)
	_calculate_row_positions();
	
	#Emitimos la señal de cambio de área de jugabilidad
	area_changed.emit(playableArea);
	print("Área de jugabilidad actualizada: ", playableArea);

func _calculate_row_positions():
	#Limpiamos el array de las posiciones
	row_positions.clear();
	
	#Calculamos la posición Y para cada fila
	for row in range(AMOUNT_OF_ROWS):
		# Empezamos desde abajo y nos movemos hacia arriba 
		# Es * 2 ya que hay que tomar en cuenta que la primera fila es del jugador
		var y_pos = playableArea.end.y - ROW_HEIGHT * 2 - (row * ROW_HEIGHT)
		row_positions.append(y_pos)
	print(row_positions);
	
#FUNCIONES DE UTILIDAD PARA OTROS OBJETOS
func _is_out_of_bounds(position: Vector2, direction: int):
	#Retorna true or false si llega a estar fuera de los boundaries, o si no se cumple dicho caso
	if (direction < 0): #Moviéndose hacia la izquierda
		return position.x < playableArea.position.x - MARGIN_DIS;
	else: #Moviéndose hacia la derecha
		return position.x > playableArea.end.x + MARGIN_DIS;

func _get_spawn_position(row: int, from_left: bool):
	#En base al valor, determinamos si spawnea desde la izquiera o desde qué posición
	var y_pos = row_positions[row];
	
	if (from_left):
		return Vector2(playableArea.position.x - MARGIN_DIS, y_pos);
	else:
		return Vector2(playableArea.end.x + MARGIN_DIS, y_pos);

func _is_valid_grid_position(pos: Vector2, grid_size: int = 16) -> bool:
	return (pos.x >= playableArea.position.x and 
	pos.x <= playableArea.end.x - grid_size and
	pos.y >= playableArea.position.y and 
	pos.y <= playableArea.end.y)
	
#LEVEL DATA MANAGEMENT
var level_data = {
	1: {
		"current_speeds": [25, 35, 40, 45, 50],
		"spawn_rate": [2.1, 2.3, 2.5, 1.9, 2.1],
		"direction_moving": [1, 0, 1, 1, 0], #Movimiento (derecha 1, izquierda 0)
		"timer": 60
	},
	2: {
		"current_speeds": [30, 35, 40, 45, 50],
		"spawn_rate": [1.3, 1.1, 0.9, 0.7,0.65],
		"direction_moving": [1, 0, 0, 1, 1],
		"timer": 55
	},
	3: {
		"current_speeds": [45, 55, 60, 65, 70],
		"spawn_rate": [1.3, 1.1, 0.7, 1.5, 1.1],
		"direction_moving": [1, 0, 1, 0, 0],
		"timer": 60
	}
}

func _get_current_level_speeds() -> Array:
	return level_data[current_level]["current_speeds"];	
func _get_current_level_spawn_rate() -> Array:
	return level_data[current_level]["spawn_rate"];
func _get_current_level_timer() -> Array:
	return level_data[current_level]["timer"];
func _get_current_level_direction() -> Array:
	return level_data[current_level]["direction_moving"];
