class_name Background
extends ParallaxBackground

@export var move_stats: MoveStats;

var stop_scroll = false;
#Función para detener la animación
func _stop_animation():
	stop_scroll = true;

func _process(delta: float) -> void:
	if (!stop_scroll):
		#Si la animación está encendido, entonces continuamos la animación (Siempre a multiplicar con delta)
		scroll_base_offset -= Vector2(move_stats.backgroundSpeed, 0) * delta;
