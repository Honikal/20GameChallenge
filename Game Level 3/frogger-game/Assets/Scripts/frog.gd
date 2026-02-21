extends CharacterBody2D

@onready var move_timer: Timer = $MoveTimer

var canMove = true;
var movement = 16
var isMoving = false;
var targetPosition = Vector2.ZERO;

func _ready() -> void:
	move_timer.timeout.connect(_finish_move)

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
		isMoving = true;
		canMove = false;
		
		#Creamos una animación de tween
		var tween = create_tween();
		
		targetPosition = global_position + moveDirection * movement;
		tween.tween_property(self, "position", targetPosition, 1);
		print ("g_p: ", global_position, "\n t_p: ", targetPosition);
		move_timer.start();
