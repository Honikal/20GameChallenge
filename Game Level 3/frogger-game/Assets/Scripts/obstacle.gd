class_name Obstacle
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const GRID_SIZE = 16;
const HALF_GRID = 8;

enum Direction {LEFT = -1, RIGHT = 1}

@export var direction: Direction = Direction.RIGHT;
var current_speed : float = 0;

#Señales para comunicarse con el jugador
signal player_entered(player: Player);
signal player_exited(player: Player);

func _ready() -> void:
	if (animated_sprite_2d):
		animated_sprite_2d.scale.x = direction;
	_snap_to_grid_continuos();
	
func _snap_to_grid_continuos():	
	#Previamente estaba usando éste, ya que es el mismo que uso para Player, sin embargo, llegó el caso de otros problemas
	#como el uso de un offset distinto, y además... no era suficiente ya que se movía extraño
	
	#Éste se encarga de ser llamado de forma continua y de simplemente encargarse que se mantenga en un y siempre
	#Dado que su movimiento en X es continuo, no requiere de ésto... solamente requiere snap en y
	
	#Snap Y en centro de la fila
	var snap_y = floor(global_position.y / GRID_SIZE) * GRID_SIZE + HALF_GRID;
	global_position.y = snap_y;

func _physics_process(delta: float) -> void:
	#Since it starts, then it starts moving to a direction
	#Hicimos cambio de tipo de CharacterBody2D a AnimatableObject2D, podemos usar move and collide
	var movement = Vector2(direction * current_speed * delta, 0);
	move_and_collide(movement)

	#I thought of using the VisibleOnScreenNotifier... however, in the way I plan to use the screen...
	#it's not going to work, so I'll have to handle this by using the old method
	
	#Hacemos un chequeo continuo que siga en el mismo centro del y
	_snap_to_grid_continuos();

	#Usamos el GameStats para checar que no se estén saliendo del área de juego
	if GameStats._is_out_of_bounds(global_position, direction):
			queue_free();

#Función abstracta que la clase hija usa para definir comportamiento
func on_player_collision(player: Player) -> void:
	pass
