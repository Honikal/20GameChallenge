class_name Player
extends CharacterBody2D

@onready var move_timer: Timer = $MoveTimer

const GRID_SIZE = 16;
const MOVE_DURATION = 0.15;

var canMove = true;
var isMoving = false;
var targetPosition = Vector2.ZERO;

#Constantes del Grid de movimiento
var grid_width = 14  # 224 / 16 = 14 tiles horizontally
var grid_height = 13 # 208 / 16 = 13 tiles vertically (13 rows from bottom to top)

func _ready() -> void:
	move_timer.timeout.connect(_finish_move);
	
	#Opcional: (Aplicamos un snapped al grid)
	global_position = global_position.snapped(Vector2(GRID_SIZE, GRID_SIZE));

func _finish_move():
	canMove = true;
	isMoving = false;
	
func _physics_process(_delta: float) -> void:
	if (isMoving and !canMove):
		return;
		
	#Controlamos mediante un vector la dirección de movimiento
	var moveDirection = Vector2.ZERO;
		
	#Checamos por un solo movimiento único
	if (Input.is_action_just_pressed("ui_up") and not Input.is_action_just_pressed("ui_right")
		and not Input.is_action_just_pressed("ui_left")):
		moveDirection = Vector2.UP;
	elif (Input.is_action_just_pressed("ui_down") and not Input.is_action_just_pressed("ui_right")
		and not Input.is_action_just_pressed("ui_left")):
		moveDirection = Vector2.DOWN;
	elif (Input.is_action_just_pressed("ui_left") and not Input.is_action_just_pressed("ui_down")
		and not Input.is_action_just_pressed("ui_up")):
		moveDirection = Vector2.LEFT;	
	elif (Input.is_action_just_pressed("ui_right") and not Input.is_action_just_pressed("ui_down")
		and not Input.is_action_just_pressed("ui_up")):
		moveDirection = Vector2.RIGHT;	
		
	#Manejamos el movimiento
	if (moveDirection != Vector2.ZERO):
		var new_position = global_position + moveDirection * GRID_SIZE;
		
		#Validamos que el obstáculo no se pase del punto de aparición
		
		if GameStats._is_valid_grid_position(new_position, GRID_SIZE):
			_start_move(new_position);
		
		

func _start_move(new_position: Vector2):
	isMoving = true;
	canMove = false;
	
	var tween = create_tween();
	tween.tween_property(self, "global_position", new_position, MOVE_DURATION);
	move_timer.start(MOVE_DURATION);
