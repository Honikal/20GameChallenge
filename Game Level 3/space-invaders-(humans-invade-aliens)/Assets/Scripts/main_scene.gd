extends Node

@export var game_stats: GameStats;

#Manejo para el sistema de spawn
var enemyGroups = [];
var bunkerGroup = [];
var player : Player = null;

var playerInstance = preload("res://Assets/Scenes/Player.tscn");
var enemyInstance = preload("res://Assets/Scenes/Enemy.tscn");
var bunkerInstance = preload("res://Assets/Scenes/Bunkers.tscn");

const LEVELSOUND = preload("res://Assets/Sounds/level_up.wav");

#Valores importantes en posición y tamaños
var SCREEN_SIZE;
var baseResolution = Vector2(640, 360);
var scaleFactor;
var MARGIN  = Vector2(16,  12);
var SPACING = Vector2(16,  24);
var bunker_y = 70;
var bnkMargin; #Margin X de las posiciones de bunkers
var playerPos = Vector2(320, 320); #Posición x y y del jugador, basada en el ancho y la altura de la pantalla

#Manejamos valores numerales
const AMOUNT_OF_ROWS = 5;
const AMOUNT_OF_COLUMNS = 10;
var currentLevel = 1;

#Manejo para el control de UI y el game loop
var currentLives : int;
@export var lives_container: HBoxContainer;
@onready var score_val: Label = $UI_Management/UI_ScoreSection/Container/HighscoreSection/scoreVal
@onready var hscore_val: Label = $UI_Management/UI_ScoreSection/Container/HighscoreSection/highscoreVal
@onready var lifes_lbl: Label = $UI_Management/UI_Lives/Container/lifesLbl
@onready var level_lbl: Label = $UI_Management/UI_Lives/Container/levelLbl

@onready var gameover_lbl: RichTextLabel = $UI_Management/UI_ScoreSection/Container/GameOverLbl
@onready var anim_over: AnimationPlayer = $UI_Management/UI_ScoreSection/Container/GameOverLbl/AnimationPlayer

@onready var ui_level_up: Panel = $UI_Management/UI_ScoreLevelUp
@onready var bunkers_value: Label = $UI_Management/UI_ScoreLevelUp/VBoxContainer/ScoreSection/BunkerSection/bunkersValue

#Timers a usar
@onready var timer_to_respawn: Timer = $timerToRespawn
#@onready var timer_to_transition: Timer = $timerToTransition

#Variables para manejar guardado
const SAVE_PATH = "user://save.cfg";
const TEST_SAVE_PATH = "res://save.cfg";
var save_path = SAVE_PATH;

var gameover : bool = false;

func _scalingValues():
	SCREEN_SIZE = get_window().size;
	bnkMargin = Vector2i(SCREEN_SIZE.x / 4, SCREEN_SIZE.x / 8);
	scaleFactor = get_viewport().get_visible_rect().size / baseResolution;
	MARGIN  = MARGIN * scaleFactor;
	SPACING = MARGIN * scaleFactor;

func _ready() -> void:
	randomize();
	
	#Función encargada de aplicar scaleo a las pantallas
	_scalingValues();
	
	#Manejamos los datos de resolución como tal
	var base_resolution = Vector2(640, 360);
	var current_resolution = get_window().size;
	
	game_stats.score = 0;
	game_stats.highestLevelAwarded = floor(game_stats.score / game_stats.pointsToLevel);
	
	#Llamamos al highscore para ver que tenemos
	_load_highscore();
	
	#Seteamos cosas del sistema de UI
	currentLives = game_stats.lifes;
	_update_score_display();
	_update_lifes_display();
	
	gameover_lbl.visible = false;
	ui_level_up.visible = false;
	
	timer_to_respawn.timeout.connect(_resume_game);
	
	#Spawneamos a los distintos aviones y al jugador
	_generatePlayer();
	_spawner();
	
func _process(delta: float) -> void:
	#Llamamos al método que se encargará de cambiar la posición por turno
	_enemyGroupMovement();		

#Funciones del juego
func _spawner():
	#Empezamos a iterar por cantidad de objetos
	
	#Spawneamos enemigos
	for col in range(1, AMOUNT_OF_COLUMNS+1):
		var enemiesCol = [];
		for row in range(1, AMOUNT_OF_ROWS+1):
			var newEnemy : Enemy = enemyInstance.instantiate();
			newEnemy.global_position = Vector2(
				(MARGIN.x * col) + (SPACING.x * (col-1)),
				(MARGIN.y * row) + (SPACING.y * (row-1))
			);
			#Manejamos con el valor de columna - 1
			add_child(newEnemy);
			newEnemy._setSpeedPerLevel(currentLevel);
			newEnemy.scale = scaleFactor;
			newEnemy.tree_exited.connect(_manageEnemyDead.bind(newEnemy, row));
			newEnemy._manage_ship(row - 1);
			enemiesCol.append(newEnemy);
		enemyGroups.append(enemiesCol);
	
	#Spawneamos bunkers
	for i_bunker in range(1, 5):
		var newBunker : Bunker = bunkerInstance.instantiate();
		newBunker.global_position = Vector2(
			(bnkMargin.x * i_bunker) - bnkMargin.y,
			SCREEN_SIZE.y - bunker_y
		);
		add_child(newBunker);
		newBunker.scale = scaleFactor;
		newBunker.tree_exited.connect(_filterBunker.bind(newBunker));
		bunkerGroup.append(newBunker);
	
	#Llamamos al método para permitir que puedan disparar desde el inicio
	_updateEnemiesCanShoot(true);

func _enemyGroupMovement():
	#Checamos que no los enemigos
	if (enemyGroups.is_empty()):
		return;			#No hay enemigos para moverse
	
	#Agarramos al enemigo en la posición final de cualquier fila para determinar su movimiento
	var rightMore: Enemy = _checkExistenceEnemies(-1);	#Checamos última columna, primer fila
	var leftMore: Enemy  = _checkExistenceEnemies(0);   #Checamos primer columna, primer fila
	
	#En caso de que _filterEnemy no funcione, debería activarse esto
	if (not rightMore or not leftMore):
		print("Acá se tira error por valores");
		return;
	
	var groupDir = rightMore.direction_x       #Checar dirección actual
	
	if (groupDir > 0 and rightMore.position.x > (SCREEN_SIZE.x - MARGIN.x)):
		_changeEnemyMovement();
	elif (groupDir < 0 and leftMore.position.x < MARGIN.x):
		_changeEnemyMovement();
		
func _checkExistenceEnemies(col: int):
	for enemy in enemyGroups[col]:
		if (is_instance_valid(enemy)):
			return enemy
	return null;
		
func _changeEnemyMovement():
	for i in range(enemyGroups.size()):
		var column = enemyGroups[i];
		for j in range(column.size()):
			var enemy = column[j];
			if (is_instance_valid(enemy)):
				#Cambiamos dirección del enemigo
				enemy.direction_x *= -1;
				#Incrementamos la distancia de drop
				enemy.position.y += enemy.dropDistance;
			
func _filterEnemy(enemy_to_delete):
	#Primero eliminamos enemigos inválidos de cada columna
	for i in range(enemyGroups.size()):
		enemyGroups[i] = enemyGroups[i].filter(
			func(e):
				return e != enemy_to_delete
		)
	#Luego, eliminamos las columnas que están vacías
	enemyGroups = enemyGroups.filter(
		func (col):
			return not col.is_empty()
	)
	
	#Checamos si no hay más enemigos en la lista
	if (enemyGroups.size() <= 0):
		_new_level();
	
	#Actualizamos los enemigos que pueden disparar
	_updateEnemiesCanShoot(true);
	
func _filterBunker(bunker_to_delete):
	#Filtramos los bunkers de la lista de bunkers
	bunkerGroup = bunkerGroup.filter(
		func(b):
			return b != bunker_to_delete
	)
	
func _updateEnemiesCanShoot(value: bool):
	for col in enemyGroups:
		#Primero checamos el caso que la columna esté vacía
		if (col.is_empty()):
			continue;
		
		#De ésta lista, seteamos al enemigo más al frente
		var front_enemy : Enemy = col[-1];
		front_enemy.canItShoot = value;

func _updateEnemiesCanMove(value: bool):
	#Ésta función recibe un valor y asigna a todos los enemigos ese valor booleano
	#para indicar si se permite movimiento o no
	for listEnemies in enemyGroups:
		for enemy : Enemy in listEnemies:
			enemy._setMove(value);
			
func _updateEnemiesSpeed():
	#Asignamos un valor inicial de total existente de enemigos
	var totalInitial = AMOUNT_OF_COLUMNS * AMOUNT_OF_ROWS;
	var remaining = 0; #Acá mantendremos el total de columnas restantes
	
	#Vamos a definir el valor restante de columnas actuales
	for col in enemyGroups:
		remaining += col.size();
	
	#Este valor será usado para determinar la velocidad del enemigo	
	var deathFraction = 1.0 - float(remaining) / totalInitial;
	
	#Ahora, definiremos la velocidad de los enemigos
	for col in enemyGroups:
		for e: Enemy in col:
			if (is_instance_valid(e)):
				e._setNewSpeed(deathFraction);

func _generatePlayer():
	#Creamos el objeto y lo agregamos a la escena
	var newPlayer: Player = playerInstance.instantiate();
	newPlayer.global_position = playerPos;
	newPlayer.scale = scaleFactor;
	add_child(newPlayer);
	
	#Guardamos la referencia del jugador acá
	player = newPlayer;
	
	newPlayer.tree_exited.connect(_update_game_status);

func _updateScore(row: int):
	#Actualizamos el puntaje de nuestra partida
	#Acá para eso primero que determinar matemáticamente algo, conforme la fila dividida entre 0, debemos de
	#aplicar un ceil a la división, y multiplicar dicho valor por 10
	#Sin embargo, tenemos que aplicar transposicion a la fila, para eso usaremos el número de filas a crear
	var actualRow = (5 - row) + 1;
	var newValue = int(ceil(actualRow / 2.0));
	game_stats.score += newValue * 10;
	
	#Actualizamos la visualización del highscore
	_update_score_display();

func _update_game_status():
	#Checamos que el valor del booleano de actualización de puntaje no sea falso
	#if (transitionLevel):
	#	return;
	
	#Restamos una vida al grupo de vidas totales que tenemos
	currentLives -= 1;
	_update_lifes_display();
	
	#Detenemos movimiento del enemigo por un tiempo
	_updateEnemiesCanMove(false);
	_updateEnemiesCanShoot(false);
	
	#Checamos si llegamos a la cantidad de vida menor o igual a 0
	if (currentLives == 0):
		#Guardamos el highscore, y presentamos el game over
		_game_over();
	else:
		#Activamos un timer que detiene todo lo que sucede
		timer_to_respawn.start();

func _resume_game():
	#Ésta función se encarga de ejecutar el que puedan continuar moviéndose los enemigos,
	#y que el jugador respawnee
	_updateEnemiesCanMove(true);
	_updateEnemiesCanShoot(true);
	_generatePlayer();

#Funciones de la UI
func _update_score_display():
	score_val.text = str(game_stats.score);
	hscore_val.text = str(game_stats.highscore);
	
func _update_lifes_display():
	#Función encargada de administrar visualmente la vida de la partida
	#Limpiamos los posibles sprites previos que representan la vida
	for child in lives_container.get_children():
		child.queue_free();
		
	#Agregamos nueva cantidad de balones dependiendo de la cantidad de vidas actuales que se tienen
	for i in range(currentLives):
		#Creamos un texture o sprite mediante un texture rect
		var life_sprite = TextureRect.new();
		life_sprite.texture = preload("res://Assets/Sprites/alien_life.png");
		life_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED;
		lives_container.add_child(life_sprite);
		
	#Finalmente, modificamos también el label con la cantidad de vidas
	lifes_lbl.text = "Lifes: " + str(currentLives);

#Funciones finales del juego
func _manageEnemyDead(newEnemy: Enemy, row: int):
	#Acá en resumen pasamos al enemigo, retomamos la posible puntuación que éste daría, la incrementamos
	#en el juego, y llamamos al método de filtrado
	_updateScore(row);
	_filterEnemy(newEnemy);
	_updateEnemiesSpeed();

func _game_over():
	#Guardamos el puntaje del juego y actualizamos el highscore de ser necesario
	if (game_stats.score > game_stats.highscore):
		game_stats.highscore = game_stats.score;
		_update_score_display();
	
	_save_highscore();
	
	#Antes que nada, activamos la línea de texto visible
	gameover_lbl.visible = true;
	anim_over.play("txtAnimation");
	
	#Esperamos que la animación sea completada
	await anim_over.animation_finished;
	await get_tree().create_timer(1).timeout;
	
	#Cambiamos de escena
	gameover = true;
	SceneTransition._change_scene("menu");

func _new_level():
	#Para evitar el error al gameover o al salir
	if (gameover || !is_instance_valid(get_tree())):
		return;
	
	#Calculamos la bonus por bunkers al subir de nivel
	var bunkersLeft = bunkerGroup.size();
	var currentBonus = bunkersLeft * game_stats.bunkerBonus;
	
	#Mostramos la UI del level up
	ui_level_up.visible = true;
	bunkers_value.text = str(bunkersLeft);
	
	#Actualizamos el puntaje
	game_stats.score += currentBonus;
	_update_score_display();
	
	var bonusLives = game_stats.highestLevelAwarded - floor(game_stats.score / game_stats.pointsToLevel);
	if (bonusLives < 0):
		print("Si subimos de vida");
		#Solo aumentamos de vida si es menor a 3
		if (currentLevel < 3):
			currentLives+= 1;
		game_stats.highestLevelAwarded += 1;
		_update_lifes_display();
		
	SoundsManager._change_sound(LEVELSOUND);
	SoundsManager._assignVolume(1);
	SoundsManager._play_normal();
	
	await get_tree().create_timer(1).timeout;
	
	#Preparamos para el siguiente nivel
	currentLevel += 1;
	level_lbl.text = "Level: " + str(currentLevel);
	
	#Si el puntaje actual es múltiplo o superior al valor del puntaje esperado para subir de nivel, entonces... 
	#se sube de nivel
	
	#Limpiamos entidades
	_clear_entities();
	
	#Escondemos las UI y resumimos
	ui_level_up.visible = false;
	#transitionLevel = false;
	
	#Spawneamos nuevo nivel
	_spawner();
	_generatePlayer();
	
func _save_highscore():
	#Función encargada de setear o guardar el sistema o puntuación en el archivo
	var config = ConfigFile.new(); #Se crea un file sistem encargado de trabajar con el archivo de puntos
	
	#Seteamos o guardamos el puntaje, dentro de la sección game, en el value highscore
	#Ésto funciona similar a un struct o diccionario
	config.set_value("game", "highscore", game_stats.highscore);
	 
	#Y ahora guardamos en el ConfigFile en nuestro save_path
	config.save(save_path);
	
func _load_highscore():
	#Función encargada de el cargar el puntaje mayor guardado en la última partida
	var config = ConfigFile.new(); #Se crea un sistema para cargar archivos
	var error = config.load(save_path);
	
	#Checamos o validamos si existe un error
	if error != OK:
		#Si encontramos un error, retornamos
		print("Error encontrado");
		return;
		
	#Intentamos tomar el sistema de guardado, tomando el valor de puntaje o highscore
	game_stats.highscore = config.get_value("game", "highscore");

func _clear_entities():
	#Limpiamos la lista de enemigos
	enemyGroups.clear();
	
	#Limpiamos los bunkers
	for bunker in bunkerGroup:
		if (is_instance_valid(bunker)):
			bunker.queue_free();
	bunkerGroup.clear();
	
	#Quitamos al posible jugador en caso de que éste exista
	if (is_instance_valid(player)):
		print("Limpiamos al jugador");
		player.tree_exited.disconnect(_update_game_status);
		player.queue_free();
		player = null;
