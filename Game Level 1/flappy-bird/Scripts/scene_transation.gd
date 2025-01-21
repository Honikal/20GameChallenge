extends Node;

const menu_scene = preload("res://Objects/Menu.tscn");
const game_scene = preload("res://Objects/Main.tscn");
#const score_scene = preload("res://Objects/Scores.tscn");

func _change_scene(scene_tag):
	#Ésta función se encarga de determinar el cambio de escenas de forma sencilla
	var scene_to_load;
	
	match scene_tag:
		"menu":
			scene_to_load = menu_scene;
		"main":
			scene_to_load = game_scene;
		"scores":
			pass;
			
	if (scene_to_load != null):
		get_tree().change_scene_to_packed(scene_to_load);
		
