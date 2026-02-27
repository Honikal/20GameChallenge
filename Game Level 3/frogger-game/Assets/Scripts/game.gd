extends Node2D;

const AMOUNT_OF_ROWS = 11; #Cantidad de filas en las que spawnean obstáculos
const ROW_HEIGHT = 16;     #Cada fila es de 16 pixeles

var margin_x : int = 48;
var margin_y : int = 16;
var margin_appear: int = 8;

var playableArea : Rect2;
var rowPositions: Array; #Guardamos las posiciones en y dónde se colocarán los obstáculos

@export var carInstance : PackedScene;

#La escena del juego debe ser capaz de spawnear en 11 distintas líneas, los distintos posibles seres, y es acá
#dónde empieza lo difícil...

func _ready() -> void:
	#Seteamos el valor de posicionamiento o spawn
	playableArea = Rect2(
		margin_x,
		margin_y,
		get_viewport_rect().size.x - (margin_x * 2),  #Restamos el margin de ambos lados
		get_viewport_rect().size.y - (margin_y * 2)
	);
	
	#Calculamos la posición Y para cada fila
	for row in range(AMOUNT_OF_ROWS):
		# Start from bottom and move up
		var y_pos = playableArea.end.y - ROW_HEIGHT - (row * ROW_HEIGHT)
		rowPositions.append(y_pos)
	
	print("Posiciones para spawnear en el mapa:", playableArea);
	print("Posiciones de filas y: ", rowPositions);
	
	#Spawneamos a los obstáculos
	_spawn_obstacles();

func _spawn_obstacles():
	#Nos encargamos de iterar en las distintas posiciones para definir dónde debe spawnear la creación
	for row in range(AMOUNT_OF_ROWS):
		#Spawneamos carros en la fila 0 en adelante
		if (row < 5):
			var newObstacle : Obstacle = carInstance.instantiate();
			_decide_position_spawn(newObstacle, row);
			add_child(newObstacle);
			print("Spawneamos un obstáculo en la fila: ", row, "   en la posición: ", rowPositions[row]);

func _decide_position_spawn(obstacle: Obstacle, row: int):
	var rand = randi_range(0,1);
	var y_pos = rowPositions[row];
	
	if (rand == 0): #Aparece desde la izquierda, va hacia la derecha
		obstacle.global_position = Vector2(
			playableArea.position.x - margin_appear, 
			y_pos
		);
		obstacle.DIRECTION = obstacle.directionToMove.RIGHT;
	else: #Aparece desde la derecha, va hacia la izquierda
		obstacle.global_position = Vector2(
			playableArea.end.x + margin_appear,
			y_pos
		)
		obstacle.DIRECTION = obstacle.directionToMove.LEFT;
