extends Node2D;

@export var carInstance : PackedScene;
@export var playerInstance : PackedScene;

var spawnTimers: Array = []; #Un array que contiene todos los timers del juego (se vacían cada que se sube de nivel)

@onready var spawnPlayerTimer: Timer = $SpawnPlayer

#La escena del juego debe ser capaz de spawnear en 11 distintas líneas, los distintos posibles seres, y es acá
#dónde empieza lo difícil...

func _ready() -> void:
	#Primero generamos distintas semilas
	randomize();
	
	#Usamos la variable global de GameStats
	#Spawneamos al jugador
	_spawn_player();
	
	#Manejamos el sistema de spawn
	_setup_obstacle_spawning();
	
	#Conectamos la señal para cada vez que el timer sea reproducido, entonces spawnear el jugador
	spawnPlayerTimer.timeout.connect(_spawn_player);
	
	queue_redraw();
	
func _spawn_player():
	var newPlayer : Player = playerInstance.instantiate();
	
	#Posicionamos al jugador en el centro de nuestro punto de juego
	newPlayer.global_position = Vector2(
		GameStats.playableArea.position.x + (GameStats.playableArea.size.x / 2),
		GameStats.playableArea.end.y - GameStats.MARGIN_Y
	)
	add_child(newPlayer);
	print("Spawneamos al player en la posición: ", newPlayer.global_position);

func _setup_obstacle_spawning():
	#Acá nos encargamos de manejar la creación de timers para generar los obstáculos
	
	#Nos encargamos de iterar en las distintas posiciones para definir dónde debe spawnear la creación
	for row in range(GameStats.AMOUNT_OF_ROWS):
		#Primero spawneamos la lista de carros en la fila 0 en adelante
		if (row < 5): #Por mientras
			var timer = Timer.new();
			timer.wait_time = GameStats._get_current_level_spawn_rate()[row];
			timer.timeout.connect(_spawn_obstacles.bind(row))
			timer.autostart = true;
			add_child(timer);
			spawnTimers.append(timer);

func _player_dies():
	spawnPlayerTimer.start();

func _spawn_obstacles(row: int):
	#Modificamos el método de spawn, ahora acá nos encargamos de generar el tipo de obstáculo
	if (row < 5):
		#En fila 1 hasta la 5 generamos carros
		var newObstacle : Car_Obstacle = carInstance.instantiate();
		
		_setup_obstacle(newObstacle, row);
		#Seteamos la velocidad en base al valor
		newObstacle.current_speed = GameStats._get_current_level_speeds()[row];
		
		#Agregamos la escena
		add_child(newObstacle);
		
		#Seteamos el frame
		newObstacle._change_appeareance(row);
		
func _setup_obstacle(obstacle: Obstacle, row: int):
	var from_left = GameStats._get_current_level_direction()[row];
	
	#Seteamos la ubicación del obstáculo
	obstacle.global_position = GameStats._get_spawn_position(row, from_left);
	
	#Seteamos la dirección del obstáculo
	obstacle.direction = obstacle.Direction.RIGHT if from_left else obstacle.Direction.LEFT;
	
func _draw():
	"""
	Esta función es encargada para debugging, para poder observar si se está usando de forma correcta el GRID
	"""
	if (not Engine.is_editor_hint()):
		#Dibujamos el grid
		var grid_size = 16;
		var area = GameStats.playableArea;
		
		#Dibujamos líneas verticales
		for x in range(area.position.x, area.end.x + grid_size, grid_size):
			draw_line(
				Vector2(x, area.position.y),
				Vector2(x, area.end.y),
				Color(1,1,1,0.2), 1
			)
		
		#Dibujamos líneas horizontales
		for y in range(area.position.y, area.end.y + grid_size, grid_size):
			draw_line(
				Vector2(area.position.x, y),
				Vector2(area.end.x, y),
				Color(1,1,1,0.2), 1
			)
			
