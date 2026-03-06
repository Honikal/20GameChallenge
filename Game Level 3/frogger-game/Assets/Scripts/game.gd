extends Node2D;

@export var carInstance : PackedScene;
@export var playerInstance : PackedScene;

#La escena del juego debe ser capaz de spawnear en 11 distintas líneas, los distintos posibles seres, y es acá
#dónde empieza lo difícil...

func _ready() -> void:
	#Primero generamos distintas semilas
	randomize();
	
	#Usamos la variable global de GameStats
	#Spawneamos al jugador
	_spawn_player();
	
	#Spawneamos a los obstáculos
	_spawn_obstacles();
	
func _spawn_player():
	var newPlayer : Player = playerInstance.instantiate();
	
	#Posicionamos al jugador en el centro de nuestro punto de juego
	newPlayer.global_position = Vector2(
		GameStats.playableArea.position.x + (GameStats.playableArea.size.x / 2),
		GameStats.playableArea.end.y
	)
	add_child(newPlayer);
	print("Spawneamos al player en la posición: ", newPlayer.global_position);

func _spawn_obstacles():
	#Nos encargamos de iterar en las distintas posiciones para definir dónde debe spawnear la creación
	for row in range(GameStats.AMOUNT_OF_ROWS):
		#Spawneamos carros en la fila 0 en adelante
		if (row < 5):
			var newObstacle : Obstacle = carInstance.instantiate();
			_setup_obstacle(newObstacle, row);
			add_child(newObstacle);
			print("Spawneamos un obstáculo en la fila: ", row);

func _setup_obstacle(obstacle: Obstacle, row: int):
	var from_left = randi() % 2 == 0;
	
	#Seteamos la ubicación del obstáculo
	obstacle.global_position = GameStats._get_spawn_position(row, from_left);
	
	#Seteamos la dirección del obstáculo
	obstacle.direction = obstacle.Direction.RIGHT if from_left else obstacle.Direction.LEFT;
	
	
