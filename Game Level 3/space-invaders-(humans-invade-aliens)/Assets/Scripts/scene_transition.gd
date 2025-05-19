extends Node;

#Tomamos acceso a las páginas del juego
const menu_scene = preload("res://Assets/Scenes/MenuScene.tscn");
const game_scene = preload("res://Assets/Scenes/MainScene.tscn");

#Creamos una función que se encarga de intercambiar globalmente escenas de forma sencilla
func _change_scene(scene_tag: String):
	#Para evadir posibles errores
	if (!is_instance_valid(get_tree())):
		return;
	
	var scene_to_load;
	
	match scene_tag:
		"menu":
			scene_to_load = menu_scene;
		"game":
			scene_to_load = game_scene;
	
	if (scene_to_load != null):
		get_tree().change_scene_to_packed(scene_to_load);
