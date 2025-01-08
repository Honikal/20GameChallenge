extends Node

#Generamos la posición del segundo jugador
const SECOND_PLAYER_POS_X = 600;
const SECOND_PLAYER_POS_Y = 160;

#Tomamos los objetos dentro de la escena
@onready var ball: Ball = $Ball
@onready var player_1: Node2D = $Player1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Checamos para iniciar la partida
	if Input.is_action_just_pressed("ui_accept"):
		ball._iniciar_movimiento();
