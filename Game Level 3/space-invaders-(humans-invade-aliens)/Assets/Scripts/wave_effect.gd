extends RichTextEffect;

var bbcode = "wave";
func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var amp  = char_fx.env.get("amp", 5.0);
	var freq = char_fx.env.get("freq", 2.0);
	char_fx.offset.y += sin(char_fx.elapsed_time * freq + char_fx.absolute_index * 0.1) * amp;
	return true;
