shader_type canvas_item;

//Acá estamos programando con C# para trabajar con shaders
//Este es el primer shader con el que trabajaremos, siendo el shader de efecto cuando se recibe daño

//Acá, deseamos aplicar un efecto tal vez transparente o blanco, que parpadee para representar el daño
uniform vec4 hit_flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool hit_flash_on = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	//Como dice la documentación, por cada pixel que sea visible se llamará esta función
	//Lo bueno de acá es que, podemos aprovecharnos de ésto y controlar un color encima de nuestro
	//sprite para dar un diseño esperado

	//Guardamos de forma local la luz y la textura de nuestra imagen
	vec4 sprite_color = texture(TEXTURE, UV);
	//Luego, con respecto al booleano, crearemos un color (sin alpha) al cual usaremos para dar un efecto de parpadeo
	vec3 final_rgb = hit_flash_on ? hit_flash_color.rgb : sprite_color.rgb;
	//Luego, asignaremos esto al color deseado a poner, sin embargo... usaremos el alpha original
	COLOR = vec4(final_rgb, sprite_color.a);


}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
