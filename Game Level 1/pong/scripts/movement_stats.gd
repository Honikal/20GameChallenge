class_name MovementStats;
extends Resource;

#Manejamos como tal los datos de velocidad y tiempos como tal
@export var paddle_speed: int = 200;
@export var max_ball_speed: int = 100;
@export var ball_speed: int = max_ball_speed;
@export var acceleration: float = 0.125;
