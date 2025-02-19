class_name Brick
extends Node2D

#Tenemos acceso al frame como tal, por color como tal
@export var frame_color: int = 0;

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Modificamos el color o frame de animación basado en la variable frame_color (tenemos de 0 a 3)
	sprite_2d.frame = frame_color;

# Called every frame. 'delta' is the elapsed time since the previous frame.
