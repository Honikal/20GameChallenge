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
	
	#Llamamos la función o señal para checar cuando el balón o un objeto colisiona con el ladrillo
	area_2d.body_entered.connect(_destruir_ladrillo);
	

func _destruir_ladrillo(actor: Node2D):
	#Acá haremos que se ejecute el rebote de la función, aunque para ésto hay que hacer un método de casting del actor, y hacer
	#también la función de rebote
	
	
	#Una vez aplicado el rebote, liberamos del sistema el bloque
	queue_free();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#El bloque no hace nada como tal, no se mueve, no se hace nada inicialmente
	pass
