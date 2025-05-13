extends Node

var enemyGroups = [];
var enemyInstance = preload("res://Assets/Scenes/Enemy.tscn");
var SCREEN_SIZE = Vector2i(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
);
var Margin = Vector2i(
	32,
	12
);
var Spacing = Vector2i(
	16,
	24
)

func _ready() -> void:
	#Spawneamos a los distintos aviones
	_spawner();

func _process(delta: float) -> void:
	#Llamamos al método que se encargará de cambiar la posición por turno
	_enemyGroupMovement();		

func _spawner():
	#Empezamos a iterar por cantidad de objetos
	for col in range(1, 11):
		var enemiesCol = [];
		for row in range(1, 6):
			var newEnemy : Enemy = enemyInstance.instantiate();
			newEnemy.global_position = Vector2(
				(Margin.x * col) + (Spacing.x * (col-1)),
				(Margin.y * row) + (Spacing.y * (row-1))
			);
			#Manejamos con el valor de columna - 1
			add_child(newEnemy);
			newEnemy.tree_exited.connect(_filterEnemy.bind(newEnemy));
			newEnemy._manage_ship(col - 1);
			enemiesCol.append(newEnemy);
		enemyGroups.append(enemiesCol);
	_updateEnemiesCanShoot();

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
	
	if (groupDir > 0 and rightMore.position.x > (SCREEN_SIZE.x - Margin.x)):
		_changeEnemyMovement();
	elif (groupDir < 0 and leftMore.position.x < Margin.x):
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
	_updateEnemiesCanShoot();
	
func _updateEnemiesCanShoot():
	for col in enemyGroups:
		#Primero checamos el caso que la columna esté vacía
		if (col.is_empty()):
			continue;
		
		#Ahora, 
		
		#De ésta lista, seteamos al enemigo más al frente
		var front_enemy : Enemy = col[-1];
		front_enemy.canItShoot = true;
