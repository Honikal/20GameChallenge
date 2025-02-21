class_name Brick;
extends StaticBody2D;

#Tenemos acceso al frame como tal, por color como tal
@export var frame_color: int = 0;
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Modificamos el color o frame de animación basado en la variable frame_color (tenemos de 0 a 3)
	sprite_2d.frame = frame_color;
