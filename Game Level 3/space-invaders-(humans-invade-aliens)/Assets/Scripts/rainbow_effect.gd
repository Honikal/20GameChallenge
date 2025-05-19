extends RichTextEffect;

var bbcode = "rainbow";
func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var speed  = char_fx.env.get("freq", 1.0);
	var hue = fmod(char_fx.elapsed_time * speed, 1.0);
	char_fx.color = Color.from_hsv(hue, 0.8, 1.0);
	return true;
