class_name Spawner
extends Node

#Exportamos las escenas a usar, y el mopve_stats
@export var bee_scene: PackedScene;
@export var bat_scene: PackedScene;
@export var move_stats: MoveStats;

#Extraemos altura y ancho de la pantalla, además de variables de spawn
const SPAWN_POINT : int = 200;
const SPAWN_RANGE : int = 80;
var SCREEN_WIDTH = ProjectSettings.get_setting("display/window/size/viewport_width");
var SCREEN_HEIGHT = ProjectSettings.get_setting("display/window/size/viewport_height");
	
func _handleSpawn():
	#Manejamos las distintas escenas
	var enemy_scenes = {
		"bee": bee_scene,
		"bat": bat_scene
	}
	#Primero, manejamos la posibilidad de spawnear un enemigo, o varios
	if (randf() < move_stats.groupSpawnCurrent):
		#Spawneamos un grupo de enemigos
		var group_type = ["bee", "bat"][randi() % 2];
		_spawn_enemy_group(enemy_scenes[group_type], group_type);
	else:
		#Spawneamos un solo enemigo
		print("Spawneamos un enemigo normal");
		var enemy_type = ["bee", "bat"][randi() % 2];
		_spawn_enemy_alone(enemy_scenes[enemy_type]);
	
func _setup_enemy(enemy, randomize_position: bool = false):
	if (randomize_position):
		#Primero, seleccionamos la ubicación de donde aparecer y lo creamos
		var spawn_x = SCREEN_WIDTH + SPAWN_POINT;
		var spawn_y = randf_range(SPAWN_RANGE, SCREEN_HEIGHT - SPAWN_RANGE);
		enemy.global_position = Vector2(spawn_x, spawn_y);
		
	#Setup normal para cada enemigo
	enemy.move_stats = move_stats; #Por si está en nulo cuando lo creamos
	add_child(enemy);

func _spawn_enemy_alone(enemy_type):
	print("Instanciamos enemigo solo");
	
	var enemy = enemy_type.instantiate();
	#Aplicamos setup al enemigo
	_setup_enemy(enemy, true);
	
	#Manejamos entonces probabilidades
	if (randf() < move_stats.formationCurrent):
		#Calculamos el peso total de oportunidades
		var total_weight = move_stats.horizontalBias + move_stats.verticalBias + move_stats.circleBias;
		
		#Probabilidad normalizada
		var rand_val = randf() * total_weight;
		var cumulative = 0.0
		
		#Check horizontal
		cumulative += move_stats.horizontalBias;
		if (rand_val < cumulative):
			print("Formación H");
			enemy.formation = Enemy.FORMATION_TYPE.H_LINE;
			return;
			
		#Check vertical
		cumulative += move_stats.verticalBias;
		if (rand_val < cumulative):
			print("Formación V");
			enemy.formation = Enemy.FORMATION_TYPE.V_LINE;
			return;
		
		#Hacemos círculo
		print("Formación C");
		enemy.formation = Enemy.FORMATION_TYPE.V_LINE;


func _spawn_enemy_group(enemy_scene, group_type):
	#Acá tenemos que manejarlo de forma distinta, primero, manejamos el punto de aparición y la cantidad a spawnear
	#Hacemos que sea de un grupo de 3 a un grupo de 5
	var group_size : int = randi_range(3, 5);
	var base_position = Vector2(SCREEN_WIDTH + SPAWN_POINT,
								randf_range(SPAWN_RANGE, SCREEN_HEIGHT - SPAWN_RANGE - 50));
	
	#Ahora usamos un match case para decirdir el cómo se mueven
	match group_type:
		"bee":
			#Se mueven en línea recta, de forma horizontal o vertical
			if (randf() < 0.5):
				print("Spawneamos una línea horizontal");
				_spawn_obstacle_horizontally(enemy_scene, base_position, group_size);
			else:
				print("Spawneamos una línea vertical");
				_spawn_obstacle_vertically(enemy_scene, base_position, group_size);
		"bat":
			#Spawneamos los murciélagos como círculo
			print("Spawneamos un círculo");
			_spawn_obstacle_in_circle(enemy_scene, base_position, group_size);
		
func _spawn_obstacle_horizontally(enemy_scene, position, count):
	print("Llamamos horizontal")
	var spacing = move_stats.enemyLineSpacing;	
	#Posición de inicio para spawnear y moverse
	var start_x = position.x - (spacing * (count - 1)) / 2;
	
	for i in count:
		var enemy = enemy_scene.instantiate();
		enemy.global_position = Vector2(
			start_x + (i * spacing), 
			position.y
		);
		_setup_enemy(enemy);
		
func _spawn_obstacle_vertically(enemy_scene, position, count):
	print("Llamamos vertical")
	var spacing = move_stats.enemyLineSpacing;
	#Posición de inicio para spawnear y moverse
	var start_y = position.y - (spacing * (count - 1)) / 2;
	for i in count:
		var enemy = enemy_scene.instantiate();
		enemy.global_position = Vector2(
			position.x,
			position.y + (i * spacing)
		);
		_setup_enemy(enemy);
		
func _spawn_obstacle_in_circle(enemy_scene, center_position, count):
	#Acá, manejamos distinto, usaremos el valor de posición como el punto sobre el cual daremos vuelta
	#Y lo usaremos con un radio
	var radius = move_stats.enemyCircleRadius;
	var angle_step = TAU / count;
	var currentAngle = 0;
	
	for i in count:
		var enemy = enemy_scene.instantiate();
		#Acá, manejaremos matemática para spawnear el rango del enemigo
		var offset = Vector2(
			cos(currentAngle) * radius,
			sin(currentAngle) * radius
		)
		#Colocamos al enemigo basado en la posición del centro y el offset conseguido
		enemy.global_position = center_position + offset;
		_setup_enemy(enemy);
		
		#Agregamos un gap incrementando la ubicación
		currentAngle += angle_step * 2;
		if (currentAngle >= TAU):
			break;
