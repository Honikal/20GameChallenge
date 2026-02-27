class_name Obstacle
extends CharacterBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum directionToMove {LEFT = -1, RIGHT = 1}
@export var DIRECTION: directionToMove = directionToMove.RIGHT;
@export var SPRITE_FRAME: int;
@export var moveStats: MoveStats;

#Ésto lo utilizaba antes para checar si el objeto salía de la visión, ahora uso ésto
var margin = 48;       #48 es la distancia normal entre el punto de puntuación, y 16 es usualmente el tamaño del sprite
var margin_appear = 8; #8 pixeles hasta que desaparezca
var isOutOfBounds = false;
var game_bounds : Rect2; #Es mejor usar un Rect2 que usar un Vector

func _ready() -> void:
	#Agarramos el límite del juego
	game_bounds = get_viewport_rect();
	
	#Si el spawn es hacia la izquierda, va a ver hacia la derecha, y si es al revés, entonces hacia la izquierda
	scale.x *= DIRECTION;
	print("Límites dentro del juego: ", game_bounds)

func _physics_process(_delta: float) -> void:
	#Since it starts, then it starts moving to a direction
	#TODO: Modificar la velocidad de modo que el current speed esté basado matemáticamente en los niveles
	#transcurridos y similar
	
	velocity.x = DIRECTION * moveStats.current_speed;
	move_and_slide()
	
	#I thought of using the VisibleOnScreenNotifier... however, in the way I plan to use the screen...
	#it's not going to work, so I'll have to handle this by using the old method
	if (DIRECTION == directionToMove.LEFT and global_position.x < margin - margin_appear):
		queue_free();
	elif (DIRECTION == directionToMove.RIGHT and global_position.x > game_bounds.size.x - margin + margin_appear):
		queue_free();
