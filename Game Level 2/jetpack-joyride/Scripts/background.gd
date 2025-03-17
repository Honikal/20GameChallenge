class_name Background;
extends Node2D;

@onready var mountains_back: ParallaxLayer = $BackgroundHandle/BackgroundBack_2
@onready var mountains_front: ParallaxLayer = $BackgroundHandle/BackgroundBack
@onready var ground: ParallaxLayer = $ForegroundHandle/BackgroundFront

@export var GROUND_SPEED : float = -100.0;
@export var MOUNTAIN_FRONT_SPEED : float = -50.0;
@export var MOUNTAIN_BACK_SPEED : float = -35.0;

func _process(delta: float) -> void:
	ground.motion_offset.x += GROUND_SPEED * delta;
	mountains_front.motion_offset.x += MOUNTAIN_FRONT_SPEED * delta;
	mountains_back.motion_offset.x += MOUNTAIN_BACK_SPEED * delta;

func _increaseSpeed(percentage: float):
	#Incrementamos la velocidad dado cierto tiempo
	GROUND_SPEED += GROUND_SPEED * percentage;
	MOUNTAIN_FRONT_SPEED += MOUNTAIN_FRONT_SPEED * percentage;
	MOUNTAIN_BACK_SPEED += MOUNTAIN_BACK_SPEED * percentage;

func _stopMovement():
	#Seteamos todas las velocidades a 0
	GROUND_SPEED = 0;
	MOUNTAIN_FRONT_SPEED = 0;
	MOUNTAIN_BACK_SPEED = 0;
