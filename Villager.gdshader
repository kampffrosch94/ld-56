shader_type canvas_item;
uniform float red = 1.0; // you can assign a default value to uniforms
uniform float green = 1.0; // you can assign a default value to uniforms
uniform float blue = 1.0; // you can assign a default value to uniforms

uniform vec3 shirt_color = vec3(1.0, 1.0, 1.0);

void vertex() {
}

void fragment() {
	COLOR = texture(TEXTURE, UV); // Read from texture
	if (COLOR.r >= 0.98 && COLOR.b >= 0.98 && COLOR.g >= 0.98){
		COLOR = vec4(shirt_color, 1.0);
	}
	COLOR = vec4(COLOR.r * red, COLOR.g * green, COLOR.b * blue, COLOR.a);
}