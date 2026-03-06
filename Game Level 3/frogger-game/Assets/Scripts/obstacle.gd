class_name Obstacle
extends CharacterBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

enum Direction {LEFT = -1, RIGHT = 1}

@export var direction: Direction = Direction.RIGHT;
@export var sprite_frame: int;
@export var moveStats: MoveStats;

func _ready() -> void:
	animated_sprite_2d.scale.x = direction;
	animated_sprite_2d.frame = sprite_frame;
	
func _physics_process(_delta: float) -> void:
	#Since it starts, then it starts moving to a direction
	#TODO: Modificar la velocidad de modo que el current speed esté basado matemáticamente en los niveles
	#transcurridos y similar
	
	velocity.x = direction * moveStats.current_speed;
	move_and_slide()
	
	#I thought of using the VisibleOnScreenNotifier... however, in the way I plan to use the screen...
	#it's not going to work, so I'll have to handle this by using the old method
	
	#Usamos el GameStats para checar que no se estén saliendo del área de juego
	if GameStats._is_out_of_bounds(global_position, direction):
		queue_free();
